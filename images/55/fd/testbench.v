`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A_i;
    reg [7:0] B_i;
    reg [7:0] C_i;
    reg [7:0] D_i;
    reg [7:0] E_i;
    reg [7:0] F_i;
    reg [7:0] G_i;
    reg [7:0] H_i;
    reg SAB_i;
    reg SC_i;
    reg SD_i;
    reg SE_i;
    reg SF_i;
    reg SG_i;
    reg SH_i;
    wire [7:0] Y_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A_i(A_i),
        .B_i(B_i),
        .C_i(C_i),
        .D_i(D_i),
        .E_i(E_i),
        .F_i(F_i),
        .G_i(G_i),
        .H_i(H_i),
        .SAB_i(SAB_i),
        .SC_i(SC_i),
        .SD_i(SD_i),
        .SE_i(SE_i),
        .SF_i(SF_i),
        .SG_i(SG_i),
        .SH_i(SH_i),
        .Y_o(Y_o)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Select A_i (All selects 0)", test_num);
            A_i = 8'hA1; B_i = 8'hB2; C_i = 8'hC3; D_i = 8'hD4;
            E_i = 8'hE5; F_i = 8'hF6; G_i = 8'hG7; H_i = 8'hH8;
            SAB_i = 0; SC_i = 0; SD_i = 0; SE_i = 0; SF_i = 0; SG_i = 0; SH_i = 0;
            #1;

            check_outputs(8'hA1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Select B_i (SAB_i=1, others 0)", test_num);
            A_i = 8'h11; B_i = 8'h22; C_i = 8'h33; D_i = 8'h44;
            E_i = 8'h55; F_i = 8'h66; G_i = 8'h77; H_i = 8'h88;
            SAB_i = 1; SC_i = 0; SD_i = 0; SE_i = 0; SF_i = 0; SG_i = 0; SH_i = 0;
            #1;

            check_outputs(8'h22);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Select C_i (SC_i=1, others higher bits 0)", test_num);
            A_i = 8'h01; B_i = 8'h02; C_i = 8'h03; D_i = 8'h04;
            E_i = 8'h05; F_i = 8'h06; G_i = 8'h07; H_i = 8'h08;
            SAB_i = 0; SC_i = 1; SD_i = 0; SE_i = 0; SF_i = 0; SG_i = 0; SH_i = 0;
            #1;

            check_outputs(8'h03);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Select D_i (SD_i=1, others higher bits 0)", test_num);
            A_i = 8'hD1; B_i = 8'hD2; C_i = 8'hD3; D_i = 8'hD4;
            E_i = 8'hD5; F_i = 8'hD6; G_i = 8'hD7; H_i = 8'hD8;
            SAB_i = 1; SC_i = 1; SD_i = 1; SE_i = 0; SF_i = 0; SG_i = 0; SH_i = 0;
            #1;

            check_outputs(8'hD4);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Select E_i (SE_i=1, others higher bits 0)", test_num);
            E_i = 8'hEE;
            SAB_i = 0; SC_i = 0; SD_i = 0; SE_i = 1; SF_i = 0; SG_i = 0; SH_i = 0;
            #1;

            check_outputs(8'hEE);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Select F_i (SF_i=1, others higher bits 0)", test_num);
            F_i = 8'hFF;
            SAB_i = 1; SC_i = 1; SD_i = 1; SE_i = 1; SF_i = 1; SG_i = 0; SH_i = 0;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Select G_i (SG_i=1, SH_i=0)", test_num);
            G_i = 8'h7G;
            SAB_i = 0; SC_i = 0; SD_i = 0; SE_i = 0; SF_i = 0; SG_i = 1; SH_i = 0;
            #1;

            check_outputs(8'h7G);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Select H_i (SH_i=1)", test_num);
            H_i = 8'h8H;
            SAB_i = 1; SC_i = 1; SD_i = 1; SE_i = 1; SF_i = 1; SG_i = 1; SH_i = 1;
            #1;

            check_outputs(8'h8H);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Priority Check (SH_i overrides all)", test_num);
            A_i = 8'h00; B_i = 8'h00; C_i = 8'h00; D_i = 8'h00;
            E_i = 8'h00; F_i = 8'h00; G_i = 8'h00; H_i = 8'h99;
            SAB_i = 0; SC_i = 0; SD_i = 0; SE_i = 0; SF_i = 0; SG_i = 0; SH_i = 1;
            #1;

            check_outputs(8'h99);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: Progressive Selection (Selection of C with SAB active)", test_num);
            A_i = 8'hAA; B_i = 8'hBB; C_i = 8'hCC;
            SAB_i = 1;
            SC_i = 1;
            SD_i = 0; SE_i = 0; SF_i = 0; SG_i = 0; SH_i = 0;
            #1;

            check_outputs(8'hCC);
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
        input [7:0] expected_Y_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y_o === (expected_Y_o ^ Y_o ^ expected_Y_o)) begin
                $display("PASS");
                $display("  Outputs: Y_o=%h",
                         Y_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y_o=%h",
                         expected_Y_o);
                $display("  Got:      Y_o=%h",
                         Y_o);
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
