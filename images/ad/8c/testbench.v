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
        #1;
        RST = 0;
        @(posedge CLK);
        #1;
    end
        endtask
    task testcase001;

    begin
        $display("Running testcase001: Normal Multiplication Sequence...");
        test_num = test_num + 1;
        reset_dut();


        STM = 1;
        @(posedge CLK);
        #1 STM = 0;

        @(posedge CLK);
        #1;

        @(posedge CLK);
        #1;



        #1;




        check_outputs(0, 0, 0, 1, 1, 1);
    end
        endtask

    task testcase002;

    begin
        $display("Running testcase002: Reset during operation (STATE1)...");
        test_num = test_num + 1;
        reset_dut();

        STM = 1;
        @(posedge CLK);
        #1 STM = 0;


        RST = 1;
        @(posedge CLK);
        #1 RST = 0;


        #1;



        check_outputs(0, 0, 0, 0, 0, 0);
    end
        endtask

    task testcase003;

    begin
        $display("Running testcase003: IDLE state stability...");
        test_num = test_num + 1;
        reset_dut();


        repeat(3) @(posedge CLK);
        #1;


        #1;



        check_outputs(0, 0, 0, 0, 0, 0);
    end
        endtask

    task testcase004;

    begin
        $display("Running testcase004: Intermediate State (STATE2) verification...");
        test_num = test_num + 1;
        reset_dut();

        STM = 1;
        @(posedge CLK);
        #1 STM = 0;

        @(posedge CLK);
        #1;


        #1;



        check_outputs(1, 0, 1, 0, 0, 0);
    end
        endtask

    task testcase005;

    begin
        $display("Running testcase005: Return to IDLE after STATE3...");
        test_num = test_num + 1;
        reset_dut();

        STM = 1;
        @(posedge CLK);
        #1 STM = 0;
        @(posedge CLK);
        @(posedge CLK);
        @(posedge CLK);
        #1;


        #1;



        check_outputs(0, 0, 0, 0, 0, 0);
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
