`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [25:0] immediate_jump;
    wire [31:0] extended_jump;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .immediate_jump(immediate_jump),
        .extended_jump(extended_jump)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All Zeros", test_num);
            immediate_jump = 26'h0000000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Maximum Positive Value", test_num);
            immediate_jump = 26'h1FFFFFF;
            #1;

            check_outputs(32'h01FFFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Small Positive Value", test_num);
            immediate_jump = 26'h0000001;
            #1;

            check_outputs(32'h00000001);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Most Negative Value", test_num);
            immediate_jump = 26'h2000000;
            #1;

            check_outputs(32'hFE000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All Ones", test_num);
            immediate_jump = 26'h3FFFFFF;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Mixed Pattern Positive", test_num);
            immediate_jump = 26'h1A5A5A5;
            #1;

            check_outputs(32'h01A5A5A5);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Mixed Pattern Negative", test_num);
            immediate_jump = 26'h2B6B6B6;
            #1;

            check_outputs(32'hFEB6B6B6);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary Negative", test_num);
            immediate_jump = 26'h2000001;
            #1;

            check_outputs(32'hFE000001);
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
        input [31:0] expected_extended_jump;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_extended_jump === (expected_extended_jump ^ extended_jump ^ expected_extended_jump)) begin
                $display("PASS");
                $display("  Outputs: extended_jump=%h",
                         extended_jump);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: extended_jump=%h",
                         expected_extended_jump);
                $display("  Got:      extended_jump=%h",
                         extended_jump);
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
