`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg A14;
    reg A15;
    reg IOM;
    reg PSEN;
    reg WR;
    wire LCD;
    wire RAM1;
    wire RAM2;
    wire ROM1;
    wire ROM2;
    wire RTC;
    wire SEVSEG;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A14(A14),
        .A15(A15),
        .IOM(IOM),
        .PSEN(PSEN),
        .WR(WR),
        .LCD(LCD),
        .RAM1(RAM1),
        .RAM2(RAM2),
        .ROM1(ROM1),
        .ROM2(ROM2),
        .RTC(RTC),
        .SEVSEG(SEVSEG)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: ROM1 Selection (PSEN=0, A15=0)", test_num);
        PSEN = 0; A15 = 0; IOM = 0; WR = 1; A14 = 0;

        #1;


        check_outputs(0, 0, 0, 1, 0, 0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: ROM2 Selection (PSEN=0, A15=1)", test_num);
        PSEN = 0; A15 = 1; IOM = 0; WR = 1; A14 = 0;

        #1;


        check_outputs(0, 0, 0, 0, 1, 0, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: RAM1 Selection (PSEN=1, IOM=0, A15=0)", test_num);
        PSEN = 1; A15 = 0; IOM = 0; WR = 0; A14 = 0;

        #1;


        check_outputs(0, 1, 0, 0, 0, 0, 0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: RAM2 Selection (PSEN=1, IOM=0, A15=1)", test_num);
        PSEN = 1; A15 = 1; IOM = 0; WR = 0; A14 = 0;

        #1;


        check_outputs(0, 0, 1, 0, 0, 0, 0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: RTC Selection (PSEN=1, IOM=1, WR=0, A15=0, A14=0)", test_num);
        PSEN = 1; A15 = 0; IOM = 1; WR = 0; A14 = 0;

        #1;


        check_outputs(0, 0, 0, 0, 0, 1, 0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: LCD Selection (PSEN=1, IOM=1, WR=0, A15=0, A14=1)", test_num);
        PSEN = 1; A15 = 0; IOM = 1; WR = 0; A14 = 1;

        #1;


        check_outputs(1, 0, 0, 0, 0, 0, 0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: SEVSEG Selection (PSEN=1, IOM=1, WR=0, A15=1)", test_num);
        PSEN = 1; A15 = 1; IOM = 1; WR = 0; A14 = 0;

        #1;


        check_outputs(0, 0, 0, 0, 0, 0, 1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Idle State (PSEN=1, IOM=1, WR=1)", test_num);
        PSEN = 1; A15 = 0; IOM = 1; WR = 1; A14 = 0;

        #1;


        check_outputs(0, 0, 0, 0, 0, 0, 0);
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
        input expected_LCD;
        input expected_RAM1;
        input expected_RAM2;
        input expected_ROM1;
        input expected_ROM2;
        input expected_RTC;
        input expected_SEVSEG;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_LCD === (expected_LCD ^ LCD ^ expected_LCD) &&
                expected_RAM1 === (expected_RAM1 ^ RAM1 ^ expected_RAM1) &&
                expected_RAM2 === (expected_RAM2 ^ RAM2 ^ expected_RAM2) &&
                expected_ROM1 === (expected_ROM1 ^ ROM1 ^ expected_ROM1) &&
                expected_ROM2 === (expected_ROM2 ^ ROM2 ^ expected_ROM2) &&
                expected_RTC === (expected_RTC ^ RTC ^ expected_RTC) &&
                expected_SEVSEG === (expected_SEVSEG ^ SEVSEG ^ expected_SEVSEG)) begin
                $display("PASS");
                $display("  Outputs: LCD=%b, RAM1=%b, RAM2=%b, ROM1=%b, ROM2=%b, RTC=%b, SEVSEG=%b",
                         LCD, RAM1, RAM2, ROM1, ROM2, RTC, SEVSEG);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: LCD=%b, RAM1=%b, RAM2=%b, ROM1=%b, ROM2=%b, RTC=%b, SEVSEG=%b",
                         expected_LCD, expected_RAM1, expected_RAM2, expected_ROM1, expected_ROM2, expected_RTC, expected_SEVSEG);
                $display("  Got:      LCD=%b, RAM1=%b, RAM2=%b, ROM1=%b, ROM2=%b, RTC=%b, SEVSEG=%b",
                         LCD, RAM1, RAM2, ROM1, ROM2, RTC, SEVSEG);
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
