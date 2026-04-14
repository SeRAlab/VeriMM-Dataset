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
            io_read = 0;
            io_write = 0;
            io_dataIn = 0;
            @(posedge clk);
            #2;
            reset = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Initial State after Reset", test_num);
            reset_dut();

            #1;


            check_outputs(io_dataOut, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Single Write and Read", test_num);
            reset_dut();


            @(posedge clk);
            io_write = 1;
            io_dataIn = 8'hAB;
            @(posedge clk);
            io_write = 0;


            @(posedge clk);
            io_read = 1;
            @(posedge clk);
            io_read = 0;


            #1;



            check_outputs(8'hAB, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Sequential Writes", test_num);
            reset_dut();


            @(posedge clk);
            io_write = 1; io_dataIn = 8'h11;
            @(posedge clk);
            io_write = 1; io_dataIn = 8'h22;
            @(posedge clk);
            io_write = 0;


            #1;



            check_outputs(io_dataOut, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            $display("Testcase %0d: Fill FIFO to Full", test_num);
            reset_dut();


            for (i = 0; i < 256; i = i + 1) begin
                if (io_full) break;
                @(posedge clk);
                io_write = 1;
                io_dataIn = i[7:0];
            end
            @(posedge clk);
            io_write = 0;


            #1;



            check_outputs(io_dataOut, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            $display("Testcase %0d: Read until Empty", test_num);
            reset_dut();


            for (i = 0; i < 4; i = i + 1) begin
                @(posedge clk);
                io_write = 1; io_dataIn = (8'hA0 + i);
            end
            @(posedge clk);
            io_write = 0;


            for (i = 0; i < 4; i = i + 1) begin
                @(posedge clk);
                io_read = 1;
            end
            @(posedge clk);
            io_read = 0;


            #1;



            check_outputs(8'hA3, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Simultaneous Read and Write", test_num);
            reset_dut();


            @(posedge clk);
            io_write = 1; io_dataIn = 8'hCC;
            @(posedge clk);
            io_write = 0;


            @(posedge clk);
            io_read = 1;
            io_write = 1;
            io_dataIn = 8'hDD;
            @(posedge clk);
            io_read = 0;
            io_write = 0;


            #1;



            check_outputs(8'hCC, 1'b0, 1'b0);
        end
        endtask

    task testcase007;

        integer i;
        begin
            test_num = 7;
            $display("Testcase %0d: Overflow Protection", test_num);
            reset_dut();


            for (i = 0; i < 32; i = i + 1) begin
                if (io_full) break;
                @(posedge clk);
                io_write = 1; io_dataIn = i[7:0];
            end


            @(posedge clk);
            io_write = 1; io_dataIn = 8'hFF;
            @(posedge clk);
            io_write = 0;


            #1;



            check_outputs(io_dataOut, 1'b0, 1'b1);
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
        testcase007();
        
        
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
