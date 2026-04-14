`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] op1;
    reg [31:0] op2;
    reg [2:0] operation;
    wire res;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .op1(op1),
        .op2(op2),
        .operation(operation),
        .res(res)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Equality (op1 == op2) - True", test_num);
        op1 = 32'd500;
        op2 = 32'd500;
        operation = 3'b000;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Equality (op1 == op2) - False", test_num);
        op1 = 32'hA5A5A5A5;
        op2 = 32'h5A5A5A5A;
        operation = 3'b000;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Greater Than (op1 > op2) - True", test_num);
        op1 = 32'd1000;
        op2 = 32'd500;
        operation = 3'b010;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Greater Than (op1 > op2) - False (Less)", test_num);
        op1 = 32'd100;
        op2 = 32'd200;
        operation = 3'b010;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Greater Than (op1 > op2) - False (Equal)", test_num);
        op1 = 32'hFFFFFFFF;
        op2 = 32'hFFFFFFFF;
        operation = 3'b010;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Less Than (op1 < op2) - Opcode 101 - True", test_num);
        op1 = 32'd10;
        op2 = 32'd20;
        operation = 3'b101;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Less Than (op1 < op2) - Opcode 101 - False", test_num);
        op1 = 32'd30;
        op2 = 32'd20;
        operation = 3'b101;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Less Than (op1 < op2) - Opcode 110 - True", test_num);
        op1 = 32'h00000000;
        op2 = 32'h00000001;
        operation = 3'b110;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Invalid Operation Code (001)", test_num);
        op1 = 32'd10;
        op2 = 32'd10;
        operation = 3'b001;
        #1;

        check_outputs(1'bx);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: Invalid Operation Code (111)", test_num);
        op1 = 32'd10;
        op2 = 32'd10;
        operation = 3'b111;
        #1;

        check_outputs(1'bx);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        $display("Testcase %0d: Boundary Unsigned Check (Max vs 0)", test_num);
        op1 = 32'hFFFFFFFF;
        op2 = 32'h00000000;
        operation = 3'b010;
        #1;

        check_outputs(1'b1);
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
        input expected_res;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_res === (expected_res ^ res ^ expected_res)) begin
                $display("PASS");
                $display("  Outputs: res=%b",
                         res);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: res=%b",
                         expected_res);
                $display("  Got:      res=%b",
                         res);
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
