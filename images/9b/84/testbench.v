`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg d;
    reg j;
    reg k;
    reg r;
    reg rst;
    reg s;
    reg t;
    wire q_d;
    wire q_jk;
    wire q_sr;
    wire q_t;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .j(j),
        .k(k),
        .r(r),
        .rst(rst),
        .s(s),
        .t(t),
        .q_d(q_d),
        .q_jk(q_jk),
        .q_sr(q_sr),
        .q_t(q_t)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        d = 0; j = 0; k = 0; t = 0; s = 0; r = 0;
        @(posedge clk);
        #1;
        rst = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Verifying Reset State", test_num);
        reset_dut();
        @(negedge clk);
        #1;

        check_outputs(0, 0, 0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Verifying Set/Load functionality", test_num);
        reset_dut();
        @(negedge clk);
        d = 1; j = 1; k = 0; t = 1; s = 1; r = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1, 1, 1, 1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Verifying Clear/Reset via inputs", test_num);
        reset_dut();

        @(negedge clk);
        d = 1; j = 1; k = 0; t = 1; s = 1; r = 0;
        @(posedge clk);
        #1;

        @(negedge clk);
        d = 0; j = 0; k = 1; t = 1; s = 0; r = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(0, 0, 0, 0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Verifying JK and T Toggle behavior", test_num);
        reset_dut();
        @(negedge clk);
        j = 1; k = 1; t = 1;
        @(posedge clk);
        @(negedge clk);

        @(posedge clk);
        #1;
        #1;

        check_outputs(0, 0, 0, 0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Verifying Hold functionality", test_num);
        reset_dut();

        @(negedge clk);
        d = 1; j = 1; k = 0; t = 1; s = 1; r = 0;
        @(posedge clk);
        #1;

        @(negedge clk);
        j = 0; k = 0; t = 0; s = 0; r = 0;
        @(posedge clk);
        #1;
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
        input expected_q_d;
        input expected_q_jk;
        input expected_q_sr;
        input expected_q_t;
        begin
            if (expected_q_d === (expected_q_d ^ q_d ^ expected_q_d) &&
                expected_q_jk === (expected_q_jk ^ q_jk ^ expected_q_jk) &&
                expected_q_sr === (expected_q_sr ^ q_sr ^ expected_q_sr) &&
                expected_q_t === (expected_q_t ^ q_t ^ expected_q_t)) begin
                $display("PASS");
                $display("  Outputs: q_d=%b, q_jk=%b, q_sr=%b, q_t=%b",
                         q_d, q_jk, q_sr, q_t);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q_d=%b, q_jk=%b, q_sr=%b, q_t=%b",
                         expected_q_d, expected_q_jk, expected_q_sr, expected_q_t);
                $display("  Got:      q_d=%b, q_jk=%b, q_sr=%b, q_t=%b",
                         q_d, q_jk, q_sr, q_t);
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
        $dumpvars(0,clk, d, j, k, r, rst, s, t, q_d, q_jk, q_sr, q_t);
    end

endmodule
