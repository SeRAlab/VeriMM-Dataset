`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    wire A_greater_than_B;
    wire A_less_than_B;
    wire equal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .A_greater_than_B(A_greater_than_B),
        .A_less_than_B(A_less_than_B),
        .equal(equal)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A = B = 0", test_num);
            A = 8'd0;
            B = 8'd0;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A = B = 255", test_num);
            A = 8'd255;
            B = 8'd255;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A > B (MSB difference)", test_num);
            A = 8'b10000000;
            B = 8'b01111111;
            #1;

            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A < B (MSB difference)", test_num);
            A = 8'b01111111;
            B = 8'b10000000;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A > B (LSB difference)", test_num);
            A = 8'd101;
            B = 8'd100;
            #1;

            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A < B (LSB difference)", test_num);
            A = 8'd100;
            B = 8'd101;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A > B (Max vs Min)", test_num);
            A = 8'hFF;
            B = 8'h00;
            #1;

            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A < B (Min vs Max)", test_num);
            A = 8'h00;
            B = 8'hFF;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A = B (Mid range)", test_num);
            A = 8'hAA;
            B = 8'hAA;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A < B (Pattern check)", test_num);
            A = 8'b01010101;
            B = 8'b01010110;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
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
        input expected_A_greater_than_B;
        input expected_A_less_than_B;
        input expected_equal;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_A_greater_than_B === (expected_A_greater_than_B ^ A_greater_than_B ^ expected_A_greater_than_B) &&
                expected_A_less_than_B === (expected_A_less_than_B ^ A_less_than_B ^ expected_A_less_than_B) &&
                expected_equal === (expected_equal ^ equal ^ expected_equal)) begin
                $display("PASS");
                $display("  Outputs: A_greater_than_B=%b, A_less_than_B=%b, equal=%b",
                         A_greater_than_B, A_less_than_B, equal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: A_greater_than_B=%b, A_less_than_B=%b, equal=%b",
                         expected_A_greater_than_B, expected_A_less_than_B, expected_equal);
                $display("  Got:      A_greater_than_B=%b, A_less_than_B=%b, equal=%b",
                         A_greater_than_B, A_less_than_B, equal);
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
