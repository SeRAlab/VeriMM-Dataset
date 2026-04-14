`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] inst_i;
    wire [31:0] imm_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .inst_i(inst_i),
        .imm_o(imm_o)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: ADDI Positive Immediate", test_num);
        inst_i = 32'h00A00013;
        #1;

        check_outputs(32'h0000000A);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: ADDI Negative Immediate", test_num);
        inst_i = 32'hFF600013;
        #1;

        check_outputs(32'hFFFFFFF6);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: LW Positive Immediate", test_num);
        inst_i = 32'h00C00003;
        #1;

        check_outputs(32'h0000000C);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: LW Maximum Negative Immediate", test_num);
        inst_i = 32'h80000003;
        #1;

        check_outputs(32'hFFFFF800);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: SW Positive Immediate", test_num);

        inst_i = 32'h00000523;
        #1;

        check_outputs(32'h0000000A);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: SW Negative Immediate", test_num);

        inst_i = 32'hFE000523;
        #1;

        check_outputs(32'hFFFFFFEA);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: BEQ Zero Immediate", test_num);
        inst_i = 32'h00000063;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: BEQ Negative Immediate", test_num);

        inst_i = 32'h80000063;
        #1;

        check_outputs(32'hFFFFF800);
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
        input [31:0] expected_imm_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_imm_o === (expected_imm_o ^ imm_o ^ expected_imm_o)) begin
                $display("PASS");
                $display("  Outputs: imm_o=%h",
                         imm_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: imm_o=%h",
                         expected_imm_o);
                $display("  Got:      imm_o=%h",
                         imm_o);
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
