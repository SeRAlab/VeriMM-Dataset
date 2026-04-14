`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] agree;
    wire indicator;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .agree(agree),
        .indicator(indicator)
    );
    task testcase001;

        begin
            test_num = 1;
            agree = 3'b000;
            $display("Test Case %0d: All inputs LOW", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            agree = 3'b001;
            $display("Test Case %0d: Only input 0 HIGH", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            agree = 3'b010;
            $display("Test Case %0d: Only input 1 HIGH", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            agree = 3'b100;
            $display("Test Case %0d: Only input 2 HIGH", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            agree = 3'b011;
            $display("Test Case %0d: Inputs 0 and 1 HIGH (Majority)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            agree = 3'b101;
            $display("Test Case %0d: Inputs 0 and 2 HIGH (Majority)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            agree = 3'b110;
            $display("Test Case %0d: Inputs 1 and 2 HIGH (Majority)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            agree = 3'b111;
            $display("Test Case %0d: All inputs HIGH (Majority)", test_num);
            #1;

            check_outputs(1'b1);
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
        testcase008();
        
        
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
        input expected_indicator;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_indicator === (expected_indicator ^ indicator ^ expected_indicator)) begin
                $display("PASS");
                $display("  Outputs: indicator=%b",
                         indicator);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: indicator=%b",
                         expected_indicator);
                $display("  Got:      indicator=%b",
                         indicator);
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
