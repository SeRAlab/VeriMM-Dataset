`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    wire C;
    wire [7:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .sum(sum)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Simple positive addition (10 + 20)", test_num);
            A = 8'd10;
            B = 8'd20;
            #1;

            check_outputs(1'b0, 8'd30);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Simple negative addition (-10 + -20)", test_num);
            A = -8'd10;
            B = -8'd20;
            #1;

            check_outputs(1'b0, -8'd30);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Positive and negative addition (50 + -30)", test_num);
            A = 8'd50;
            B = -8'd30;
            #1;

            check_outputs(1'b0, 8'd20);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Maximum positive sum (126 + 1)", test_num);
            A = 8'd126;
            B = 8'd1;
            #1;

            check_outputs(1'b0, 8'd127);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Minimum negative sum (-127 + -1)", test_num);
            A = -8'd127;
            B = -8'd1;
            #1;

            check_outputs(1'b0, -8'd128);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Positive overflow (127 + 1)", test_num);
            A = 8'd127;
            B = 8'd1;

            #1;


            check_outputs(1'b1, 8'h80);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Positive overflow (64 + 64)", test_num);
            A = 8'd64;
            B = 8'd64;

            #1;


            check_outputs(1'b1, 8'h80);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Negative overflow (-128 + -1)", test_num);
            A = -8'd128;
            B = -8'd1;

            #1;


            check_outputs(1'b1, 8'h7F);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Negative overflow (-70 + -60)", test_num);
            A = -8'd70;
            B = -8'd60;

            #1;


            check_outputs(1'b1, 8'h7E);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: Zero addition (0 + 0)", test_num);
            A = 8'd0;
            B = 8'd0;
            #1;

            check_outputs(1'b0, 8'd0);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            $display("Testcase %0d: Large opposite signs (127 + -128)", test_num);
            A = 8'd127;
            B = -8'd128;
            #1;

            check_outputs(1'b0, -8'd1);
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
        input expected_C;
        input [7:0] expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C === (expected_C ^ C ^ expected_C) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: C=%b, sum=%h",
                         C, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%b, sum=%h",
                         expected_C, expected_sum);
                $display("  Got:      C=%b, sum=%h",
                         C, sum);
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
