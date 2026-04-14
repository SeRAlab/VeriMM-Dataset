`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] EX_MEM_RD;
    reg EX_MEM_RegWrite;
    reg [4:0] ID_EX_RS;
    reg [4:0] MEM_WB_RD;
    reg MEM_WB_RegWrite;
    wire [1:0] Forward;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .EX_MEM_RD(EX_MEM_RD),
        .EX_MEM_RegWrite(EX_MEM_RegWrite),
        .ID_EX_RS(ID_EX_RS),
        .MEM_WB_RD(MEM_WB_RD),
        .MEM_WB_RegWrite(MEM_WB_RegWrite),
        .Forward(Forward)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: No forwarding - Registers do not match", test_num);
            ID_EX_RS = 5'd10;
            EX_MEM_RD = 5'd11;
            MEM_WB_RD = 5'd12;
            EX_MEM_RegWrite = 1'b1;
            MEM_WB_RegWrite = 1'b1;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: EX Hazard - Forward from EX/MEM stage", test_num);
            ID_EX_RS = 5'd15;
            EX_MEM_RD = 5'd15;
            MEM_WB_RD = 5'd12;
            EX_MEM_RegWrite = 1'b1;
            MEM_WB_RegWrite = 1'b0;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: MEM Hazard - Forward from MEM/WB stage", test_num);
            ID_EX_RS = 5'd20;
            EX_MEM_RD = 5'd11;
            MEM_WB_RD = 5'd20;
            EX_MEM_RegWrite = 1'b0;
            MEM_WB_RegWrite = 1'b1;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Double Hazard - Priority to EX/MEM stage", test_num);
            ID_EX_RS = 5'd25;
            EX_MEM_RD = 5'd25;
            MEM_WB_RD = 5'd25;
            EX_MEM_RegWrite = 1'b1;
            MEM_WB_RegWrite = 1'b1;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Zero Register - No forwarding for Register 0", test_num);
            ID_EX_RS = 5'd0;
            EX_MEM_RD = 5'd0;
            MEM_WB_RD = 5'd0;
            EX_MEM_RegWrite = 1'b1;
            MEM_WB_RegWrite = 1'b1;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: RegWrite Disabled - No forwarding when write signals are low", test_num);
            ID_EX_RS = 5'd5;
            EX_MEM_RD = 5'd5;
            MEM_WB_RD = 5'd5;
            EX_MEM_RegWrite = 1'b0;
            MEM_WB_RegWrite = 1'b0;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: MEM Hazard with EX mismatch", test_num);
            ID_EX_RS = 5'd8;
            EX_MEM_RD = 5'd10;
            MEM_WB_RD = 5'd8;
            EX_MEM_RegWrite = 1'b1;
            MEM_WB_RegWrite = 1'b1;
            #1;

            check_outputs(2'b01);
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
        input [1:0] expected_Forward;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Forward === (expected_Forward ^ Forward ^ expected_Forward)) begin
                $display("PASS");
                $display("  Outputs: Forward=%h",
                         Forward);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Forward=%h",
                         expected_Forward);
                $display("  Got:      Forward=%h",
                         Forward);
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
