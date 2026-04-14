`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg RST;
    reg STM;
    wire [3:0] ENa;
    wire ENp;
    wire ENq;
    wire [3:0] ENr;
    wire EOM;

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
        .ENp(ENp),
        .ENq(ENq),
        .ENr(ENr),
        .EOM(EOM)
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
            test_num = test_num + 1;
            $display("\nTest Case %03d: Initial State after Reset", test_num);
            reset_dut();

            #1;


            check_outputs(4'b0000, 1'b0, 1'b0, 4'b0000, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: Full Transition to Final State", test_num);
            reset_dut();

            STM = 1;
            @(posedge CLK);
            #1;
            STM = 0;



            repeat(4) @(posedge CLK);
            #1;




            if (EOM === 1'b1)
                #1;

                check_outputs(ENa, ENp, ENq, ENr, 1'b1);
            else
                #1;

                check_outputs(ENa, ENp, ENq, ENr, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: Stay in Idle without STM", test_num);
            reset_dut();

            STM = 0;
            repeat(5) @(posedge CLK);
            #1;


            #1;



            check_outputs(4'b0000, 1'b0, 1'b0, 4'b0000, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: Mid-sequence Reset", test_num);
            reset_dut();

            STM = 1;
            @(posedge CLK);
            #1;
            STM = 0;


            repeat(2) @(posedge CLK);
            #1;


            RST = 1;
            @(posedge CLK);
            #1;
            RST = 0;
            @(posedge CLK);
            #1;


            #1;



            check_outputs(4'b0000, 1'b0, 1'b0, 4'b0000, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: STM Continuous High", test_num);
            reset_dut();

            STM = 1;

            repeat(4) @(posedge CLK);
            #1;


            if (EOM === 1'b1)
                #1;

                check_outputs(ENa, ENp, ENq, ENr, 1'b1);
            else
                #1;

                check_outputs(ENa, ENp, ENq, ENr, 1'b1);
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
        input [3:0] expected_ENa;
        input expected_ENp;
        input expected_ENq;
        input [3:0] expected_ENr;
        input expected_EOM;
        begin
            if (expected_ENa === (expected_ENa ^ ENa ^ expected_ENa) &&
                expected_ENp === (expected_ENp ^ ENp ^ expected_ENp) &&
                expected_ENq === (expected_ENq ^ ENq ^ expected_ENq) &&
                expected_ENr === (expected_ENr ^ ENr ^ expected_ENr) &&
                expected_EOM === (expected_EOM ^ EOM ^ expected_EOM)) begin
                $display("PASS");
                $display("  Outputs: ENa=%h, ENp=%b, ENq=%b, ENr=%h, EOM=%b",
                         ENa, ENp, ENq, ENr, EOM);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ENa=%h, ENp=%b, ENq=%b, ENr=%h, EOM=%b",
                         expected_ENa, expected_ENp, expected_ENq, expected_ENr, expected_EOM);
                $display("  Got:      ENa=%h, ENp=%b, ENq=%b, ENr=%h, EOM=%b",
                         ENa, ENp, ENq, ENr, EOM);
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
        $dumpvars(0,CLK, RST, STM, ENa, ENp, ENq, ENr, EOM);
    end

endmodule
