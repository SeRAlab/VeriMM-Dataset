`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] inst;
    wire [63:0] addi_imm;
    wire [31:0] branch_imm;
    wire [31:0] jal_imm;
    wire [31:0] jalr_imm;
    wire [63:0] sd_imm;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .inst(inst),
        .addi_imm(addi_imm),
        .branch_imm(branch_imm),
        .jal_imm(jal_imm),
        .jalr_imm(jalr_imm),
        .sd_imm(sd_imm)
    );
    task testcase001;

        begin
            test_num = 1;
            inst = 32'h00000000;
            #1;

            check_outputs(64'h0, 32'h0, 32'h0, 32'h0, 64'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            inst = 32'h00100000;




            #1;





            check_outputs(64'h1, 32'h0, 32'h1000, 32'h1, 64'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            inst = 32'hFFF00000;




            #1;





            check_outputs(64'hFFFFFFFFFFFFFFFF, 32'hFFFFF7E0, 32'hFFF0007FE, 32'hFFFFFFFF, 64'hFFFFFFFFFFFFFFE0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            inst = 32'h00000080;



            #1;




            check_outputs(64'h0, 32'h800, 32'h0, 32'h0, 64'h1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            inst = 32'h12345678;




            #1;





            check_outputs(64'h123, 32'h92C, 32'h45B22, 32'h123, 64'h12C);
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
        input [63:0] expected_addi_imm;
        input [31:0] expected_branch_imm;
        input [31:0] expected_jal_imm;
        input [31:0] expected_jalr_imm;
        input [63:0] expected_sd_imm;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_addi_imm === (expected_addi_imm ^ addi_imm ^ expected_addi_imm) &&
                expected_branch_imm === (expected_branch_imm ^ branch_imm ^ expected_branch_imm) &&
                expected_jal_imm === (expected_jal_imm ^ jal_imm ^ expected_jal_imm) &&
                expected_jalr_imm === (expected_jalr_imm ^ jalr_imm ^ expected_jalr_imm) &&
                expected_sd_imm === (expected_sd_imm ^ sd_imm ^ expected_sd_imm)) begin
                $display("PASS");
                $display("  Outputs: addi_imm=%h, branch_imm=%h, jal_imm=%h, jalr_imm=%h, sd_imm=%h",
                         addi_imm, branch_imm, jal_imm, jalr_imm, sd_imm);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: addi_imm=%h, branch_imm=%h, jal_imm=%h, jalr_imm=%h, sd_imm=%h",
                         expected_addi_imm, expected_branch_imm, expected_jal_imm, expected_jalr_imm, expected_sd_imm);
                $display("  Got:      addi_imm=%h, branch_imm=%h, jal_imm=%h, jalr_imm=%h, sd_imm=%h",
                         addi_imm, branch_imm, jal_imm, jalr_imm, sd_imm);
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
