`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] PCAddSelect;
    reg [31:0] rs1_data;
    reg [31:0] stage1_imm;
    reg [31:0] stage1_pc;
    wire [31:0] stage1_pc4;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .PCAddSelect(PCAddSelect),
        .rs1_data(rs1_data),
        .stage1_imm(stage1_imm),
        .stage1_pc(stage1_pc),
        .stage1_pc4(stage1_pc4)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: PC + 4 (Default Mode, PCAddSelect=00)", test_num);
            stage1_pc   = 32'h0000_1000;
            stage1_imm  = 32'h0000_0050;
            rs1_data    = 32'h0000_2000;
            PCAddSelect = 2'b00;
            #1;

            check_outputs(32'h0000_1004);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: PC + Immediate (PCAddSelect=01)", test_num);
            stage1_pc   = 32'h0000_1000;
            stage1_imm  = 32'h0000_0050;
            rs1_data    = 32'h0000_2000;
            PCAddSelect = 2'b01;
            #1;

            check_outputs(32'h0000_1050);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: rs1_data + Immediate (PCAddSelect=10)", test_num);
            stage1_pc   = 32'h0000_1000;
            stage1_imm  = 32'h0000_0008;
            rs1_data    = 32'h0000_3000;
            PCAddSelect = 2'b10;
            #1;

            check_outputs(32'h0000_3008);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Default Mode (PCAddSelect=11)", test_num);
            stage1_pc   = 32'h0000_4000;
            stage1_imm  = 32'h0000_0020;
            rs1_data    = 32'h0000_5000;
            PCAddSelect = 2'b11;
            #1;

            check_outputs(32'h0000_4004);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: PC + Negative Immediate (2's Complement)", test_num);
            stage1_pc   = 32'h0000_1000;
            stage1_imm  = 32'hFFFF_FFFC;
            rs1_data    = 32'h0000_0000;
            PCAddSelect = 2'b01;
            #1;

            check_outputs(32'h0000_0FFC);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Maximum Address Wrap-around (PC+4)", test_num);
            stage1_pc   = 32'hFFFF_FFFC;
            stage1_imm  = 32'h0000_0000;
            rs1_data    = 32'h0000_0000;
            PCAddSelect = 2'b00;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: rs1_data + Immediate Large Offset", test_num);
            stage1_pc   = 32'h0000_0000;
            stage1_imm  = 32'h7FFF_FFFF;
            rs1_data    = 32'h0000_0001;
            PCAddSelect = 2'b10;
            #1;

            check_outputs(32'h8000_0000);
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
        input [31:0] expected_stage1_pc4;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_stage1_pc4 === (expected_stage1_pc4 ^ stage1_pc4 ^ expected_stage1_pc4)) begin
                $display("PASS");
                $display("  Outputs: stage1_pc4=%h",
                         stage1_pc4);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: stage1_pc4=%h",
                         expected_stage1_pc4);
                $display("  Got:      stage1_pc4=%h",
                         stage1_pc4);
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
