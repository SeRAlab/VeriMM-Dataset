`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] MemMov;
    reg MovK;
    reg [63:0] RFRD2;
    reg [31:0] instruction;
    wire [63:0] WriteReg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .MemMov(MemMov),
        .MovK(MovK),
        .RFRD2(RFRD2),
        .instruction(instruction),
        .WriteReg(WriteReg)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: MovK=0 (MemMov mode)", test_num);

            MovK = 0;
            MemMov = 64'hFEDCBA9876543210;
            RFRD2 = 64'h0;
            instruction = 32'h0;

            #1;


            check_outputs(64'hFEDCBA9876543210);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: MovK=1 (MovK mode) - Replace with zeros", test_num);

            MovK = 1;
            RFRD2 = 64'hFFFF_FFFF_FFFF_FFFF;
            instruction = 32'h0000_0000;
            MemMov = 64'hAABBCCDD_AABBCCDD;

            #1;


            check_outputs(64'hFFFF_FFFF_FFFF_0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: MovK=1 (MovK mode) - Replace with ones", test_num);

            MovK = 1;
            RFRD2 = 64'h1234_5678_9ABC_0000;

            instruction = 32'h001F_FFE0;
            MemMov = 64'h0;

            #1;


            check_outputs(64'h1234_5678_9ABC_FFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: MovK=1 (MovK mode) - Pattern check", test_num);

            MovK = 1;
            RFRD2 = 64'hAAAA_BBBB_CCCC_DDDD;

            instruction = 32'h000A_AAA0;
            MemMov = 64'h1122334455667788;

            #1;


            check_outputs(64'hAAAA_BBBB_CCCC_5555);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: MovK=0 (MemMov mode) - All ones", test_num);

            MovK = 0;
            MemMov = 64'hFFFF_FFFF_FFFF_FFFF;
            RFRD2 = 64'h0;
            instruction = 32'hFFFF_FFFF;

            #1;


            check_outputs(64'hFFFF_FFFF_FFFF_FFFF);
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
        input [63:0] expected_WriteReg;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_WriteReg === (expected_WriteReg ^ WriteReg ^ expected_WriteReg)) begin
                $display("PASS");
                $display("  Outputs: WriteReg=%h",
                         WriteReg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: WriteReg=%h",
                         expected_WriteReg);
                $display("  Got:      WriteReg=%h",
                         WriteReg);
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
