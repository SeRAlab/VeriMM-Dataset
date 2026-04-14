`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    wire [7:0] quotient;
    wire [7:0] remainder;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .quotient(quotient),
        .remainder(remainder),
        .valid(valid)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            A = 8'd10;
            B = 8'd2;
            $display("Test %0d: Simple division (10 / 2)", test_num);
            #1;

            check_outputs(8'd5, 8'd0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            A = 8'd10;
            B = 8'd3;
            $display("Test %0d: Simple division with remainder (10 / 3)", test_num);
            #1;

            check_outputs(8'd3, 8'd1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            A = 8'd25;
            B = 8'd0;
            $display("Test %0d: Division by zero (25 / 0)", test_num);
            #1;

            check_outputs(8'd0, 8'd0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            A = 8'd255;
            B = 8'd255;
            $display("Test %0d: Max values (255 / 255)", test_num);
            #1;

            check_outputs(8'd1, 8'd0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            A = 8'd5;
            B = 8'd12;
            $display("Test %0d: Small dividend (5 / 12)", test_num);
            #1;

            check_outputs(8'd0, 8'd5, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            A = 8'd128;
            B = 8'd1;
            $display("Test %0d: Division by one (128 / 1)", test_num);
            #1;

            check_outputs(8'd128, 8'd0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            A = 8'd0;
            B = 8'd50;
            $display("Test %0d: Zero dividend (0 / 50)", test_num);
            #1;

            check_outputs(8'd0, 8'd0, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            A = 8'd255;
            B = 8'd2;
            $display("Test %0d: Max dividend, small divisor (255 / 2)", test_num);
            #1;

            check_outputs(8'd127, 8'd1, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            A = 8'd200;
            B = 8'd13;
            $display("Test %0d: Complex division (200 / 13)", test_num);
            #1;

            check_outputs(8'd15, 8'd5, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            A = 8'd0;
            B = 8'd0;
            $display("Test %0d: Zero divided by zero (0 / 0)", test_num);
            #1;

            check_outputs(8'd0, 8'd0, 1'b1);
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
        input [7:0] expected_quotient;
        input [7:0] expected_remainder;
        input expected_valid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_quotient === (expected_quotient ^ quotient ^ expected_quotient) &&
                expected_remainder === (expected_remainder ^ remainder ^ expected_remainder) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: quotient=%h, remainder=%h, valid=%b",
                         quotient, remainder, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: quotient=%h, remainder=%h, valid=%b",
                         expected_quotient, expected_remainder, expected_valid);
                $display("  Got:      quotient=%h, remainder=%h, valid=%b",
                         quotient, remainder, valid);
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
