`timescale 1ns/1ps

module simple_calculator_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] operand_a;
    reg [15:0] operand_b;
    reg [1:0] operation;
    wire [15:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    simple_calculator dut (
        .operand_a(operand_a),
        .operand_b(operand_b),
        .operation(operation),
        .result(result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition (100 + 200)", test_num);
            operand_a = 16'sd100;
            operand_b = 16'sd200;
            operation = 2'b00;
            #1;

            check_outputs(16'sd300);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition (-50 + 30)", test_num);
            operand_a = -16'sd50;
            operand_b = 16'sd30;
            operation = 2'b00;
            #1;

            check_outputs(-16'sd20);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Subtraction (500 - 150)", test_num);
            operand_a = 16'sd500;
            operand_b = 16'sd150;
            operation = 2'b01;
            #1;

            check_outputs(16'sd350);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Subtraction (10 - 100)", test_num);
            operand_a = 16'sd10;
            operand_b = 16'sd100;
            operation = 2'b01;
            #1;

            check_outputs(-16'sd90);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiplication (12 * 11)", test_num);
            operand_a = 16'sd12;
            operand_b = 16'sd11;
            operation = 2'b10;
            #1;

            check_outputs(16'sd132);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiplication (-5 * 20)", test_num);
            operand_a = -16'sd5;
            operand_b = 16'sd20;
            operation = 2'b10;
            #1;

            check_outputs(-16'sd100);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiplication (-8 * -4)", test_num);
            operand_a = -16'sd8;
            operand_b = -16'sd4;
            operation = 2'b10;
            #1;

            check_outputs(16'sd32);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Division (100 / 4)", test_num);
            operand_a = 16'sd100;
            operand_b = 16'sd4;
            operation = 2'b11;
            #1;

            check_outputs(16'sd25);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Division (-60 / 3)", test_num);
            operand_a = -16'sd60;
            operand_b = 16'sd3;
            operation = 2'b11;
            #1;

            check_outputs(-16'sd20);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Division (5 / 10)", test_num);
            operand_a = 16'sd5;
            operand_b = 16'sd10;
            operation = 2'b11;
            #1;

            check_outputs(16'sd0);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiplication (1234 * 0)", test_num);
            operand_a = 16'sd1234;
            operand_b = 16'sd0;
            operation = 2'b10;
            #1;

            check_outputs(16'sd0);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Division (-20 / -5)", test_num);
            operand_a = -16'sd20;
            operand_b = -16'sd5;
            operation = 2'b11;
            #1;

            check_outputs(16'sd4);
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
        input [15:0] expected_result;
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
