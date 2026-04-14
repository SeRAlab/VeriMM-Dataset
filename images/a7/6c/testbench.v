`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [13:0] immediate_in;
    wire [15:0] sign_extend;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .immediate_in(immediate_in),
        .sign_extend(sign_extend)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero input", test_num);
            immediate_in = 14'h0000;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum positive value (MSB is 0)", test_num);
            immediate_in = 14'h1FFF;
            #1;

            check_outputs(16'h1FFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Minimum negative value (MSB is 1)", test_num);
            immediate_in = 14'h2000;
            #1;

            check_outputs(16'hE000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All ones (-1 in 14-bit signed)", test_num);
            immediate_in = 14'h3FFF;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random positive pattern", test_num);
            immediate_in = 14'h0AAA;
            #1;

            check_outputs(16'h0AAA);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random negative pattern", test_num);
            immediate_in = 14'h3555;
            #1;

            check_outputs(16'hF555);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary check - smallest negative magnitude", test_num);
            immediate_in = 14'h2001;
            #1;

            check_outputs(16'hE001);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary check - second largest positive", test_num);
            immediate_in = 14'h1FFE;
            #1;

            check_outputs(16'h1FFE);
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
        input [15:0] expected_sign_extend;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_sign_extend === (expected_sign_extend ^ sign_extend ^ expected_sign_extend)) begin
                $display("PASS");
                $display("  Outputs: sign_extend=%h",
                         sign_extend);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sign_extend=%h",
                         expected_sign_extend);
                $display("  Got:      sign_extend=%h",
                         sign_extend);
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
