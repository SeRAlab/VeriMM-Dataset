`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] A_din_i;
    reg [15:0] B_din_i;
    wire equal;
    wire greater;
    wire lower;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A_din_i(A_din_i),
        .B_din_i(B_din_i),
        .equal(equal),
        .greater(greater),
        .lower(lower)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Both inputs zero", test_num);
            A_din_i = 16'sd0;
            B_din_i = 16'sd0;
            #1;

            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Both inputs Max Positive (32767)", test_num);
            A_din_i = 16'sd32767;
            B_din_i = 16'sd32767;
            #1;

            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Both inputs Min Negative (-32768)", test_num);
            A_din_i = -16'sd32768;
            B_din_i = -16'sd32768;
            #1;

            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Positive A > Positive B (100 > 50)", test_num);
            A_din_i = 16'sd100;
            B_din_i = 16'sd50;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Positive A < Positive B (50 < 100)", test_num);
            A_din_i = 16'sd50;
            B_din_i = 16'sd100;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Negative A > Negative B (-50 > -100)", test_num);
            A_din_i = -16'sd50;
            B_din_i = -16'sd100;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Negative A < Negative B (-100 < -50)", test_num);
            A_din_i = -16'sd100;
            B_din_i = -16'sd50;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Positive A > Negative B (1 > -1)", test_num);
            A_din_i = 16'sd1;
            B_din_i = -16'sd1;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Negative A < Positive B (-1 < 1)", test_num);
            A_din_i = -16'sd1;
            B_din_i = 16'sd1;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Extreme Max Positive > Min Negative (32767 > -32768)", test_num);
            A_din_i = 16'sd32767;
            B_din_i = -16'sd32768;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Extreme Min Negative < Max Positive (-32768 < 32767)", test_num);
            A_din_i = -16'sd32768;
            B_din_i = 16'sd32767;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Comparison near zero (-1 < 0)", test_num);
            A_din_i = 16'shFFFF;
            B_din_i = 16'sd0;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
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
        testcase009();
        testcase010();
        testcase011();
        testcase012();
        
        
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
        input expected_equal;
        input expected_greater;
        input expected_lower;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_equal === (expected_equal ^ equal ^ expected_equal) &&
                expected_greater === (expected_greater ^ greater ^ expected_greater) &&
                expected_lower === (expected_lower ^ lower ^ expected_lower)) begin
                $display("PASS");
                $display("  Outputs: equal=%b, greater=%b, lower=%b",
                         equal, greater, lower);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: equal=%b, greater=%b, lower=%b",
                         expected_equal, expected_greater, expected_lower);
                $display("  Got:      equal=%b, greater=%b, lower=%b",
                         equal, greater, lower);
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
