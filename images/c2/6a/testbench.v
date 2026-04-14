`timescale 1ns/1ps

module dffsr_async_clear_set_reset_tb;

    // Testbench signals (sequential circuit)
    reg clear;
    reg clk;
    reg d;
    reg reset;
    reg set;
    wire q;
    wire q_bar;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dffsr_async_clear_set_reset dut (
        .clear(clear),
        .clk(clk),
        .d(d),
        .reset(reset),
        .set(set),
        .q(q),
        .q_bar(q_bar)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin

        clear = 1;
        set = 0;
        reset = 0;
        d = 0;
        #10;
        clear = 0;
        #5;
    end
        endtask
    task testcase001;

    begin
        $display("Test Case 001: Asynchronous Clear");
        reset_dut();
        test_num = 1;

        d = 1;
        clear = 1;
        #2;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        $display("Test Case 002: Asynchronous Set");
        reset_dut();
        test_num = 2;

        set = 1;
        clear = 0;
        #2;
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase003;

    begin
        $display("Test Case 003: Asynchronous Reset");
        reset_dut();
        test_num = 3;

        reset = 1;
        set = 0;
        clear = 0;
        #2;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        $display("Test Case 004: Clocked operation D=1");
        reset_dut();
        test_num = 4;
        clear = 0;
        set = 0;
        reset = 0;
        d = 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase005;

    begin
        $display("Test Case 005: Clocked operation D=0");
        reset_dut();
        test_num = 5;

        d = 1;
        @(posedge clk);
        #2;

        d = 0;
        @(posedge clk);
        #2;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase006;

    begin
        $display("Test Case 006: Priority - Clear over Set");
        reset_dut();
        test_num = 6;
        clear = 1;
        set = 1;
        reset = 0;
        #2;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase007;

    begin
        $display("Test Case 007: Priority - Set over Reset");
        reset_dut();
        test_num = 7;
        clear = 0;
        set = 1;
        reset = 1;
        #2;
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase008;

    begin
        $display("Test Case 008: Clear overriding Clock edge");
        reset_dut();
        test_num = 8;
        d = 1;
        clear = 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase009;

    begin
        $display("Test Case 009: Data Persistence without clock");
        reset_dut();
        test_num = 9;
        d = 1;
        @(posedge clk);
        #2;
        d = 0;
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
        $display("dffsr_async_clear_set_reset Testbench");
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
        input expected_q;
        input expected_q_bar;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q) &&
                expected_q_bar === (expected_q_bar ^ q_bar ^ expected_q_bar)) begin
                $display("PASS");
                $display("  Outputs: q=%b, q_bar=%b",
                         q, q_bar);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%b, q_bar=%b",
                         expected_q, expected_q_bar);
                $display("  Got:      q=%b, q_bar=%b",
                         q, q_bar);
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
        $dumpvars(0,clear, clk, d, reset, set, q, q_bar);
    end

endmodule
