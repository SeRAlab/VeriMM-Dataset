`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] aluop;
    reg [5:0] data_in;
    wire [2:0] opcode;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .aluop(aluop),
        .data_in(data_in),
        .opcode(opcode)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: ALUop 10, Funct 6'h20 (ADD)", test_num);
        aluop = 2'b10;
        data_in = 6'h20;
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: ALUop 10, Funct 6'h22 (SUB)", test_num);
        aluop = 2'b10;
        data_in = 6'h22;
        #1;

        check_outputs(3'b110);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: ALUop 10, Funct 6'h24 (AND)", test_num);
        aluop = 2'b10;
        data_in = 6'h24;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: ALUop 10, Funct 6'h25 (OR)", test_num);
        aluop = 2'b10;
        data_in = 6'h25;
        #1;

        check_outputs(3'b001);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: ALUop 10, Funct 6'h2a (SLT)", test_num);
        aluop = 2'b10;
        data_in = 6'h2a;
        #1;

        check_outputs(3'b111);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: ALUop 00 (Invalid Condition)", test_num);
        aluop = 2'b00;
        data_in = 6'h20;
        #1;

        check_outputs(3'bzzz);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: ALUop 01 (Invalid Condition)", test_num);
        aluop = 2'b01;
        data_in = 6'h22;
        #1;

        check_outputs(3'bzzz);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: ALUop 11 (Invalid Condition)", test_num);
        aluop = 2'b11;
        data_in = 6'h24;
        #1;

        check_outputs(3'bzzz);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: ALUop 10, Undefined Funct 6'h3F", test_num);
        aluop = 2'b10;
        data_in = 6'h3F;
        #1;

        check_outputs(3'bzzz);
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
        input [2:0] expected_opcode;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_opcode === (expected_opcode ^ opcode ^ expected_opcode)) begin
                $display("PASS");
                $display("  Outputs: opcode=%h",
                         opcode);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: opcode=%h",
                         expected_opcode);
                $display("  Got:      opcode=%h",
                         opcode);
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
