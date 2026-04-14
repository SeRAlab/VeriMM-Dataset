`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg RST;
    reg STM;
    wire ENa;
    wire ENpH;
    wire ENpL;
    wire ENr;
    wire EOM;
    wire SEL;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .RST(RST),
        .STM(STM),
        .ENa(ENa),
        .ENpH(ENpH),
        .ENpL(ENpL),
        .ENr(ENr),
        .EOM(EOM),
        .SEL(SEL)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST = 1;
            STM = 0;
            @(posedge CLK);
            #2 RST = 0;
            @(posedge CLK);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %03d: Checking Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %03d: Checking Phase High (ENpH) State", test_num);
            reset_dut();
            STM = 1;
            @(posedge CLK);
            #1 STM = 0;

            #1;


            check_outputs(0, 1, 0, 0, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %03d: Checking Phase Low (ENpL) State", test_num);
            reset_dut();
            STM = 1;
            @(posedge CLK);
            #1 STM = 0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(0, 0, 1, 0, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %03d: Checking Action (ENa) State", test_num);
            reset_dut();
            STM = 1;
            @(posedge CLK);
            #1 STM = 0;
            repeat(2) @(posedge CLK);
            #1;
            #1;

            check_outputs(1, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %03d: Checking Read (ENr) State", test_num);
            reset_dut();
            STM = 1;
            @(posedge CLK);
            #1 STM = 0;
            repeat(3) @(posedge CLK);
            #1;
            #1;

            check_outputs(0, 0, 0, 1, 0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %03d: Checking Completion (EOM/SEL) State", test_num);
            reset_dut();
            STM = 1;
            @(posedge CLK);
            #1 STM = 0;
            repeat(4) @(posedge CLK);
            #1;
            #1;

            check_outputs(0, 0, 0, 0, 1, 1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %03d: Checking Return to IDLE", test_num);
            reset_dut();
            STM = 1;
            @(posedge CLK);
            #1 STM = 0;
            repeat(5) @(posedge CLK);
            #1;
            #1;

            check_outputs(0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("\nTestcase %03d: Checking Restart with STM held high", test_num);
            reset_dut();
            STM = 1;
            repeat(6) @(posedge CLK);
            #1;

            #1;


            check_outputs(0, 1, 0, 0, 0, 0);
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
        input expected_ENa;
        input expected_ENpH;
        input expected_ENpL;
        input expected_ENr;
        input expected_EOM;
        input expected_SEL;
        begin
            if (expected_ENa === (expected_ENa ^ ENa ^ expected_ENa) &&
                expected_ENpH === (expected_ENpH ^ ENpH ^ expected_ENpH) &&
                expected_ENpL === (expected_ENpL ^ ENpL ^ expected_ENpL) &&
                expected_ENr === (expected_ENr ^ ENr ^ expected_ENr) &&
                expected_EOM === (expected_EOM ^ EOM ^ expected_EOM) &&
                expected_SEL === (expected_SEL ^ SEL ^ expected_SEL)) begin
                $display("PASS");
                $display("  Outputs: ENa=%b, ENpH=%b, ENpL=%b, ENr=%b, EOM=%b, SEL=%b",
                         ENa, ENpH, ENpL, ENr, EOM, SEL);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ENa=%b, ENpH=%b, ENpL=%b, ENr=%b, EOM=%b, SEL=%b",
                         expected_ENa, expected_ENpH, expected_ENpL, expected_ENr, expected_EOM, expected_SEL);
                $display("  Got:      ENa=%b, ENpH=%b, ENpL=%b, ENr=%b, EOM=%b, SEL=%b",
                         ENa, ENpH, ENpL, ENr, EOM, SEL);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,CLK, RST, STM, ENa, ENpH, ENpL, ENr, EOM, SEL);
    end

endmodule
