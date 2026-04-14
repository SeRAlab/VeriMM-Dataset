`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a;
    reg [2:0] alu_ctrl;
    reg [15:0] b;
    wire [15:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .alu_ctrl(alu_ctrl),
        .b(b),
        .result(result)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Bitwise AND", test_num);
        a = 16'hAAAA; b = 16'hF0F0; alu_ctrl = 3'b000;
        #1;

        check_outputs(16'hA0A0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Bitwise OR", test_num);
        a = 16'hAAAA; b = 16'h5555; alu_ctrl = 3'b001;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Addition (Basic)", test_num);
        a = 16'h1234; b = 16'h1111; alu_ctrl = 3'b010;
        #1;

        check_outputs(16'h2345);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Subtraction (Basic)", test_num);
        a = 16'h2345; b = 16'h1111; alu_ctrl = 3'b011;
        #1;

        check_outputs(16'h1234);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Logical Shift Left", test_num);
        a = 16'h0001; b = 16'h0004; alu_ctrl = 3'b100;
        #1;

        check_outputs(16'h0010);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Logical Shift Right", test_num);
        a = 16'h8000; b = 16'h0002; alu_ctrl = 3'b101;
        #1;

        check_outputs(16'h2000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Bitwise XOR", test_num);
        a = 16'hF0F0; b = 16'hFFFF; alu_ctrl = 3'b110;
        #1;

        check_outputs(16'h0F0F);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Bitwise NAND", test_num);
        a = 16'hF0F0; b = 16'h0F0F; alu_ctrl = 3'b111;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: Addition (Overflow case)", test_num);
        a = 16'hFFFF; b = 16'h0001; alu_ctrl = 3'b010;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test %0d: Subtraction (Result zero)", test_num);
        a = 16'hABCD; b = 16'hABCD; alu_ctrl = 3'b011;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        $display("Test %0d: NAND (Full coverage)", test_num);
        a = 16'hFFFF; b = 16'hFFFF; alu_ctrl = 3'b111;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        $display("Test %0d: SLL (Shift by zero)", test_num);
        a = 16'hABCD; b = 16'h0000; alu_ctrl = 3'b100;
        #1;

        check_outputs(16'hABCD);
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
