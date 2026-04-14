`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] csrALU_ctrl;
    reg [31:0] op1;
    reg [31:0] op2;
    wire [31:0] ALU_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .csrALU_ctrl(csrALU_ctrl),
        .op1(op1),
        .op2(op2),
        .ALU_out(ALU_out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: CSRRW Operation (ctrl=01)", test_num);
        op1 = 32'hAAAA_AAAA;
        op2 = 32'h5555_5555;
        csrALU_ctrl = 2'b01;
        #1;

        check_outputs(32'h5555_5555);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: CSRRS Operation (ctrl=10)", test_num);
        op1 = 32'hF0F0_AAAA;
        op2 = 32'h0F0F_5555;
        csrALU_ctrl = 2'b10;
        #1;

        check_outputs(32'hFFFF_FFFF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: CSRRC Operation (ctrl=11)", test_num);
        op1 = 32'hFFFF_FFFF;
        op2 = 32'h0000_FFFF;
        csrALU_ctrl = 2'b11;
        #1;

        check_outputs(32'hFFFF_0000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Default/Zero Operation (ctrl=00)", test_num);
        op1 = 32'hFFFF_FFFF;
        op2 = 32'hFFFF_FFFF;
        csrALU_ctrl = 2'b00;
        #1;

        check_outputs(32'h0000_0000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: CSRRC Specific Bits (ctrl=11)", test_num);
        op1 = 32'hDEAD_BEEF;
        op2 = 32'hDEAD_BEEF;
        csrALU_ctrl = 2'b11;
        #1;

        check_outputs(32'h0000_0000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: CSRRS with Zeros (ctrl=10)", test_num);
        op1 = 32'h0000_0000;
        op2 = 32'h1234_5678;
        csrALU_ctrl = 2'b10;
        #1;

        check_outputs(32'h1234_5678);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: CSRRW All Ones (ctrl=01)", test_num);
        op1 = 32'h0000_0000;
        op2 = 32'hFFFF_FFFF;
        csrALU_ctrl = 2'b01;
        #1;

        check_outputs(32'hFFFF_FFFF);
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
        input [31:0] expected_ALU_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ALU_out === (expected_ALU_out ^ ALU_out ^ expected_ALU_out)) begin
                $display("PASS");
                $display("  Outputs: ALU_out=%h",
                         ALU_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALU_out=%h",
                         expected_ALU_out);
                $display("  Got:      ALU_out=%h",
                         ALU_out);
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
