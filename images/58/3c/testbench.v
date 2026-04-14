`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg Branch;
    reg Jump;
    reg MemRead_ID_EX;
    reg [4:0] Rs_IF_ID;
    reg RtRead_IF_ID;
    reg [4:0] Rt_ID_EX;
    reg [4:0] Rt_IF_ID;
    wire EX_MEM_Flush;
    wire EX_MEM_Stall;
    wire ID_EX_Flush;
    wire ID_EX_Stall;
    wire IF_ID_Flush;
    wire IF_ID_Stall;
    wire MEM_REG_Flush;
    wire MEM_REG_Stall;
    wire [1:0] PCSrc;
    wire loaduse;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Branch(Branch),
        .Jump(Jump),
        .MemRead_ID_EX(MemRead_ID_EX),
        .Rs_IF_ID(Rs_IF_ID),
        .RtRead_IF_ID(RtRead_IF_ID),
        .Rt_ID_EX(Rt_ID_EX),
        .Rt_IF_ID(Rt_IF_ID),
        .EX_MEM_Flush(EX_MEM_Flush),
        .EX_MEM_Stall(EX_MEM_Stall),
        .ID_EX_Flush(ID_EX_Flush),
        .ID_EX_Stall(ID_EX_Stall),
        .IF_ID_Flush(IF_ID_Flush),
        .IF_ID_Stall(IF_ID_Stall),
        .MEM_REG_Flush(MEM_REG_Flush),
        .MEM_REG_Stall(MEM_REG_Stall),
        .PCSrc(PCSrc),
        .loaduse(loaduse)
    );
    task testcase001;

        begin
            test_num = 1;
            Branch = 0; Jump = 0; MemRead_ID_EX = 0;
            Rs_IF_ID = 5'd1; Rt_IF_ID = 5'd2; RtRead_IF_ID = 1;
            Rt_ID_EX = 5'd3;

            #1;


            check_outputs(0, 0, 0, 0, 0, 0, 0, 0, 2'b00, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            Branch = 0; Jump = 0; MemRead_ID_EX = 1;
            Rs_IF_ID = 5'd10; Rt_IF_ID = 5'd11; RtRead_IF_ID = 1;
            Rt_ID_EX = 5'd10;

            #1;


            check_outputs(0, 0, 1, 0, 0, 1, 0, 0, 2'b00, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            Branch = 0; Jump = 0; MemRead_ID_EX = 1;
            Rs_IF_ID = 5'd5; Rt_IF_ID = 5'd12; RtRead_IF_ID = 1;
            Rt_ID_EX = 5'd12;

            #1;


            check_outputs(0, 0, 1, 0, 0, 1, 0, 0, 2'b00, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            Branch = 0; Jump = 0; MemRead_ID_EX = 1;
            Rs_IF_ID = 5'd5; Rt_IF_ID = 5'd12; RtRead_IF_ID = 0;
            Rt_ID_EX = 5'd12;

            #1;


            check_outputs(0, 0, 0, 0, 0, 0, 0, 0, 2'b00, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            Branch = 0; Jump = 1; MemRead_ID_EX = 0;
            Rs_IF_ID = 5'd1; Rt_IF_ID = 5'd2; RtRead_IF_ID = 0;
            Rt_ID_EX = 5'd0;

            #1;


            check_outputs(0, 0, 0, 0, 1, 0, 0, 0, 2'b10, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            Branch = 1; Jump = 0; MemRead_ID_EX = 0;
            Rs_IF_ID = 5'd1; Rt_IF_ID = 5'd2; RtRead_IF_ID = 0;
            Rt_ID_EX = 5'd0;

            #1;


            check_outputs(0, 0, 0, 0, 1, 0, 0, 0, 2'b01, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            Branch = 1; Jump = 0; MemRead_ID_EX = 1;
            Rs_IF_ID = 5'd10; Rt_IF_ID = 5'd11; RtRead_IF_ID = 1;
            Rt_ID_EX = 5'd10;


            #1;



            check_outputs(0, 0, 1, 0, 1, 1, 0, 0, 2'b01, 1);
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
        input expected_EX_MEM_Flush;
        input expected_EX_MEM_Stall;
        input expected_ID_EX_Flush;
        input expected_ID_EX_Stall;
        input expected_IF_ID_Flush;
        input expected_IF_ID_Stall;
        input expected_MEM_REG_Flush;
        input expected_MEM_REG_Stall;
        input [1:0] expected_PCSrc;
        input expected_loaduse;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_EX_MEM_Flush === (expected_EX_MEM_Flush ^ EX_MEM_Flush ^ expected_EX_MEM_Flush) &&
                expected_EX_MEM_Stall === (expected_EX_MEM_Stall ^ EX_MEM_Stall ^ expected_EX_MEM_Stall) &&
                expected_ID_EX_Flush === (expected_ID_EX_Flush ^ ID_EX_Flush ^ expected_ID_EX_Flush) &&
                expected_ID_EX_Stall === (expected_ID_EX_Stall ^ ID_EX_Stall ^ expected_ID_EX_Stall) &&
                expected_IF_ID_Flush === (expected_IF_ID_Flush ^ IF_ID_Flush ^ expected_IF_ID_Flush) &&
                expected_IF_ID_Stall === (expected_IF_ID_Stall ^ IF_ID_Stall ^ expected_IF_ID_Stall) &&
                expected_MEM_REG_Flush === (expected_MEM_REG_Flush ^ MEM_REG_Flush ^ expected_MEM_REG_Flush) &&
                expected_MEM_REG_Stall === (expected_MEM_REG_Stall ^ MEM_REG_Stall ^ expected_MEM_REG_Stall) &&
                expected_PCSrc === (expected_PCSrc ^ PCSrc ^ expected_PCSrc) &&
                expected_loaduse === (expected_loaduse ^ loaduse ^ expected_loaduse)) begin
                $display("PASS");
                $display("  Outputs: EX_MEM_Flush=%b, EX_MEM_Stall=%b, ID_EX_Flush=%b, ID_EX_Stall=%b, IF_ID_Flush=%b, IF_ID_Stall=%b, MEM_REG_Flush=%b, MEM_REG_Stall=%b, PCSrc=%h, loaduse=%b",
                         EX_MEM_Flush, EX_MEM_Stall, ID_EX_Flush, ID_EX_Stall, IF_ID_Flush, IF_ID_Stall, MEM_REG_Flush, MEM_REG_Stall, PCSrc, loaduse);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: EX_MEM_Flush=%b, EX_MEM_Stall=%b, ID_EX_Flush=%b, ID_EX_Stall=%b, IF_ID_Flush=%b, IF_ID_Stall=%b, MEM_REG_Flush=%b, MEM_REG_Stall=%b, PCSrc=%h, loaduse=%b",
                         expected_EX_MEM_Flush, expected_EX_MEM_Stall, expected_ID_EX_Flush, expected_ID_EX_Stall, expected_IF_ID_Flush, expected_IF_ID_Stall, expected_MEM_REG_Flush, expected_MEM_REG_Stall, expected_PCSrc, expected_loaduse);
                $display("  Got:      EX_MEM_Flush=%b, EX_MEM_Stall=%b, ID_EX_Flush=%b, ID_EX_Stall=%b, IF_ID_Flush=%b, IF_ID_Stall=%b, MEM_REG_Flush=%b, MEM_REG_Stall=%b, PCSrc=%h, loaduse=%b",
                         EX_MEM_Flush, EX_MEM_Stall, ID_EX_Flush, ID_EX_Stall, IF_ID_Flush, IF_ID_Stall, MEM_REG_Flush, MEM_REG_Stall, PCSrc, loaduse);
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
