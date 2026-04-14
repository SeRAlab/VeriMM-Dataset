`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg CfgValue_i;
    wire Value_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CfgValue_i(CfgValue_i),
        .Value_o(Value_o)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Driving input to 0", test_num);
            CfgValue_i = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Driving input to 1", test_num);
            CfgValue_i = 1'b1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Toggling input back to 0", test_num);
            CfgValue_i = 1'b0;
            #1;

            check_outputs(1'b0);
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
        input expected_Value_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Value_o === (expected_Value_o ^ Value_o ^ expected_Value_o)) begin
                $display("PASS");
                $display("  Outputs: Value_o=%b",
                         Value_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Value_o=%b",
                         expected_Value_o);
                $display("  Got:      Value_o=%b",
                         Value_o);
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
