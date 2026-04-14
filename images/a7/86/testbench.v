`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg J;
    reg K;
    reg clk;
    reg d;
    reg r;
    reg s;
    reg t;
    wire q_D;
    wire q_JK;
    wire q_SR;
    wire q_T;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .J(J),
        .K(K),
        .clk(clk),
        .d(d),
        .r(r),
        .s(s),
        .t(t),
        .q_D(q_D),
        .q_JK(q_JK),
        .q_SR(q_SR),
        .q_T(q_T)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        d = 0;
        J = 0;
        K = 1;
        t = 0;
        s = 0;
        r = 1;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Testcase %03d: Checking initial state (D=0, SR=0)", test_num);

        #1;


        check_outputs(0, 0, 0, 0);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        d = 1;
        @(posedge clk);
        #1;
        $display("Testcase %03d: D Latch Set High", test_num);
        #1;

        check_outputs(1, 0, 0, 0);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        d = 1; @(posedge clk); #1;
        d = 0; @(posedge clk); #1;
        test_num = 3;
        $display("Testcase %03d: D Latch Set Low", test_num);
        #1;

        check_outputs(0, 0, 0, 0);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        J = 1; K = 0;
        @(posedge clk);
        #1;
        $display("Testcase %03d: JK Latch Toggle 0->1", test_num);
        #1;

        check_outputs(0, 1, 0, 0);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        J = 1; K = 0; @(posedge clk); #1;
        J = 1; K = 0; @(posedge clk); #1;
        test_num = 5;
        $display("Testcase %03d: JK Latch Toggle 1->0", test_num);
        #1;

        check_outputs(0, 0, 0, 0);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        J = 1; K = 0; @(posedge clk); #1;
        J = 0; K = 1; @(posedge clk); #1;
        test_num = 6;
        $display("Testcase %03d: JK Latch Hold state at 1", test_num);
        #1;

        check_outputs(0, 1, 0, 0);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        test_num = 7;
        t = 1;
        @(posedge clk);
        #1;
        $display("Testcase %03d: T Latch Toggle 0->1", test_num);
        #1;

        check_outputs(0, 0, 0, 1);
    end
        endtask

    task testcase008;

    begin
        reset_dut();
        t = 1; @(posedge clk); #1;
        t = 1; @(posedge clk); #1;
        test_num = 8;
        $display("Testcase %03d: T Latch Toggle 1->0", test_num);
        #1;

        check_outputs(0, 0, 0, 0);
    end
        endtask

    task testcase009;

    begin
        reset_dut();
        test_num = 9;
        s = 1; r = 0;
        @(posedge clk);
        #1;
        $display("Testcase %03d: SR Latch Set", test_num);
        #1;

        check_outputs(0, 0, 1, 0);
    end
        endtask

    task testcase010;

    begin
        reset_dut();
        s = 1; r = 0; @(posedge clk); #1;
        s = 0; r = 1; @(posedge clk); #1;
        test_num = 10;
        $display("Testcase %03d: SR Latch Reset", test_num);
        #1;

        check_outputs(0, 0, 0, 0);
    end
        endtask

    task testcase011;

    begin
        reset_dut();
        test_num = 11;
        d = 1;
        J = 1; K = 0;
        t = 1;
        s = 1; r = 0;
        @(posedge clk);
        #1;
        $display("Testcase %03d: All latches activated simultaneously", test_num);
        #1;

        check_outputs(1, 1, 1, 1);
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
        testcase009();
        testcase010();
        testcase011();
        
        
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
        input expected_q_D;
        input expected_q_JK;
        input expected_q_SR;
        input expected_q_T;
        begin
            if (expected_q_D === (expected_q_D ^ q_D ^ expected_q_D) &&
                expected_q_JK === (expected_q_JK ^ q_JK ^ expected_q_JK) &&
                expected_q_SR === (expected_q_SR ^ q_SR ^ expected_q_SR) &&
                expected_q_T === (expected_q_T ^ q_T ^ expected_q_T)) begin
                $display("PASS");
                $display("  Outputs: q_D=%b, q_JK=%b, q_SR=%b, q_T=%b",
                         q_D, q_JK, q_SR, q_T);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q_D=%b, q_JK=%b, q_SR=%b, q_T=%b",
                         expected_q_D, expected_q_JK, expected_q_SR, expected_q_T);
                $display("  Got:      q_D=%b, q_JK=%b, q_SR=%b, q_T=%b",
                         q_D, q_JK, q_SR, q_T);
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
        $dumpvars(0,J, K, clk, d, r, s, t, q_D, q_JK, q_SR, q_T);
    end

endmodule
