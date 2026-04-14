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
        slowest_sync_clk = 0;
        forever #5 slowest_sync_clk = ~slowest_sync_clk;
    end

        task reset_dut;

    begin
        seq_clr = 1;
        seq_cnt_en = 0;
        @(posedge slowest_sync_clk);
        #1;
        seq_clr = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Basic Reset", test_num);
        reset_dut();
        #1;

        check_outputs(6'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Simple Increment to 10", test_num);
        reset_dut();
        seq_cnt_en = 1;
        repeat(10) @(posedge slowest_sync_clk);
        #1;
        seq_cnt_en = 0;
        #1;

        check_outputs(6'd10);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Enable/Disable check", test_num);
        reset_dut();
        seq_cnt_en = 1;
        repeat(5) @(posedge slowest_sync_clk);
        seq_cnt_en = 0;
        repeat(5) @(posedge slowest_sync_clk);
        seq_cnt_en = 1;
        repeat(2) @(posedge slowest_sync_clk);
        #1;
        seq_cnt_en = 0;

        #1;


        check_outputs(6'd7);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Counter Rollover (63 to 0)", test_num);
        reset_dut();
        seq_cnt_en = 1;
        repeat(64) @(posedge slowest_sync_clk);
        #1;
        seq_cnt_en = 0;

        #1;


        check_outputs(6'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Synchronous Clear while counting", test_num);
        reset_dut();
        seq_cnt_en = 1;
        repeat(15) @(posedge slowest_sync_clk);
        seq_clr = 1;
        @(posedge slowest_sync_clk);
        #1;
        seq_clr = 0;
        seq_cnt_en = 0;
        #1;

        check_outputs(6'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Reaching Max Value (63)", test_num);
        reset_dut();
        seq_cnt_en = 1;
        repeat(63) @(posedge slowest_sync_clk);
        #1;
        seq_cnt_en = 0;
        #1;

        check_outputs(6'd63);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Enable and Clear Priority check", test_num);
        reset_dut();
        seq_cnt_en = 1;
        repeat(5) @(posedge slowest_sync_clk);

        seq_clr = 1;
        seq_cnt_en = 1;
        @(posedge slowest_sync_clk);
        #1;
        seq_clr = 0;
        seq_cnt_en = 0;

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
        testcase006();
        testcase007();
        
        
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
