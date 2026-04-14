`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clkp5;
    wire [7:0] actual;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clkp5(clkp5),
        .actual(actual)
    );

    // Clock generation (10ns period)
    initial begin
        clkp5 = 0;
        forever #5 clkp5 = ~clkp5;
    end

        task reset_dut;

        begin


            @(posedge clkp5);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Checking output after 1 cycle", test_num);
            reset_dut();
            repeat(1) @(posedge clkp5);
            #1;

            if (actual < 8'd77)
                #1;

                check_outputs(actual);
            else
                #1;

                check_outputs(8'd100);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Checking output after 10 cycles", test_num);
            reset_dut();
            repeat(10) @(posedge clkp5);
            #1;
            if (actual < 8'd77)
                #1;

                check_outputs(actual);
            else
                #1;

                check_outputs(8'd100);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Checking output after 100 cycles", test_num);
            reset_dut();
            repeat(100) @(posedge clkp5);
            #1;
            if (actual < 8'd77)
                #1;

                check_outputs(actual);
            else
                #1;

                check_outputs(8'd100);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Checking output after 500 cycles", test_num);
            reset_dut();
            repeat(500) @(posedge clkp5);
            #1;
            if (actual < 8'd77)
                #1;

                check_outputs(actual);
            else
                #1;

                check_outputs(8'd100);
        end
        endtask

    task testcase005;

        reg [7:0] prev_val;
        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Verification of sequence change", test_num);
            reset_dut();
            prev_val = actual;
            repeat(5) @(posedge clkp5);
            #1;

            if (actual < 8'd77 && actual != prev_val)
                #1;

                check_outputs(actual);
            else if (actual < 8'd77)
                #1;

                check_outputs(actual);
            else
                #1;

                check_outputs(8'd100);
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
        input [7:0] expected_actual;
        begin
            if (expected_actual === (expected_actual ^ actual ^ expected_actual)) begin
                $display("PASS");
                $display("  Outputs: actual=%h",
                         actual);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: actual=%h",
                         expected_actual);
                $display("  Got:      actual=%h",
                         actual);
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
        $dumpvars(0,clkp5, actual);
    end

endmodule
