`timescale 1ns/1ps

module spi_master_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg miso;
    reg reset;
    reg start;
    wire cs;
    wire [7:0] data_out;
    wire data_ready;
    wire sck;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    spi_master dut (
        .clk(clk),
        .data_in(data_in),
        .miso(miso),
        .reset(reset),
        .start(start),
        .cs(cs),
        .data_out(data_out),
        .data_ready(data_ready),
        .sck(sck)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        start = 0;
        data_in = 8'h00;
        miso = 0;
        repeat(5) @(posedge clk);
        reset = 0;
        repeat(5) @(posedge clk);
    end
        endtask
    task testcase001;

        integer i;
        reg [7:0] miso_stream;
        begin
            test_num = test_num + 1;
            miso_stream = 8'h5A;
            $display("Test Case %0d: Data In = 0xA5, MISO Stream = 0x5A", test_num);
            reset_dut();

            data_in = 8'hA5;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;



            wait(cs == 0);
            miso = miso_stream[7];
            for (i = 6; i >= 0; i = i - 1) begin
                @(negedge sck);
                miso = miso_stream[i];
            end


            wait(data_ready == 1);
            repeat(2) @(posedge clk);


            #1;



            check_outputs(1'b1, 8'h5A, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        integer i;
        reg [7:0] miso_stream;
        begin
            test_num = test_num + 1;
            miso_stream = 8'h00;
            $display("Test Case %0d: Data In = 0xFF, MISO Stream = 0x00", test_num);
            reset_dut();

            data_in = 8'hFF;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(cs == 0);
            miso = miso_stream[7];
            for (i = 6; i >= 0; i = i - 1) begin
                @(negedge sck);
                miso = miso_stream[i];
            end

            wait(data_ready == 1);
            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b1, 8'h00, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        integer i;
        reg [7:0] miso_stream;
        begin
            test_num = test_num + 1;
            miso_stream = 8'hFF;
            $display("Test Case %0d: Data In = 0x00, MISO Stream = 0xFF", test_num);
            reset_dut();

            data_in = 8'h00;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(cs == 0);
            miso = miso_stream[7];
            for (i = 6; i >= 0; i = i - 1) begin
                @(negedge sck);
                miso = miso_stream[i];
            end

            wait(data_ready == 1);
            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b1, 8'hFF, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        integer i;
        reg [7:0] miso_stream;
        begin
            test_num = test_num + 1;
            miso_stream = 8'hAA;
            $display("Test Case %0d: Data In = 0x55, MISO Stream = 0xAA", test_num);
            reset_dut();

            data_in = 8'h55;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(cs == 0);
            miso = miso_stream[7];
            for (i = 6; i >= 0; i = i - 1) begin
                @(negedge sck);
                miso = miso_stream[i];
            end

            wait(data_ready == 1);
            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b1, 8'hAA, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        integer i;
        reg [7:0] miso_stream;
        begin
            test_num = test_num + 1;
            miso_stream = 8'h34;
            $display("Test Case %0d: Data In = 0x12, MISO Stream = 0x34", test_num);
            reset_dut();

            data_in = 8'h12;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(cs == 0);
            miso = miso_stream[7];
            for (i = 6; i >= 0; i = i - 1) begin
                @(negedge sck);
                miso = miso_stream[i];
            end

            wait(data_ready == 1);
            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b1, 8'h34, 1'b1, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("spi_master Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
// Print summary
        $display("\n========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Tests Passed: %0d", pass_count);
        $display("Tests Failed: %0d", fail_count);
        $display("Total Tests:  %0d", pass_count + fail_count);
        $display("========================================");

        if (fail_count == 0)
            $display("ALL TESTS PASSED!");
        else
            $display("SOME TESTS FAILED!");

        $display("\nSimulation completed at time %0t", $time);
        $finish;
    end

    // Task to check outputs
    task check_outputs;
        input expected_cs;
        input [7:0] expected_data_out;
        input expected_data_ready;
        input expected_sck;
        begin
            if (expected_cs === (expected_cs ^ cs ^ expected_cs) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_data_ready === (expected_data_ready ^ data_ready ^ expected_data_ready) &&
                expected_sck === (expected_sck ^ sck ^ expected_sck)) begin
                $display("PASS");
                $display("  Outputs: cs=%b, data_out=%h, data_ready=%b, sck=%b",
                         cs, data_out, data_ready, sck);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cs=%b, data_out=%h, data_ready=%b, sck=%b",
                         expected_cs, expected_data_out, expected_data_ready, expected_sck);
                $display("  Got:      cs=%b, data_out=%h, data_ready=%b, sck=%b",
                         cs, data_out, data_ready, sck);
                fail_count = fail_count + 1;
            end
        end
    endtask

    // Timeout watchdog
    initial begin
        #1000000; // 1ms timeout
        $display("\nERROR: Simulation timeout!");
        $finish;
    end

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clk, data_in, miso, reset, start, cs, data_out, data_ready, sck);
    end

endmodule
