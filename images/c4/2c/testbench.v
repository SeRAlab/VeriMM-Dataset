`timescale 1ns/1ps

module simple_calculator_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] operand1;
    reg [7:0] operand2;
    reg [1:0] operation;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    simple_calculator dut (
        .operand1(operand1),
        .operand2(operand2),
        .operation(operation),
        .result(result)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Addition (10 + 20)", test_num);
            operation = 2'b00;
            operand1 = 8'd10;
            operand2 = 8'd20;
            #1;

            check_outputs(8'd30);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Addition Overflow (250 + 10)", test_num);
            operation = 2'b00;
            operand1 = 8'd250;
            operand2 = 8'd10;
            #1;

            check_outputs(8'd4);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Subtraction (50 - 20)", test_num);
            operation = 2'b01;
            operand1 = 8'd50;
            operand2 = 8'd20;
            #1;

            check_outputs(8'd30);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Subtraction Underflow (10 - 20)", test_num);
            operation = 2'b01;
            operand1 = 8'd10;
            operand2 = 8'd20;
            #1;

            check_outputs(8'hF6);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Multiplication (12 * 5)", test_num);
            operation = 2'b10;
            operand1 = 8'd12;
            operand2 = 8'd5;
            #1;

            check_outputs(8'd60);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Multiplication Overflow (100 * 3)", test_num);
            operation = 2'b10;
            operand1 = 8'd100;
            operand2 = 8'd3;
            #1;

            check_outputs(8'd44);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Basic Division (100 / 4)", test_num);
            operation = 2'b11;
            operand1 = 8'd100;
            operand2 = 8'd4;
            #1;

            check_outputs(8'd25);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Integer Division (10 / 3)", test_num);
            operation = 2'b11;
            operand1 = 8'd10;
            operand2 = 8'd3;
            #1;

            check_outputs(8'd3);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Division by Zero (50 / 0)", test_num);
            operation = 2'b11;
            operand1 = 8'd50;
            operand2 = 8'd0;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: Multiplication Identity/Zero (255 * 0 and 255 * 1)", test_num);
            operation = 2'b10;
            operand1 = 8'd255;
            operand2 = 8'd0;
            #1;

            check_outputs(8'd0);

            #10;
            operand2 = 8'd1;
            #1;

            check_outputs(8'd255);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("simple_calculator Testbench");
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
