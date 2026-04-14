`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg p_mix_sig_01_go;
    reg p_mix_sig_03_go;
    reg p_mix_sig_04_gi;
    reg [1:0] p_mix_sig_05_2_1_go;
    reg p_mix_sig_05_2_2_goBus;
    reg [7:0] p_mix_sig_i_ae_gi;
    wire [7:0] p_mix_sig_o_ae_go;
    wire [5:0] sig_c_07;
    wire [5:0] sig_c_08;
    wire [4:0] sig_c_13;
    wire sig_c_i_a2;
    wire sig_c_o_a2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .p_mix_sig_01_go(p_mix_sig_01_go),
        .p_mix_sig_03_go(p_mix_sig_03_go),
        .p_mix_sig_04_gi(p_mix_sig_04_gi),
        .p_mix_sig_05_2_1_go(p_mix_sig_05_2_1_go),
        .p_mix_sig_05_2_2_goBus(p_mix_sig_05_2_2_goBus),
        .p_mix_sig_i_ae_gi(p_mix_sig_i_ae_gi),
        .p_mix_sig_o_ae_go(p_mix_sig_o_ae_go),
        .sig_c_07(sig_c_07),
        .sig_c_08(sig_c_08),
        .sig_c_13(sig_c_13),
        .sig_c_i_a2(sig_c_i_a2),
        .sig_c_o_a2(sig_c_o_a2)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Signals Zero", test_num);
        p_mix_sig_01_go = 1'b0;
        p_mix_sig_03_go = 1'b0;
        p_mix_sig_04_gi = 1'b0;
        p_mix_sig_05_2_1_go = 2'b00;
        p_mix_sig_05_2_2_goBus = 1'b0;
        p_mix_sig_i_ae_gi = 8'h00;


        #1;



        check_outputs(8'h00, 6'h00, 6'h00, 5'h00, 1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Signals Asserted", test_num);
        p_mix_sig_01_go = 1'b1;
        p_mix_sig_03_go = 1'b1;
        p_mix_sig_04_gi = 1'b1;
        p_mix_sig_05_2_1_go = 2'b11;
        p_mix_sig_05_2_2_goBus = 1'b1;
        p_mix_sig_i_ae_gi = 8'hFF;


        #1;



        check_outputs(8'hFF, 6'h3F, 6'h3F, 5'h1F, 1'b1, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Alternating Pattern 1", test_num);
        p_mix_sig_01_go = 1'b1;
        p_mix_sig_03_go = 1'b0;
        p_mix_sig_04_gi = 1'b1;
        p_mix_sig_05_2_1_go = 2'b10;
        p_mix_sig_05_2_2_goBus = 1'b0;
        p_mix_sig_i_ae_gi = 8'h55;



        #1;




        check_outputs(8'h55, 6'h15, 6'h15, 5'h15, 1'b1, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Alternating Pattern 2", test_num);
        p_mix_sig_01_go = 1'b0;
        p_mix_sig_03_go = 1'b1;
        p_mix_sig_04_gi = 1'b0;
        p_mix_sig_05_2_1_go = 2'b01;
        p_mix_sig_05_2_2_goBus = 1'b1;
        p_mix_sig_i_ae_gi = 8'hAA;



        #1;




        check_outputs(8'hAA, 6'h2A, 6'h2A, 5'h0A, 1'b0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Specific Bit Toggles", test_num);
        p_mix_sig_01_go = 1'b0;
        p_mix_sig_03_go = 1'b1;
        p_mix_sig_04_gi = 1'b1;
        p_mix_sig_05_2_1_go = 2'b00;
        p_mix_sig_05_2_2_goBus = 1'b0;
        p_mix_sig_i_ae_gi = 8'hC3;





        #1;






        check_outputs(8'hC3, 6'h06, 6'h06, 5'h06, 1'b1, 1'b0);
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
        input [7:0] expected_p_mix_sig_o_ae_go;
        input [5:0] expected_sig_c_07;
        input [5:0] expected_sig_c_08;
        input [4:0] expected_sig_c_13;
        input expected_sig_c_i_a2;
        input expected_sig_c_o_a2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_p_mix_sig_o_ae_go === (expected_p_mix_sig_o_ae_go ^ p_mix_sig_o_ae_go ^ expected_p_mix_sig_o_ae_go) &&
                expected_sig_c_07 === (expected_sig_c_07 ^ sig_c_07 ^ expected_sig_c_07) &&
                expected_sig_c_08 === (expected_sig_c_08 ^ sig_c_08 ^ expected_sig_c_08) &&
                expected_sig_c_13 === (expected_sig_c_13 ^ sig_c_13 ^ expected_sig_c_13) &&
                expected_sig_c_i_a2 === (expected_sig_c_i_a2 ^ sig_c_i_a2 ^ expected_sig_c_i_a2) &&
                expected_sig_c_o_a2 === (expected_sig_c_o_a2 ^ sig_c_o_a2 ^ expected_sig_c_o_a2)) begin
                $display("PASS");
                $display("  Outputs: p_mix_sig_o_ae_go=%h, sig_c_07=%h, sig_c_08=%h, sig_c_13=%h, sig_c_i_a2=%b, sig_c_o_a2=%b",
                         p_mix_sig_o_ae_go, sig_c_07, sig_c_08, sig_c_13, sig_c_i_a2, sig_c_o_a2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: p_mix_sig_o_ae_go=%h, sig_c_07=%h, sig_c_08=%h, sig_c_13=%h, sig_c_i_a2=%b, sig_c_o_a2=%b",
                         expected_p_mix_sig_o_ae_go, expected_sig_c_07, expected_sig_c_08, expected_sig_c_13, expected_sig_c_i_a2, expected_sig_c_o_a2);
                $display("  Got:      p_mix_sig_o_ae_go=%h, sig_c_07=%h, sig_c_08=%h, sig_c_13=%h, sig_c_i_a2=%b, sig_c_o_a2=%b",
                         p_mix_sig_o_ae_go, sig_c_07, sig_c_08, sig_c_13, sig_c_i_a2, sig_c_o_a2);
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
