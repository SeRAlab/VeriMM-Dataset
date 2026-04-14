`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg seq_clr;
    reg seq_cnt_en;
    reg slowest_sync_clk;
    wire [5:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .seq_clr(seq_clr),
        .seq_cnt_en(seq_cnt_en),
        .slowest_sync_clk(slowest_sync_clk),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        seq_clr = 0;
        forever #5 seq_clr = ~seq_clr;
    end

        task reset_dut;

        begin
            seq_clr = 1;
            seq_cnt_en = 0;
            #12;
            seq_clr = 0;
            #5;
        end
        endtask
    task wait_clks;

        input integer n;
        integer i;
        begin
            for (i = 0; i < n; i = i + 1) begin
                @(posedge slowest_sync_clk);
            end
            #1;
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Counting", test_num);
            reset_dut();
            seq_cnt_en = 1;
            wait_clks(10);
            #1;

            check_outputs(6'd10);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Count Enable Toggle", test_num);
            reset_dut();
            seq_cnt_en = 1;
            wait_clks(5);
            seq_cnt_en = 0;
            wait_clks(5);
            #1;

            check_outputs(6'd5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Counter Overflow (Wrap-around)", test_num);
            reset_dut();
            seq_cnt_en = 1;
            wait_clks(64);
            wait_clks(3);
            #1;

            check_outputs(6'd3);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Asynchronous Clear Mid-Count", test_num);
            reset_dut();
            seq_cnt_en = 1;
            wait_clks(20);

            #3 seq_clr = 1;
            #2;
            #1;

            check_outputs(6'd0);
            seq_clr = 0;
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Count Disabled from Reset", test_num);
            reset_dut();
            seq_cnt_en = 0;
            wait_clks(10);
            #1;

            check_outputs(6'd0);
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
        input [5:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
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
        $dumpvars(0,seq_clr, seq_cnt_en, slowest_sync_clk, Q);
    end

endmodule
