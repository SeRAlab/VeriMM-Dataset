`timescale 1ns/1ps

module simple_calculator_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] operands;
    reg [1:0] operation;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    simple_calculator dut (
        .operands(operands),
        .operation(operation),
        .result(result)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition (100 + 200)", test_num);
        operation = 2'b00;
        operands = {32'sd100, 32'sd200};
        #1;

        check_outputs(32'sd300);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition (-50 + 20)", test_num);
        operation = 2'b00;
        operands = {32'sd-50, 32'sd20};
        #1;

        check_outputs(32'sd-30);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Subtraction (100 - 40)", test_num);
        operation = 2'b01;
        operands = {32'sd100, 32'sd40};
        #1;

        check_outputs(32'sd60);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Subtraction (20 - 50)", test_num);
        operation = 2'b01;
        operands = {32'sd20, 32'sd50};
        #1;

        check_outputs(32'sd-30);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Multiplication (12 * 11)", test_num);
        operation = 2'b10;
        operands = {32'sd12, 32'sd11};
        #1;

        check_outputs(32'sd132);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Multiplication (-5 * 6)", test_num);
        operation = 2'b10;
        operands = {32'sd-5, 32'sd6};
        #1;

        check_outputs(32'sd-30);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Division (100 / 10)", test_num);
        operation = 2'b11;
        operands = {32'sd100, 32'sd10};
        #1;

        check_outputs(32'sd10);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Division (-100 / 4)", test_num);
        operation = 2'b11;
        operands = {32'sd-100, 32'sd4};
        #1;

        check_outputs(32'sd-25);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Division with truncation (7 / 2)", test_num);
        operation = 2'b11;
        operands = {32'sd7, 32'sd2};
        #1;

        check_outputs(32'sd3);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Boundary Case (0 + 0)", test_num);
        operation = 2'b00;
        operands = {32'sd0, 32'sd0};
        #1;

        check_outputs(32'sd0);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Multiplication by Zero (1234 * 0)", test_num);
        operation = 2'b10;
        operands = {32'sd1234, 32'sd0};
        #1;

        check_outputs(32'sd0);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Division of Zero (0 / 50)", test_num);
        operation = 2'b11;
        operands = {32'sd0, 32'sd50};
        #1;

        check_outputs(32'sd0);
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
        input [31:0] expected_result;
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
