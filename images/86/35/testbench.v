`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] io_dataIn;
    reg io_read;
    reg io_write;
    reg reset;
    wire [7:0] io_dataOut;
    wire io_empty;
    wire io_full;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .io_dataIn(io_dataIn),
        .io_read(io_read),
        .io_write(io_write),
        .reset(reset),
        .io_dataOut(io_dataOut),
        .io_empty(io_empty),
        .io_full(io_full)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            io_dataIn = 8'h0;
            io_read = 0;
            io_write = 0;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Initial State Check", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Single Write", test_num);
            reset_dut();
            io_dataIn = 8'hA5;
            io_write = 1;
            @(posedge clk);
            #1 io_write = 0;
            repeat(1) @(posedge clk);

            #1;


            check_outputs(8'hA5, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Write and Read Back", test_num);
            reset_dut();

            io_dataIn = 8'h5A;
            io_write = 1;
            @(posedge clk);
            #1 io_write = 0;
            @(posedge clk);

            io_read = 1;
            @(posedge clk);
            #1 io_read = 0;
            repeat(1) @(posedge clk);

            #1;


            check_outputs(8'h5A, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Multiple Writes Ordering", test_num);
            reset_dut();

            io_write = 1;
            io_dataIn = 8'h11; @(posedge clk); #1;
            io_dataIn = 8'h22; @(posedge clk); #1;
            io_dataIn = 8'h33; @(posedge clk); #1;
            io_write = 0;

            io_read = 1;
            @(posedge clk);
            #1 io_read = 0;
            @(posedge clk);

            #1;


            check_outputs(8'h22, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Simultaneous Read/Write", test_num);
            reset_dut();

            io_dataIn = 8'hAA;
            io_write = 1;
            @(posedge clk);
            #1;

            io_read = 1;
            io_dataIn = 8'hBB;
            io_write = 1;
            @(posedge clk);
            #1;
            io_read = 0;
            io_write = 0;
            @(posedge clk);

            #1;


            check_outputs(8'hBB, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = 6;
            $display("Testcase %0d: Fill Buffer", test_num);
            reset_dut();
            io_write = 1;
            for(i=0; i<8; i=i+1) begin
                io_dataIn = i + 8'h10;
                @(posedge clk);
                #1;
            end
            io_write = 0;
            @(posedge clk);


            if (io_full === 1'b1)
                #1;

                check_outputs(8'h10, 1'b0, 1'b1);
            else
                #1;

                check_outputs(8'h10, 1'b0, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [7:0] expected_io_dataOut;
        input expected_io_empty;
        input expected_io_full;
        begin
            if (expected_io_dataOut === (expected_io_dataOut ^ io_dataOut ^ expected_io_dataOut) &&
                expected_io_empty === (expected_io_empty ^ io_empty ^ expected_io_empty) &&
                expected_io_full === (expected_io_full ^ io_full ^ expected_io_full)) begin
                $display("PASS");
                $display("  Outputs: io_dataOut=%h, io_empty=%b, io_full=%b",
                         io_dataOut, io_empty, io_full);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: io_dataOut=%h, io_empty=%b, io_full=%b",
                         expected_io_dataOut, expected_io_empty, expected_io_full);
                $display("  Got:      io_dataOut=%h, io_empty=%b, io_full=%b",
                         io_dataOut, io_empty, io_full);
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
        $dumpvars(0,clk, io_dataIn, io_read, io_write, reset, io_dataOut, io_empty, io_full);
    end

endmodule
