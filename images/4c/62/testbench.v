`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] num1;
    reg [7:0] num2;
    reg [1:0] op;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .num1(num1),
        .num2(num2),
        .op(op),
        .result(result)
    );
    task testcase001;

        begin
            test_num = 1;
            op = 2'b00; num1 = 8'd10; num2 = 8'd20;
            $display("Test %0d: Addition (10 + 20)", test_num);
            #1;

            check_outputs(8'd30);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            op = 2'b00; num1 = 8'd255; num2 = 8'd1;
            $display("Test %0d: Addition Overflow (255 + 1)", test_num);
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            op = 2'b01; num1 = 8'd50; num2 = 8'd20;
            $display("Test %0d: Subtraction (50 - 20)", test_num);
            #1;

            check_outputs(8'd30);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            op = 2'b01; num1 = 8'd5; num2 = 8'd10;
            $display("Test %0d: Subtraction Underflow (5 - 10)", test_num);
            #1;

            check_outputs(8'hFB);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            op = 2'b10; num1 = 8'd255; num2 = 8'd255;
            $display("Test %0d: Multiplication Upper 8 bits (255 * 255)", test_num);
            #1;

            check_outputs(8'hFE);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            op = 2'b10; num1 = 8'd128; num2 = 8'd2;
            $display("Test %0d: Multiplication Upper 8 bits (128 * 2)", test_num);
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            op = 2'b10; num1 = 8'd10; num2 = 8'd10;
            $display("Test %0d: Multiplication Upper 8 bits (10 * 10)", test_num);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            op = 2'b11; num1 = 8'd255; num2 = 8'd255;
            $display("Test %0d: Division ((255*255)>>8)/255", test_num);
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            op = 2'b11; num1 = 8'd128; num2 = 8'd0;
            $display("Test %0d: Division by Zero", test_num);
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            op = 2'b11; num1 = 8'd128; num2 = 8'd4;



            $display("Test %0d: Division ((128*4)>>8)/4", test_num);
            #1;

            check_outputs(8'd0);
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
        input [7:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
