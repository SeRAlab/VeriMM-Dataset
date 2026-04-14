`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CK;
    reg D;
    reg RST;
    reg SET;
    wire Q;
    wire QN;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CK(CK),
        .D(D),
        .RST(RST),
        .SET(SET),
        .Q(Q),
        .QN(QN)
    );

    // Clock generation (10ns period)
    initial begin
        CK = 0;
        forever #5 CK = ~CK;
    end

        task reset_dut;

    begin
        RST = 1;
        SET = 0;
        D = 0;
        #12;
        RST = 0;
        #5;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        $display("Test %0d: Asynchronous Reset", test_num);
        D = 1;
        RST = 1;
        #2;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        $display("Test %0d: Asynchronous Set", test_num);
        D = 0;
        SET = 1;
        #2;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        $display("Test %0d: Synchronous Capture D=1", test_num);
        RST = 0;
        SET = 0;
        D = 1;
        @(posedge CK);
        #2;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        $display("Test %0d: Synchronous Capture D=0", test_num);

        SET = 1; #2; SET = 0;
        D = 0;
        @(posedge CK);
        #2;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        $display("Test %0d: Reset Priority (RST and SET high)", test_num);
        SET = 1;
        RST = 1;
        #2;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();
        $display("Test %0d: Async Set overrides rising clock edge", test_num);
        D = 0;
        SET = 1;
        @(posedge CK);
        #2;
        #1;

        check_outputs(1'b1, 1'b0);
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
        input expected_Q;
        input expected_QN;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_QN === (expected_QN ^ QN ^ expected_QN)) begin
                $display("PASS");
                $display("  Outputs: Q=%b, QN=%b",
                         Q, QN);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%b, QN=%b",
                         expected_Q, expected_QN);
                $display("  Got:      Q=%b, QN=%b",
                         Q, QN);
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
        $dumpvars(0,CK, D, RST, SET, Q, QN);
    end

endmodule
