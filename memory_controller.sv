module memory_controller (
    input clk, //Step 1: module interface
    input rst,

    input read_en,
    input write_en,
    input [7:0] addr,
    input [7:0] write_data,

    output reg [7:0] read_data,
    output reg ready
);

    // Step 2: parameters
    parameter READ_LATENCY = 3;
    parameter WRITE_LATENCY = 2;
    parameter REFRESH_INTERVAL = 20;
    parameter REFRESH_CYCLES = 3;
    parameter BURST_LENGTH = 4;

    // Step 3: FSM states
    typedef enum reg [1:0] {
        IDLE,
        READ,
        WRITE,
        REFRESH
    } state_t;

    state_t state;

    // Step 4: internal memory
    reg [7:0] memory [0:255];

    // Simulation initialization
    integer i;
    initial begin
        for (i = 0; i < 256; i = i + 1)
         memory[i] = 8'd0;
    end

    // Internal registers
    reg [7:0] addr_latched;
    reg [7:0] write_data_latched;
    reg [7:0] burst_count;

    integer latency_counter;
    integer refresh_counter;
    integer refresh_timer;

    // Step 5: main sequential logic

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            ready <= 1'b1;
            read_data <= 8'd0;

            addr_latched <= 8'd0;
            write_data_latched <= 8'd0;
            burst_count <= 8'd0;

            latency_counter <= 0;
            refresh_counter <= 0;
            refresh_timer <= 0;
        end else begin
            // Default: count cycles toward next refresh
            refresh_counter <= refresh_counter + 1;

            case (state)
                IDLE: begin
                    ready <= 1'b1;
                    burst_count <= 0;

                    // Refresh has highest priority
                    if (refresh_counter >= REFRESH_INTERVAL) begin
                        state <= REFRESH;
                        ready <= 1'b0;
                        refresh_timer <= 0;
                        refresh_counter <= 0;
                    end
                    else if (read_en) begin
                        state <= READ;
                        ready <= 1'b0;
                        addr_latched <= addr;
                        latency_counter <= 0;
                        burst_count <= 0;
                    end
                    else if (write_en) begin
                        state <= WRITE;
                        ready <= 1'b0;
                        addr_latched <= addr;
                        write_data_latched <= write_data;
                        latency_counter <= 0;
                        burst_count <= 0;
                    end
                end

                READ: begin
                    if (latency_counter < READ_LATENCY - 1) begin
                        latency_counter <= latency_counter + 1;
                    end else begin
                        read_data <= memory[addr_latched + burst_count];

                        if (burst_count < BURST_LENGTH - 1) begin
                            burst_count <= burst_count + 1;
                            latency_counter <= 0;
                        end else begin
                            state <= IDLE;
                            ready <= 1'b1;
                        end
                    end
                end

                WRITE: begin
                    if (latency_counter < WRITE_LATENCY - 1) begin
                        latency_counter <= latency_counter + 1;
                    end else begin
                        memory[addr_latched + burst_count] <= write_data_latched + burst_count;

                        if (burst_count < BURST_LENGTH - 1) begin
                            burst_count <= burst_count + 1;
                            latency_counter <= 0;
                        end else begin
                            state <= IDLE;
                            ready <= 1'b1;
                        end
                    end
                end

                REFRESH: begin
                    if (refresh_timer < REFRESH_CYCLES - 1) begin
                        refresh_timer <= refresh_timer + 1;
                        ready <= 1'b0;
                    end else begin
                        state <= IDLE;
                        ready <= 1'b1;
                    end
                end

                default: begin
                    state <= IDLE;
                    ready <= 1'b1;
                end
            endcase
        end
    end

endmodule