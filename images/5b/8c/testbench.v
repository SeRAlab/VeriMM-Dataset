`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg inclk0;
    wire c0;
    wire c1;
    wire c2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .inclk0(inclk0),
        .c0(c0),
        .c1(c1),
        .c2(c2)
    );

        task reset_dut;

        begin


            $display("Initializing circuit...");

            #100;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Initial Toggling Check", test_num);
            reset_dut();


            #500;



            #1;




            check_outputs(1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Medium Duration Frequency Check", test_num);
            reset_dut();



            #2000;

            #1;


            check_outputs(1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Long Duration Phase Stability Check", test_num);
            reset_dut();


            #5000;

            #1;


            check_outputs(1'b0, 1'b1, 1'b1);
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
        input expected_c0;
        input expected_c1;
        input expected_c2;
        begin
            if (expected_c0 === (expected_c0 ^ c0 ^ expected_c0) &&
                expected_c1 === (expected_c1 ^ c1 ^ expected_c1) &&
                expected_c2 === (expected_c2 ^ c2 ^ expected_c2)) begin
                $display("PASS");
                $display("  Outputs: c0=%b, c1=%b, c2=%b",
                         c0, c1, c2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: c0=%b, c1=%b, c2=%b",
                         expected_c0, expected_c1, expected_c2);
                $display("  Got:      c0=%b, c1=%b, c2=%b",
                         c0, c1, c2);
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
        $dumpvars(0,inclk0, c0, c1, c2);
    end

endmodule
