`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg A0;
    reg A1;
    reg A2;
    reg A3;
    reg CE;
    reg CLK;
    reg D;
    wire Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A0(A0),
        .A1(A1),
        .A2(A2),
        .A3(A3),
        .CE(CE),
        .CLK(CLK),
        .D(D),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

    begin
        CE = 1;
        D = 0;
        {A3, A2, A1, A0} = 4'b0000;
        repeat(16) @(posedge CLK);
        CE = 0;
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        D = 1; CE = 1;
        @(posedge CLK);
        #1;
        CE = 0;
        {A3, A2, A1, A0} = 4'd0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        reset_dut();

        D = 1; CE = 1;
        @(posedge CLK);
        D = 0;
        repeat(15) @(posedge CLK);
        #1;
        CE = 0;
        {A3, A2, A1, A0} = 4'd15;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        D = 1; CE = 0;
        repeat(5) @(posedge CLK);
        #1;
        {A3, A2, A1, A0} = 4'd0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        reset_dut();

        CE = 1;
        D = 1; @(posedge CLK);
        D = 1; @(posedge CLK);
        D = 0; @(posedge CLK);
        D = 1; @(posedge CLK);
        #1;
        CE = 0;
        {A3, A2, A1, A0} = 4'd2;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        reset_dut();

        CE = 1;
        D = 1; @(posedge CLK);
        D = 1; @(posedge CLK);
        D = 0; @(posedge CLK);
        D = 1; @(posedge CLK);
        #1;
        CE = 0;
        {A3, A2, A1, A0} = 4'd3;
        #1;

        check_outputs(1'b1);
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
        input expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%b",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%b",
                         expected_Q);
                $display("  Got:      Q=%b",
                         Q);
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
        $dumpvars(0,A0, A1, A2, A3, CE, CLK, D, Q);
    end

endmodule
