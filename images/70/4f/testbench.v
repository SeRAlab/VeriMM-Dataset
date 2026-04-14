`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg sb_ireq1;
    reg sb_ireq2;
    reg sb_ireq3;
    reg sb_ireq4;
    wire [11:0] sav_ac;
    wire [11:0] sav_io;
    wire [11:0] sav_jmp;
    wire [11:0] sav_pc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .sb_ireq1(sb_ireq1),
        .sb_ireq2(sb_ireq2),
        .sb_ireq3(sb_ireq3),
        .sb_ireq4(sb_ireq4),
        .sav_ac(sav_ac),
        .sav_io(sav_io),
        .sav_jmp(sav_jmp),
        .sav_pc(sav_pc)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: All requests inactive (Idle)");
            sb_ireq1 = 0; sb_ireq2 = 0; sb_ireq3 = 0; sb_ireq4 = 0;

            #1;


            check_outputs(12'h000, 12'h000, 12'h000, 12'h000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Only sb_ireq1 active");
            sb_ireq1 = 1; sb_ireq2 = 0; sb_ireq3 = 0; sb_ireq4 = 0;

            #1;


            check_outputs(12'h010, 12'h011, 12'h012, 12'h013);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Only sb_ireq2 active");
            sb_ireq1 = 0; sb_ireq2 = 1; sb_ireq3 = 0; sb_ireq4 = 0;

            #1;


            check_outputs(12'h020, 12'h021, 12'h022, 12'h023);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Only sb_ireq3 active");
            sb_ireq1 = 0; sb_ireq2 = 0; sb_ireq3 = 1; sb_ireq4 = 0;

            #1;


            check_outputs(12'h030, 12'h031, 12'h032, 12'h033);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Only sb_ireq4 active");
            sb_ireq1 = 0; sb_ireq2 = 0; sb_ireq3 = 0; sb_ireq4 = 1;

            #1;


            check_outputs(12'h040, 12'h041, 12'h042, 12'h043);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: sb_ireq1 and sb_ireq2 active (Priority Check)");
            sb_ireq1 = 1; sb_ireq2 = 1; sb_ireq3 = 0; sb_ireq4 = 0;

            #1;


            check_outputs(12'h010, 12'h011, 12'h012, 12'h013);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case 007: sb_ireq3 and sb_ireq4 active (Priority Check)");
            sb_ireq1 = 0; sb_ireq2 = 0; sb_ireq3 = 1; sb_ireq4 = 1;

            #1;


            check_outputs(12'h030, 12'h031, 12'h032, 12'h033);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case 008: All requests active");
            sb_ireq1 = 1; sb_ireq2 = 1; sb_ireq3 = 1; sb_ireq4 = 1;

            #1;


            check_outputs(12'h010, 12'h011, 12'h012, 12'h013);
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
        input [11:0] expected_sav_ac;
        input [11:0] expected_sav_io;
        input [11:0] expected_sav_jmp;
        input [11:0] expected_sav_pc;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_sav_ac === (expected_sav_ac ^ sav_ac ^ expected_sav_ac) &&
                expected_sav_io === (expected_sav_io ^ sav_io ^ expected_sav_io) &&
                expected_sav_jmp === (expected_sav_jmp ^ sav_jmp ^ expected_sav_jmp) &&
                expected_sav_pc === (expected_sav_pc ^ sav_pc ^ expected_sav_pc)) begin
                $display("PASS");
                $display("  Outputs: sav_ac=%h, sav_io=%h, sav_jmp=%h, sav_pc=%h",
                         sav_ac, sav_io, sav_jmp, sav_pc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sav_ac=%h, sav_io=%h, sav_jmp=%h, sav_pc=%h",
                         expected_sav_ac, expected_sav_io, expected_sav_jmp, expected_sav_pc);
                $display("  Got:      sav_ac=%h, sav_io=%h, sav_jmp=%h, sav_pc=%h",
                         sav_ac, sav_io, sav_jmp, sav_pc);
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
