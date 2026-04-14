`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg EX_MEM_MemRead;
    reg [4:0] EX_MEM_Rd;
    reg [4:0] EX_Rd;
    reg ID_EX_MemRead;
    reg [4:0] ID_Rs;
    reg [4:0] ID_Rt;
    reg [2:0] PCSrc;
    wire Stall;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .EX_MEM_MemRead(EX_MEM_MemRead),
        .EX_MEM_Rd(EX_MEM_Rd),
        .EX_Rd(EX_Rd),
        .ID_EX_MemRead(ID_EX_MemRead),
        .ID_Rs(ID_Rs),
        .ID_Rt(ID_Rt),
        .PCSrc(PCSrc),
        .Stall(Stall)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: No Hazard (All Zero)", test_num);
            ID_EX_MemRead = 0;
            EX_MEM_MemRead = 0;
            EX_Rd = 5'd0;
            EX_MEM_Rd = 5'd0;
            ID_Rs = 5'd1;
            ID_Rt = 5'd2;
            PCSrc = 3'b000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: EX Stage Load-Use Hazard (Rs match)", test_num);
            ID_EX_MemRead = 1;
            EX_MEM_MemRead = 0;
            EX_Rd = 5'd10;
            EX_MEM_Rd = 5'd0;
            ID_Rs = 5'd10;
            ID_Rt = 5'd11;
            PCSrc = 3'b000;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: EX Stage Load-Use Hazard (Rt match)", test_num);
            ID_EX_MemRead = 1;
            EX_MEM_MemRead = 0;
            EX_Rd = 5'd15;
            EX_MEM_Rd = 5'd0;
            ID_Rs = 5'd10;
            ID_Rt = 5'd15;
            PCSrc = 3'b000;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: MEM Stage Load-Use Hazard (Rs match)", test_num);
            ID_EX_MemRead = 0;
            EX_MEM_MemRead = 1;
            EX_Rd = 5'd0;
            EX_MEM_Rd = 5'd20;
            ID_Rs = 5'd20;
            ID_Rt = 5'd21;
            PCSrc = 3'b000;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: MEM Stage Load-Use Hazard (Rt match)", test_num);
            ID_EX_MemRead = 0;
            EX_MEM_MemRead = 1;
            EX_Rd = 5'd0;
            EX_MEM_Rd = 5'd25;
            ID_Rs = 5'd20;
            ID_Rt = 5'd25;
            PCSrc = 3'b000;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Register Match but no MemRead", test_num);
            ID_EX_MemRead = 0;
            EX_MEM_MemRead = 0;
            EX_Rd = 5'd10;
            EX_MEM_Rd = 5'd10;
            ID_Rs = 5'd10;
            ID_Rt = 5'd10;
            PCSrc = 3'b000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Control Hazard (PCSrc non-zero)", test_num);
            ID_EX_MemRead = 0;
            EX_MEM_MemRead = 0;
            EX_Rd = 5'd0;
            EX_MEM_Rd = 5'd0;
            ID_Rs = 5'd1;
            ID_Rt = 5'd2;
            PCSrc = 3'b001;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Hazard Check on Register 0", test_num);
            ID_EX_MemRead = 1;
            EX_MEM_MemRead = 0;
            EX_Rd = 5'd0;
            EX_MEM_Rd = 5'd0;
            ID_Rs = 5'd0;
            ID_Rt = 5'd5;
            PCSrc = 3'b000;



            #1;




            check_outputs(1'b1);
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
        input expected_Stall;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Stall === (expected_Stall ^ Stall ^ expected_Stall)) begin
                $display("PASS");
                $display("  Outputs: Stall=%b",
                         Stall);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Stall=%b",
                         expected_Stall);
                $display("  Got:      Stall=%b",
                         Stall);
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
