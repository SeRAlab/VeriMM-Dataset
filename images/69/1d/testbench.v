`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] Op_i;
    wire branch_o;
    wire jump_o;
    wire [7:0] mux8_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Op_i(Op_i),
        .branch_o(branch_o),
        .jump_o(jump_o),
        .mux8_o(mux8_o)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: R-type Instruction (Op_i = 0x00)", test_num);
        Op_i = 6'b000000;

        #1;


        check_outputs(1'b0, 1'b0, 8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Branch Instruction (Op_i = 0x04)", test_num);
        Op_i = 6'b000100;

        #1;


        check_outputs(1'b1, 1'b0, 8'h01);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Jump Instruction (Op_i = 0x02)", test_num);
        Op_i = 6'b000010;

        #1;


        check_outputs(1'b0, 1'b1, 8'h02);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Load Instruction (Op_i = 0x23)", test_num);
        Op_i = 6'b100011;

        #1;


        check_outputs(1'b0, 1'b0, 8'h08);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Store Instruction (Op_i = 0x2B)", test_num);
        Op_i = 6'b101011;

        #1;


        check_outputs(1'b0, 1'b0, 8'h10);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Default/Undefined Opcode (Op_i = 0x3F)", test_num);
        Op_i = 6'b111111;

        #1;


        check_outputs(1'b0, 1'b0, 8'h00);
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
        input expected_branch_o;
        input expected_jump_o;
        input [7:0] expected_mux8_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_branch_o === (expected_branch_o ^ branch_o ^ expected_branch_o) &&
                expected_jump_o === (expected_jump_o ^ jump_o ^ expected_jump_o) &&
                expected_mux8_o === (expected_mux8_o ^ mux8_o ^ expected_mux8_o)) begin
                $display("PASS");
                $display("  Outputs: branch_o=%b, jump_o=%b, mux8_o=%h",
                         branch_o, jump_o, mux8_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: branch_o=%b, jump_o=%b, mux8_o=%h",
                         expected_branch_o, expected_jump_o, expected_mux8_o);
                $display("  Got:      branch_o=%b, jump_o=%b, mux8_o=%h",
                         branch_o, jump_o, mux8_o);
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
