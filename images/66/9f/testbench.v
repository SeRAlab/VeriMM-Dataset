`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] Rd_From_EX_MEM;
    reg [4:0] Rd_From_MEM_WB;
    reg [1:0] RegDst;
    reg [1:0] RegRead;
    reg [3:0] RegWrite_From_EX_MEM;
    reg [3:0] RegWrite_From_MEM_WB;
    reg [4:0] Rs_From_ID_EX;
    reg [4:0] Rs_From_IF_ID;
    reg [4:0] Rt_From_ID_EX;
    reg [4:0] Rt_From_IF_ID;
    wire [1:0] Rs_EX_Forward;
    wire Rs_LoudUse_Forward;
    wire [1:0] Rt_EX_Forward;
    wire Rt_LoudUse_Forward;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Rd_From_EX_MEM(Rd_From_EX_MEM),
        .Rd_From_MEM_WB(Rd_From_MEM_WB),
        .RegDst(RegDst),
        .RegRead(RegRead),
        .RegWrite_From_EX_MEM(RegWrite_From_EX_MEM),
        .RegWrite_From_MEM_WB(RegWrite_From_MEM_WB),
        .Rs_From_ID_EX(Rs_From_ID_EX),
        .Rs_From_IF_ID(Rs_From_IF_ID),
        .Rt_From_ID_EX(Rt_From_ID_EX),
        .Rt_From_IF_ID(Rt_From_IF_ID),
        .Rs_EX_Forward(Rs_EX_Forward),
        .Rs_LoudUse_Forward(Rs_LoudUse_Forward),
        .Rt_EX_Forward(Rt_EX_Forward),
        .Rt_LoudUse_Forward(Rt_LoudUse_Forward)
    );
    task testcase001;

        begin
            test_num = 1;
            RegDst = 2'b01;
            Rt_From_ID_EX = 5'd1;
            Rs_From_ID_EX = 5'd2;
            Rd_From_EX_MEM = 5'd3;
            RegWrite_From_EX_MEM = 4'hF;
            Rd_From_MEM_WB = 5'd4;
            RegWrite_From_MEM_WB = 4'hF;
            Rt_From_IF_ID = 5'd5;
            Rs_From_IF_ID = 5'd6;
            RegRead = 2'b11;

            #1;


            check_outputs(2'b00, 1'b0, 2'b00, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            Rs_From_ID_EX = 5'd10;
            Rd_From_EX_MEM = 5'd10;
            RegWrite_From_EX_MEM = 4'hF;


            Rt_From_ID_EX = 5'd1;
            Rd_From_MEM_WB = 5'd4;
            RegWrite_From_MEM_WB = 4'h0;

            #1;


            check_outputs(2'b10, 1'b0, 2'b00, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            Rt_From_ID_EX = 5'd15;
            Rd_From_EX_MEM = 5'd15;
            RegWrite_From_EX_MEM = 4'hF;

            Rs_From_ID_EX = 5'd1;
            Rd_From_MEM_WB = 5'd4;

            #1;


            check_outputs(2'b00, 1'b0, 2'b10, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            Rs_From_ID_EX = 5'd20;
            Rd_From_MEM_WB = 5'd20;
            RegWrite_From_MEM_WB = 4'hF;

            Rd_From_EX_MEM = 5'd5;
            RegWrite_From_EX_MEM = 4'h0;

            #1;


            check_outputs(2'b01, 1'b0, 2'b00, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            Rs_From_ID_EX = 5'd25;
            Rd_From_EX_MEM = 5'd25;
            RegWrite_From_EX_MEM = 4'hF;
            Rd_From_MEM_WB = 5'd25;
            RegWrite_From_MEM_WB = 4'hF;

            #1;


            check_outputs(2'b10, 1'b0, 2'b00, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            Rs_From_ID_EX = 5'd0;
            Rd_From_EX_MEM = 5'd0;
            RegWrite_From_EX_MEM = 4'hF;

            #1;


            check_outputs(2'b00, 1'b0, 2'b00, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            Rs_From_IF_ID = 5'd8;
            Rd_From_EX_MEM = 5'd8;
            RegRead = 2'b10;


            Rs_From_ID_EX = 5'd31;
            Rt_From_ID_EX = 5'd31;

            #1;


            check_outputs(2'b00, 1'b1, 2'b00, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            Rt_From_IF_ID = 5'd9;
            Rd_From_EX_MEM = 5'd9;
            RegRead = 2'b01;

            #1;


            check_outputs(2'b00, 1'b0, 2'b00, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            Rs_From_ID_EX = 5'd12;
            Rd_From_EX_MEM = 5'd12;
            RegWrite_From_EX_MEM = 4'h0;

            #1;


            check_outputs(2'b00, 1'b0, 2'b00, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            Rs_From_ID_EX = 5'd1;
            Rd_From_EX_MEM = 5'd1;
            RegWrite_From_EX_MEM = 4'hF;

            Rt_From_ID_EX = 5'd2;
            Rd_From_MEM_WB = 5'd2;
            RegWrite_From_MEM_WB = 4'hF;

            #1;


            check_outputs(2'b10, 1'b0, 2'b01, 1'b0);
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
        input [1:0] expected_Rs_EX_Forward;
        input expected_Rs_LoudUse_Forward;
        input [1:0] expected_Rt_EX_Forward;
        input expected_Rt_LoudUse_Forward;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Rs_EX_Forward === (expected_Rs_EX_Forward ^ Rs_EX_Forward ^ expected_Rs_EX_Forward) &&
                expected_Rs_LoudUse_Forward === (expected_Rs_LoudUse_Forward ^ Rs_LoudUse_Forward ^ expected_Rs_LoudUse_Forward) &&
                expected_Rt_EX_Forward === (expected_Rt_EX_Forward ^ Rt_EX_Forward ^ expected_Rt_EX_Forward) &&
                expected_Rt_LoudUse_Forward === (expected_Rt_LoudUse_Forward ^ Rt_LoudUse_Forward ^ expected_Rt_LoudUse_Forward)) begin
                $display("PASS");
                $display("  Outputs: Rs_EX_Forward=%h, Rs_LoudUse_Forward=%b, Rt_EX_Forward=%h, Rt_LoudUse_Forward=%b",
                         Rs_EX_Forward, Rs_LoudUse_Forward, Rt_EX_Forward, Rt_LoudUse_Forward);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Rs_EX_Forward=%h, Rs_LoudUse_Forward=%b, Rt_EX_Forward=%h, Rt_LoudUse_Forward=%b",
                         expected_Rs_EX_Forward, expected_Rs_LoudUse_Forward, expected_Rt_EX_Forward, expected_Rt_LoudUse_Forward);
                $display("  Got:      Rs_EX_Forward=%h, Rs_LoudUse_Forward=%b, Rt_EX_Forward=%h, Rt_LoudUse_Forward=%b",
                         Rs_EX_Forward, Rs_LoudUse_Forward, Rt_EX_Forward, Rt_LoudUse_Forward);
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
