`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg [31:0] instruction;
    wire [15:0] address;
    wire [5:0] funct;
    wire [5:0] opCode;
    wire [4:0] rd;
    wire [4:0] rs;
    wire [4:0] rt;
    wire [4:0] shamt;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .instruction(instruction),
        .address(address),
        .funct(funct),
        .opCode(opCode),
        .rd(rd),
        .rs(rs),
        .rt(rt),
        .shamt(shamt)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: R-type ADD instruction", test_num);
            instruction = 32'h012A4020;
            @(posedge clk);
            #1;

            check_outputs(16'h4020, 6'h20, 6'h00, 5'h08, 5'h09, 5'h0A, 5'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: I-type ADDI instruction", test_num);
            instruction = 32'h21280064;
            @(posedge clk);
            #1;

            check_outputs(16'h0064, 6'h24, 6'h08, 5'h00, 5'h09, 5'h08, 5'h01);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: I-type LW instruction", test_num);
            instruction = 32'h8D09000C;
            @(posedge clk);
            #1;

            check_outputs(16'h000C, 6'h0C, 6'h23, 5'h00, 5'h08, 5'h09, 5'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: R-type SLL instruction", test_num);
            instruction = 32'h00042A80;
            @(posedge clk);
            #1;

            check_outputs(16'h2A80, 6'h00, 6'h00, 5'h05, 5'h00, 5'h04, 5'h0A);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: All ones instruction", test_num);
            instruction = 32'hFFFFFFFF;
            @(posedge clk);
            #1;

            check_outputs(16'hFFFF, 6'h3F, 6'h3F, 5'h1F, 5'h1F, 5'h1F, 5'h1F);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: All zeros (NOP) instruction", test_num);
            instruction = 32'h00000000;
            @(posedge clk);
            #1;

            check_outputs(16'h0000, 6'h00, 6'h00, 5'h00, 5'h00, 5'h00, 5'h00);
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
        input [15:0] expected_address;
        input [5:0] expected_funct;
        input [5:0] expected_opCode;
        input [4:0] expected_rd;
        input [4:0] expected_rs;
        input [4:0] expected_rt;
        input [4:0] expected_shamt;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_address === (expected_address ^ address ^ expected_address) &&
                expected_funct === (expected_funct ^ funct ^ expected_funct) &&
                expected_opCode === (expected_opCode ^ opCode ^ expected_opCode) &&
                expected_rd === (expected_rd ^ rd ^ expected_rd) &&
                expected_rs === (expected_rs ^ rs ^ expected_rs) &&
                expected_rt === (expected_rt ^ rt ^ expected_rt) &&
                expected_shamt === (expected_shamt ^ shamt ^ expected_shamt)) begin
                $display("PASS");
                $display("  Outputs: address=%h, funct=%h, opCode=%h, rd=%h, rs=%h, rt=%h, shamt=%h",
                         address, funct, opCode, rd, rs, rt, shamt);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: address=%h, funct=%h, opCode=%h, rd=%h, rs=%h, rt=%h, shamt=%h",
                         expected_address, expected_funct, expected_opCode, expected_rd, expected_rs, expected_rt, expected_shamt);
                $display("  Got:      address=%h, funct=%h, opCode=%h, rd=%h, rs=%h, rt=%h, shamt=%h",
                         address, funct, opCode, rd, rs, rt, shamt);
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
