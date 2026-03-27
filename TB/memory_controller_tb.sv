`timescale 1ns/1ps

module memory_controller_tb;

    reg clk;
    reg rst;
    reg read_en;
    reg write_en;
    reg [7:0] addr;
    reg [7:0] write_data;

    wire [7:0] read_data;
    wire ready;

    // Instantiate DUT
    memory_controller dut (
        .clk(clk),
        .rst(rst),
        .read_en(read_en),
        .write_en(write_en),
        .addr(addr),
        .write_data(write_data),
        .read_data(read_data),
        .ready(ready)
    );

    // Clock generation: 10 ns period
    always #5 clk = ~clk;

    initial begin
        // Initialize inputs
        clk = 0;
        rst = 1;
        read_en = 0;
        write_en = 0;
        addr = 8'd0;
        write_data = 8'd0;

        // Dump waveform
        $dumpfile("memory_controller.vcd");
        $dumpvars(0, memory_controller_tb);

        // Apply reset
        #20;
        rst = 0;

        // -------------------------
        // Test 1: burst write
        // -------------------------
        @(posedge clk);
        if (ready) begin
            write_en <= 1;
            addr <= 8'd16;
            write_data <= 8'd100;
        end

        @(posedge clk);
        write_en <= 0;

        wait(ready == 1);

        // -------------------------
        // Test 2: burst read
        // -------------------------
        @(posedge clk);
        if (ready) begin
            read_en <= 1;
            addr <= 8'd16;
        end

        @(posedge clk);
        read_en <= 0;

        wait(ready == 1);

        // -------------------------
        // Test 3: wait for refresh
        // -------------------------
        repeat(25) @(posedge clk);

        // Try a read after refresh period
        @(posedge clk);
        if (ready) begin
            read_en <= 1;
            addr <= 8'd16;
        end

        @(posedge clk);
        read_en <= 0;

        wait(ready == 1);

        #50;
        $finish;
    end

    initial begin
        $display("time\tstate\tready\tr_en\tw_en\taddr\twdata\trdata\tburst\tlat\tref_cnt\tref_tmr");
        $monitor("%0t\t%0d\t%0b\t%0b\t%0b\t%0d\t%0d\t%0d\t%0d\t%0d\t%0d\t%0d",
                 $time, dut.state, ready, read_en, write_en, addr, write_data,
                 read_data, dut.burst_count, dut.latency_counter,
                 dut.refresh_counter, dut.refresh_timer);
    end

endmodule
