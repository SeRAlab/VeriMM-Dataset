`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg IDEX_MemRead;
    reg [4:0] IDEX_Rt;
    reg [4:0] IFID_Rs;
    reg [4:0] IFID_Rt;
    wire IFID_Write;
    wire PC_Write;
    wire Stall;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .IDEX_MemRead(IDEX_MemRead),
        .IDEX_Rt(IDEX_Rt),
        .IFID_Rs(IFID_Rs),
        .IFID_Rt(IFID_Rt),
        .IFID_Write(IFID_Write),
        .PC_Write(PC_Write),
        .Stall(Stall)
    );
    task testcase001;

        begin
            $display("\nTestcase 001: No Hazard - IDEX_MemRead is Low");
            IDEX_MemRead = 1'b0;
            IDEX_Rt = 5'd10;
            IFID_Rs = 5'd10;
            IFID_Rt = 5'd11;

            #1;


            check_outputs(1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: No Hazard - Registers do not match");
            IDEX_MemRead = 1'b1;
            IDEX_Rt = 5'd10;
            IFID_Rs = 5'd12;
            IFID_Rt = 5'd13;

            #1;


            check_outputs(1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: Hazard Detected - IDEX_Rt matches IFID_Rs");
            IDEX_MemRead = 1'b1;
            IDEX_Rt = 5'd15;
            IFID_Rs = 5'd15;
            IFID_Rt = 5'd20;

            #1;


            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: Hazard Detected - IDEX_Rt matches IFID_Rt");
            IDEX_MemRead = 1'b1;
            IDEX_Rt = 5'd22;
            IFID_Rs = 5'd21;
            IFID_Rt = 5'd22;

            #1;


            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: Hazard Detected - IDEX_Rt matches both IFID_Rs and IFID_Rt");
            IDEX_MemRead = 1'b1;
            IDEX_Rt = 5'd7;
            IFID_Rs = 5'd7;
            IFID_Rt = 5'd7;

            #1;


            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("\nTestcase 006: Hazard Detected - Match on Register 0");
            IDEX_MemRead = 1'b1;
            IDEX_Rt = 5'd0;
            IFID_Rs = 5'd0;
            IFID_Rt = 5'd5;


            #1;



            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            $display("\nTestcase 007: No Hazard - MemRead High, but source registers are different");
            IDEX_MemRead = 1'b1;
            IDEX_Rt = 5'd31;
            IFID_Rs = 5'd30;
            IFID_Rt = 5'd29;

            #1;


            check_outputs(1'b1, 1'b1, 1'b0);
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
        input expected_IFID_Write;
        input expected_PC_Write;
        input expected_Stall;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_IFID_Write === (expected_IFID_Write ^ IFID_Write ^ expected_IFID_Write) &&
                expected_PC_Write === (expected_PC_Write ^ PC_Write ^ expected_PC_Write) &&
                expected_Stall === (expected_Stall ^ Stall ^ expected_Stall)) begin
                $display("PASS");
                $display("  Outputs: IFID_Write=%b, PC_Write=%b, Stall=%b",
                         IFID_Write, PC_Write, Stall);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: IFID_Write=%b, PC_Write=%b, Stall=%b",
                         expected_IFID_Write, expected_PC_Write, expected_Stall);
                $display("  Got:      IFID_Write=%b, PC_Write=%b, Stall=%b",
                         IFID_Write, PC_Write, Stall);
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
