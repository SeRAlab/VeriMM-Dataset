`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    wire GSR;
    wire GTS;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .GSR(GSR),
        .GTS(GTS)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Initial Logic Level Check", test_num);

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Short Duration Stability Check", test_num);
            #100;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Long Duration Stability Check", test_num);
            #1000;
            #1;

            check_outputs(1'b0, 1'b0);
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
        input expected_GSR;
        input expected_GTS;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_GSR === (expected_GSR ^ GSR ^ expected_GSR) &&
                expected_GTS === (expected_GTS ^ GTS ^ expected_GTS)) begin
                $display("PASS");
                $display("  Outputs: GSR=%b, GTS=%b",
                         GSR, GTS);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: GSR=%b, GTS=%b",
                         expected_GSR, expected_GTS);
                $display("  Got:      GSR=%b, GTS=%b",
                         GSR, GTS);
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

endmodule
