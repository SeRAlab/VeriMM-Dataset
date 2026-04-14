`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] config_data;
    reg fsm_clear_timer;
    reg fsm_start_timer;
    reg fsm_stop_timer;
    reg reset;
    reg update_timers;
    reg wraddr;
    reg wrenb;
    wire timer_elapsed;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .config_data(config_data),
        .fsm_clear_timer(fsm_clear_timer),
        .fsm_start_timer(fsm_start_timer),
        .fsm_stop_timer(fsm_stop_timer),
        .reset(reset),
        .update_timers(update_timers),
        .wraddr(wraddr),
        .wrenb(wrenb),
        .timer_elapsed(timer_elapsed)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        config_data = 0;
        fsm_clear_timer = 0;
        fsm_start_timer = 0;
        fsm_stop_timer = 0;
        update_timers = 0;
        wraddr = 0;
        wrenb = 0;
        repeat(2) @(posedge clk);
        reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Basic Count to Limit", test_num);
        reset_dut();


        wrenb = 1;
        wraddr = 0;
        config_data = 32'd10;
        @(posedge clk);
        wrenb = 0;
        update_timers = 1;
        @(posedge clk);
        update_timers = 0;


        fsm_start_timer = 1;
        @(posedge clk);
        fsm_start_timer = 0;


        repeat(10) @(posedge clk);

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Stop Timer Mid-way", test_num);
        reset_dut();


        wrenb = 1;
        wraddr = 0;
        config_data = 32'd20;
        @(posedge clk);
        wrenb = 0;
        update_timers = 1;
        @(posedge clk);
        update_timers = 0;


        fsm_start_timer = 1;
        @(posedge clk);
        fsm_start_timer = 0;


        repeat(10) @(posedge clk);


        fsm_stop_timer = 1;
        @(posedge clk);
        fsm_stop_timer = 0;


        repeat(15) @(posedge clk);

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Stop and Resume Timer", test_num);
        reset_dut();


        wrenb = 1;
        wraddr = 0;
        config_data = 32'd10;
        @(posedge clk);
        wrenb = 0;
        update_timers = 1;
        @(posedge clk);
        update_timers = 0;


        fsm_start_timer = 1;
        @(posedge clk);
        fsm_start_timer = 0;

        repeat(5) @(posedge clk);


        fsm_stop_timer = 1;
        @(posedge clk);
        fsm_stop_timer = 0;
        repeat(5) @(posedge clk);


        fsm_start_timer = 1;
        @(posedge clk);
        fsm_start_timer = 0;
        repeat(5) @(posedge clk);

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Clear Timer Mid-way", test_num);
        reset_dut();


        wrenb = 1;
        wraddr = 0;
        config_data = 32'd10;
        @(posedge clk);
        wrenb = 0;
        update_timers = 1;
        @(posedge clk);
        update_timers = 0;


        fsm_start_timer = 1;
        @(posedge clk);
        fsm_start_timer = 0;

        repeat(8) @(posedge clk);


        fsm_clear_timer = 1;
        @(posedge clk);
        fsm_clear_timer = 0;


        repeat(5) @(posedge clk);

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Dynamic Limit Adjustment", test_num);
        reset_dut();


        wrenb = 1;
        wraddr = 0;
        config_data = 32'd50;
        @(posedge clk);
        wrenb = 0;
        update_timers = 1;
        @(posedge clk);
        update_timers = 0;


        fsm_start_timer = 1;
        @(posedge clk);
        fsm_start_timer = 0;
        repeat(10) @(posedge clk);


        if(timer_elapsed !== 0) $display("Error: Timer elapsed too early");


        wrenb = 1;
        wraddr = 0;
        config_data = 32'd10;
        @(posedge clk);
        wrenb = 0;
        update_timers = 1;
        @(posedge clk);
        update_timers = 0;


        @(posedge clk);

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
        input expected_timer_elapsed;
        begin
            if (expected_timer_elapsed === (expected_timer_elapsed ^ timer_elapsed ^ expected_timer_elapsed)) begin
                $display("PASS");
                $display("  Outputs: timer_elapsed=%b",
                         timer_elapsed);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: timer_elapsed=%b",
                         expected_timer_elapsed);
                $display("  Got:      timer_elapsed=%b",
                         timer_elapsed);
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
        $dumpvars(0,clk, config_data, fsm_clear_timer, fsm_start_timer, fsm_stop_timer, reset, update_timers, wraddr, wrenb, timer_elapsed);
    end

endmodule
