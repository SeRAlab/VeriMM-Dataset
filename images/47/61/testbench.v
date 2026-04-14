`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] de_Rs;
    reg [2:0] de_Rt;
    reg em_reg_wr;
    reg [2:0] em_write_reg;
    reg mw_reg_wr;
    reg [2:0] mw_write_reg;
    wire [1:0] frwrd_sel_A;
    wire [1:0] frwrd_sel_B;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .de_Rs(de_Rs),
        .de_Rt(de_Rt),
        .em_reg_wr(em_reg_wr),
        .em_write_reg(em_write_reg),
        .mw_reg_wr(mw_reg_wr),
        .mw_write_reg(mw_write_reg),
        .frwrd_sel_A(frwrd_sel_A),
        .frwrd_sel_B(frwrd_sel_B)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: No hazards", test_num);
        de_Rs = 3'd1;
        de_Rt = 3'd2;
        em_reg_wr = 0;
        em_write_reg = 3'd3;
        mw_reg_wr = 0;
        mw_write_reg = 3'd4;
        #1;

        check_outputs(2'b00, 2'b00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: EX Stage Hazard on Rs", test_num);
        de_Rs = 3'd1;
        de_Rt = 3'd2;
        em_reg_wr = 1;
        em_write_reg = 3'd1;
        mw_reg_wr = 0;
        mw_write_reg = 3'd4;
        #1;

        check_outputs(2'b10, 2'b00);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: EX Stage Hazard on Rt", test_num);
        de_Rs = 3'd1;
        de_Rt = 3'd2;
        em_reg_wr = 1;
        em_write_reg = 3'd2;
        mw_reg_wr = 0;
        mw_write_reg = 3'd4;
        #1;

        check_outputs(2'b00, 2'b10);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: MEM Stage Hazard on Rs", test_num);
        de_Rs = 3'd3;
        de_Rt = 3'd4;
        em_reg_wr = 0;
        em_write_reg = 3'd1;
        mw_reg_wr = 1;
        mw_write_reg = 3'd3;
        #1;

        check_outputs(2'b01, 2'b00);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: MEM Stage Hazard on Rt", test_num);
        de_Rs = 3'd3;
        de_Rt = 3'd4;
        em_reg_wr = 0;
        em_write_reg = 3'd1;
        mw_reg_wr = 1;
        mw_write_reg = 3'd4;
        #1;

        check_outputs(2'b00, 2'b01);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: EX Hazard (Rs) and MEM Hazard (Rt)", test_num);
        de_Rs = 3'd5;
        de_Rt = 3'd6;
        em_reg_wr = 1;
        em_write_reg = 3'd5;
        mw_reg_wr = 1;
        mw_write_reg = 3'd6;
        #1;

        check_outputs(2'b10, 2'b01);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Priority Test - EX/MEM over MEM/WB for Rs", test_num);
        de_Rs = 3'd2;
        de_Rt = 3'd7;
        em_reg_wr = 1;
        em_write_reg = 3'd2;
        mw_reg_wr = 1;
        mw_write_reg = 3'd2;
        #1;

        check_outputs(2'b10, 2'b00);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Priority Test - EX/MEM over MEM/WB for Rt", test_num);
        de_Rs = 3'd7;
        de_Rt = 3'd2;
        em_reg_wr = 1;
        em_write_reg = 3'd2;
        mw_reg_wr = 1;
        mw_write_reg = 3'd2;
        #1;

        check_outputs(2'b00, 2'b10);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case %0d: Hazard match but reg_wr is 0", test_num);
        de_Rs = 3'd1;
        de_Rt = 3'd1;
        em_reg_wr = 0;
        em_write_reg = 3'd1;
        mw_reg_wr = 0;
        mw_write_reg = 3'd1;
        #1;

        check_outputs(2'b00, 2'b00);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case %0d: Register 0 check", test_num);
        de_Rs = 3'd0;
        de_Rt = 3'd0;
        em_reg_wr = 1;
        em_write_reg = 3'd0;
        mw_reg_wr = 1;
        mw_write_reg = 3'd0;
        #1;

        check_outputs(2'b00, 2'b00);
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
        input [1:0] expected_frwrd_sel_A;
        input [1:0] expected_frwrd_sel_B;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_frwrd_sel_A === (expected_frwrd_sel_A ^ frwrd_sel_A ^ expected_frwrd_sel_A) &&
                expected_frwrd_sel_B === (expected_frwrd_sel_B ^ frwrd_sel_B ^ expected_frwrd_sel_B)) begin
                $display("PASS");
                $display("  Outputs: frwrd_sel_A=%h, frwrd_sel_B=%h",
                         frwrd_sel_A, frwrd_sel_B);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: frwrd_sel_A=%h, frwrd_sel_B=%h",
                         expected_frwrd_sel_A, expected_frwrd_sel_B);
                $display("  Got:      frwrd_sel_A=%h, frwrd_sel_B=%h",
                         frwrd_sel_A, frwrd_sel_B);
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
