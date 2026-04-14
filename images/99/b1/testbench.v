`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [6:0] parallelIn;
    reg reset;
    wire latchClk;
    wire serialOut;
    wire shiftClk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .parallelIn(parallelIn),
        .reset(reset),
        .latchClk(latchClk),
        .serialOut(serialOut),
        .shiftClk(shiftClk)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            parallelIn = 7'b0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Testing All Zeros (7'b0000000)", test_num);
            reset_dut();
            parallelIn = 7'b0000000;


            repeat(7) @(posedge clk);
            #2;



            #1;




            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Testing All Ones (7'b1111111)", test_num);
            reset_dut();
            parallelIn = 7'b1111111;


            repeat(7) @(posedge clk);
            #2;


            #1;



            check_outputs(1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Testing Alternating Pattern (7'b1010101)", test_num);
            reset_dut();
            parallelIn = 7'b1010101;


            repeat(7) @(posedge clk);
            #2;


            #1;



            check_outputs(1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Testing Specific Pattern (7'b1100110)", test_num);
            reset_dut();
            parallelIn = 7'b1100110;


            repeat(7) @(posedge clk);
            #2;


            #1;



            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Testing Reset during operation", test_num);
            reset_dut();
            parallelIn = 7'b1111111;

            repeat(3) @(posedge clk);
            reset = 1;
            #10;
            reset = 0;
            @(posedge clk);
            #2;



            #1;




            check_outputs(1'b1, 1'b0, 1'b0);
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
        input expected_latchClk;
        input expected_serialOut;
        input expected_shiftClk;
        begin
            if (expected_latchClk === (expected_latchClk ^ latchClk ^ expected_latchClk) &&
                expected_serialOut === (expected_serialOut ^ serialOut ^ expected_serialOut) &&
                expected_shiftClk === (expected_shiftClk ^ shiftClk ^ expected_shiftClk)) begin
                $display("PASS");
                $display("  Outputs: latchClk=%b, serialOut=%b, shiftClk=%b",
                         latchClk, serialOut, shiftClk);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: latchClk=%b, serialOut=%b, shiftClk=%b",
                         expected_latchClk, expected_serialOut, expected_shiftClk);
                $display("  Got:      latchClk=%b, serialOut=%b, shiftClk=%b",
                         latchClk, serialOut, shiftClk);
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
        $dumpvars(0,clk, parallelIn, reset, latchClk, serialOut, shiftClk);
    end

endmodule
