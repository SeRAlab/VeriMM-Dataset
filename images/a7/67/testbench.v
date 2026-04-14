`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] operand1;
    reg [31:0] operand2;
    reg [1:0] operation;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .operand1(operand1),
        .operand2(operand2),
        .operation(operation),
        .result(result)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        operand1 = 32'd100;
        operand2 = 32'd250;
        operation = 2'b00;
        #1;

        check_outputs(32'd350);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        operand1 = 32'd500;
        operand2 = 32'd150;
        operation = 2'b01;
        #1;

        check_outputs(32'd350);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        operand1 = 32'd12;
        operand2 = 32'd11;
        operation = 2'b10;
        #1;

        check_outputs(32'd132);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        operand1 = 32'd144;
        operand2 = 32'd12;
        operation = 2'b11;
        #1;

        check_outputs(32'd12);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        operand1 = 32'hFFFFFFFF;
        operand2 = 32'd1;
        operation = 2'b00;
        #1;

        check_outputs(32'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        operand1 = 32'd10;
        operand2 = 32'd20;
        operation = 2'b01;
        #1;

        check_outputs(32'hFFFFFFF6);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        operand1 = 32'hABCD1234;
        operand2 = 32'd0;
        operation = 2'b10;
        #1;

        check_outputs(32'd0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        operand1 = 32'd25;
        operand2 = 32'd7;
        operation = 2'b11;
        #1;

        check_outputs(32'd3);
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
