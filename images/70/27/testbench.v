`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data;
    reg en;
    reg j;
    reg k;
    reg r;
    reg rst;
    reg s;
    reg t_in;
    wire d_out;
    wire jk_out;
    wire sr_out;
    wire t_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .en(en),
        .j(j),
        .k(k),
        .r(r),
        .rst(rst),
        .s(s),
        .t_in(t_in),
        .d_out(d_out),
        .jk_out(jk_out),
        .sr_out(sr_out),
        .t_out(t_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            en = 0;
            data = 0;
            j = 0;
            k = 0;
            t_in = 0;
            s = 0;
            r = 0;
            @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Initial Reset State", test_num);
            reset_dut();
            @(posedge clk);
            #1;

            #1;


            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: D Latch Sample High", test_num);
            reset_dut();
            @(negedge clk);
            en = 1;
            data = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1, 0, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: JK Latch Set (J=1, K=0)", test_num);
            reset_dut();
            @(negedge clk);
            en = 1;
            j = 1;
            k = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 1, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: JK Latch Toggle (J=1, K=1)", test_num);
            reset_dut();

            @(negedge clk);
            en = 1;
            j = 1;
            k = 1;
            @(posedge clk);
            #1;

            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: T Latch Toggle (T=1)", test_num);
            reset_dut();
            @(negedge clk);
            en = 1;
            t_in = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0, 0, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: SR Latch Set and Hold", test_num);
            reset_dut();
            @(negedge clk);
            en = 1;
            s = 1;
            r = 0;
            @(posedge clk);
            #1;
            s = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0, 1, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: SR Latch Reset", test_num);
            reset_dut();
            @(negedge clk);
            en = 1;
            s = 1; r = 0;
            @(posedge clk);
            #1;
            s = 0; r = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %03d: Enable Signal Check (en=0)", test_num);
            reset_dut();
            @(negedge clk);
            en = 1;
            data = 1; j = 1; t_in = 1; s = 1;
            @(posedge clk);
            #1;
            en = 0;
            data = 0; j = 0; k = 1; t_in = 1; s = 0; r = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1, 1, 1, 1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %03d: Simultaneous Multi-latch Operation", test_num);
            reset_dut();
            @(negedge clk);
            en = 1;
            data = 1;
            j = 0; k = 1;
            t_in = 1;
            s = 1; r = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1, 0, 1, 1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %03d: Sequential Toggles", test_num);
            reset_dut();
            @(negedge clk);
            en = 1;
            j = 1; k = 1; t_in = 1;
            @(posedge clk);
            #1;
            @(posedge clk);
            #1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 1, 0, 1);
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
        input expected_d_out;
        input expected_jk_out;
        input expected_sr_out;
        input expected_t_out;
        begin
            if (expected_d_out === (expected_d_out ^ d_out ^ expected_d_out) &&
                expected_jk_out === (expected_jk_out ^ jk_out ^ expected_jk_out) &&
                expected_sr_out === (expected_sr_out ^ sr_out ^ expected_sr_out) &&
                expected_t_out === (expected_t_out ^ t_out ^ expected_t_out)) begin
                $display("PASS");
                $display("  Outputs: d_out=%b, jk_out=%b, sr_out=%b, t_out=%b",
                         d_out, jk_out, sr_out, t_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: d_out=%b, jk_out=%b, sr_out=%b, t_out=%b",
                         expected_d_out, expected_jk_out, expected_sr_out, expected_t_out);
                $display("  Got:      d_out=%b, jk_out=%b, sr_out=%b, t_out=%b",
                         d_out, jk_out, sr_out, t_out);
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
        $dumpvars(0,clk, data, en, j, k, r, rst, s, t_in, d_out, jk_out, sr_out, t_out);
    end

endmodule
