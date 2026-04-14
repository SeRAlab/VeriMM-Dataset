`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] ALUOp;
    reg [31:0] ALU_DA;
    reg [31:0] ALU_DB;
    wire [31:0] ALU_DC;
    wire ALU_Zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUOp(ALUOp),
        .ALU_DA(ALU_DA),
        .ALU_DB(ALU_DB),
        .ALU_DC(ALU_DC),
        .ALU_Zero(ALU_Zero)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Addition (5 + 3)", test_num);
        ALU_DA = 32'h00000005;
        ALU_DB = 32'h00000003;
        ALUOp  = 2'b00;
        #1;

        check_outputs(32'h00000008, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Addition (0 + 0)", test_num);
        ALU_DA = 32'h00000000;
        ALU_DB = 32'h00000000;
        ALUOp  = 2'b00;
        #1;

        check_outputs(32'h00000000, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Addition (0xFFFFFFFF + 1)", test_num);
        ALU_DA = 32'hFFFFFFFF;
        ALU_DB = 32'h00000001;
        ALUOp  = 2'b00;
        #1;

        check_outputs(32'h00000000, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Subtraction (10 - 4)", test_num);
        ALU_DA = 32'h0000000A;
        ALU_DB = 32'h00000004;
        ALUOp  = 2'b01;
        #1;

        check_outputs(32'h00000006, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Subtraction (15 - 15)", test_num);
        ALU_DA = 32'h0000000F;
        ALU_DB = 32'h0000000F;
        ALUOp  = 2'b01;
        #1;

        check_outputs(32'h00000000, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Subtraction (0 - 1)", test_num);
        ALU_DA = 32'h00000000;
        ALU_DB = 32'h00000001;
        ALUOp  = 2'b01;
        #1;

        check_outputs(32'hFFFFFFFF, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Bitwise AND (0xF0F0F0F0 & 0xAAAA5555)", test_num);
        ALU_DA = 32'hF0F0F0F0;
        ALU_DB = 32'hAAAA5555;
        ALUOp  = 2'b10;
        #1;

        check_outputs(32'hA0A05050, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Bitwise AND (0x55555555 & 0xAAAAAAAA)", test_num);
        ALU_DA = 32'h55555555;
        ALU_DB = 32'hAAAAAAAA;
        ALUOp  = 2'b10;
        #1;

        check_outputs(32'h00000000, 1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Bitwise OR (0x0000FFFF | 0xFFFF0000)", test_num);
        ALU_DA = 32'h0000FFFF;
        ALU_DB = 32'hFFFF0000;
        ALUOp  = 2'b11;
        #1;

        check_outputs(32'hFFFFFFFF, 1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Bitwise OR (0 | 0)", test_num);
        ALU_DA = 32'h00000000;
        ALU_DB = 32'h00000000;
        ALUOp  = 2'b11;
        #1;

        check_outputs(32'h00000000, 1'b1);
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
        input [31:0] expected_ALU_DC;
        input expected_ALU_Zero;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ALU_DC === (expected_ALU_DC ^ ALU_DC ^ expected_ALU_DC) &&
                expected_ALU_Zero === (expected_ALU_Zero ^ ALU_Zero ^ expected_ALU_Zero)) begin
                $display("PASS");
                $display("  Outputs: ALU_DC=%h, ALU_Zero=%b",
                         ALU_DC, ALU_Zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALU_DC=%h, ALU_Zero=%b",
                         expected_ALU_DC, expected_ALU_Zero);
                $display("  Got:      ALU_DC=%h, ALU_Zero=%b",
                         ALU_DC, ALU_Zero);
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
