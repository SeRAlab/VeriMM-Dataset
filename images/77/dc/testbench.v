`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] DI_adr;
    reg DI_bra;
    reg DI_jmp;
    reg [31:0] DI_jmp_target;
    reg [31:0] EI_adr;
    reg [31:0] EX_adr;
    reg [31:0] EX_adresse;
    reg EX_bra_confirm;
    reg EX_cleared;
    reg EX_jr;
    reg clk_i;
    reg rst_i;
    wire [31:0] PR_bra_adr;
    wire PR_bra_bad;
    wire PR_bra_cmd;
    wire PR_clear_DI;
    wire PR_clear_EI;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .DI_adr(DI_adr),
        .DI_bra(DI_bra),
        .DI_jmp(DI_jmp),
        .DI_jmp_target(DI_jmp_target),
        .EI_adr(EI_adr),
        .EX_adr(EX_adr),
        .EX_adresse(EX_adresse),
        .EX_bra_confirm(EX_bra_confirm),
        .EX_cleared(EX_cleared),
        .EX_jr(EX_jr),
        .clk_i(clk_i),
        .rst_i(rst_i),
        .PR_bra_adr(PR_bra_adr),
        .PR_bra_bad(PR_bra_bad),
        .PR_bra_cmd(PR_bra_cmd),
        .PR_clear_DI(PR_clear_DI),
        .PR_clear_EI(PR_clear_EI)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(32'h0, 0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Decode Jump", test_num);
            reset_dut();
            DI_jmp = 1;
            DI_jmp_target = 32'h0000_1000;
            @(posedge clk_i);

            #1;


            check_outputs(32'h0000_1000, 0, 1, 0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Execute Branch Confirmation", test_num);
            reset_dut();
            EX_bra_confirm = 1;
            EX_adresse = 32'hFFFF_0000;
            @(posedge clk_i);

            #1;


            check_outputs(32'hFFFF_0000, 1, 1, 1, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Execute Jump Register", test_num);
            reset_dut();
            EX_jr = 1;
            EX_adresse = 32'hAAAA_5555;
            @(posedge clk_i);

            #1;


            check_outputs(32'hAAAA_5555, 0, 1, 1, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Priority (EX over DI)", test_num);
            reset_dut();

            DI_jmp = 1;
            DI_jmp_target = 32'h1111_1111;
            EX_bra_confirm = 1;
            EX_adresse = 32'hEEEE_EEEE;
            @(posedge clk_i);

            #1;


            check_outputs(32'hEEEE_EEEE, 1, 1, 1, 1);
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
        input [31:0] expected_PR_bra_adr;
        input expected_PR_bra_bad;
        input expected_PR_bra_cmd;
        input expected_PR_clear_DI;
        input expected_PR_clear_EI;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_PR_bra_adr === (expected_PR_bra_adr ^ PR_bra_adr ^ expected_PR_bra_adr) &&
                expected_PR_bra_bad === (expected_PR_bra_bad ^ PR_bra_bad ^ expected_PR_bra_bad) &&
                expected_PR_bra_cmd === (expected_PR_bra_cmd ^ PR_bra_cmd ^ expected_PR_bra_cmd) &&
                expected_PR_clear_DI === (expected_PR_clear_DI ^ PR_clear_DI ^ expected_PR_clear_DI) &&
                expected_PR_clear_EI === (expected_PR_clear_EI ^ PR_clear_EI ^ expected_PR_clear_EI)) begin
                $display("PASS");
                $display("  Outputs: PR_bra_adr=%h, PR_bra_bad=%b, PR_bra_cmd=%b, PR_clear_DI=%b, PR_clear_EI=%b",
                         PR_bra_adr, PR_bra_bad, PR_bra_cmd, PR_clear_DI, PR_clear_EI);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: PR_bra_adr=%h, PR_bra_bad=%b, PR_bra_cmd=%b, PR_clear_DI=%b, PR_clear_EI=%b",
                         expected_PR_bra_adr, expected_PR_bra_bad, expected_PR_bra_cmd, expected_PR_clear_DI, expected_PR_clear_EI);
                $display("  Got:      PR_bra_adr=%h, PR_bra_bad=%b, PR_bra_cmd=%b, PR_clear_DI=%b, PR_clear_EI=%b",
                         PR_bra_adr, PR_bra_bad, PR_bra_cmd, PR_clear_DI, PR_clear_EI);
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
