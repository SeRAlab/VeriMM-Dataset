`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [31:0] timer_count;
    reg timer_enable;
    reg timer_interrupt_clear;
    wire timer_count_done;
    wire timer_interrupt;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .timer_count(timer_count),
        .timer_enable(timer_enable),
        .timer_interrupt_clear(timer_interrupt_clear),
        .timer_count_done(timer_count_done),
        .timer_interrupt(timer_interrupt)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        timer_count = 32'd0;
        timer_enable = 1'b0;
        timer_interrupt_clear = 1'b0;
        @(posedge clk);
        #1;
        reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Running Testcase %0d: Basic count to 10", test_num);
        reset_dut();
        timer_count = 32'd10;
        timer_enable = 1'b1;

        repeat(10) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Running Testcase %0d: Timer disabled", test_num);
        reset_dut();
        timer_count = 32'd10;
        timer_enable = 1'b0;

        repeat(15) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Running Testcase %0d: Reset mid-count", test_num);
        reset_dut();
        timer_count = 32'd20;
        timer_enable = 1'b1;

        repeat(10) @(posedge clk);
        reset = 1'b1;
        @(posedge clk);
        #1;
        reset = 1'b0;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Running Testcase %0d: Independent Interrupt Clear", test_num);
        reset_dut();
        timer_count = 32'd5;
        timer_enable = 1'b1;

        repeat(5) @(posedge clk);
        #1;

        if (timer_interrupt === 1'b1) begin
            timer_interrupt_clear = 1'b1;
            @(posedge clk);
            #1;
            timer_interrupt_clear = 1'b0;


            #1;



            check_outputs(timer_count_done, 1'b0);
        end else begin
            $display("FAIL: Timer failed to trigger before clear test");
            fail_count = fail_count + 1;
        end
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Running Testcase %0d: Minimum count (1)", test_num);
        reset_dut();
        timer_count = 32'd1;
        timer_enable = 1'b1;

        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Running Testcase %0d: Enable Toggling", test_num);
        reset_dut();
        timer_count = 32'd10;

        timer_enable = 1'b1;
        repeat(5) @(posedge clk);

        timer_enable = 1'b0;
        repeat(10) @(posedge clk);

        timer_enable = 1'b1;
        repeat(5) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 1'b1);
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
        input expected_timer_count_done;
        input expected_timer_interrupt;
        begin
            if (expected_timer_count_done === (expected_timer_count_done ^ timer_count_done ^ expected_timer_count_done) &&
                expected_timer_interrupt === (expected_timer_interrupt ^ timer_interrupt ^ expected_timer_interrupt)) begin
                $display("PASS");
                $display("  Outputs: timer_count_done=%b, timer_interrupt=%b",
                         timer_count_done, timer_interrupt);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: timer_count_done=%b, timer_interrupt=%b",
                         expected_timer_count_done, expected_timer_interrupt);
                $display("  Got:      timer_count_done=%b, timer_interrupt=%b",
                         timer_count_done, timer_interrupt);
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
        $dumpvars(0,clk, reset, timer_count, timer_enable, timer_interrupt_clear, timer_count_done, timer_interrupt);
    end

endmodule
