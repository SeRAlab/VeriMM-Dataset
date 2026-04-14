`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg any_pop;
    reg any_push;
    reg clk;
    reg reset;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .any_pop(any_pop),
        .any_push(any_push),
        .clk(clk),
        .reset(reset)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            any_push = 0;
            any_pop = 0;
            @(posedge clk);
            #1;
            reset = 0;

            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Reset State");
            reset_dut();
            exp_wptr = 2'b00;
            exp_rptr = 2'b00;
            #1;

            check_outputs();
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Single Push");
            reset_dut();
            any_push = 1;
            @(posedge clk);
            #1;
            any_push = 0;
            exp_wptr = 2'b01;
            exp_rptr = 2'b00;
            #1;

            check_outputs();
        end
        endtask

    task testcase003;

        integer i;
        begin
            $display("Running testcase003: Fill and Wrap-around");
            reset_dut();
            for (i = 0; i < 4; i = i + 1) begin
                any_push = 1;
                @(posedge clk);
                #1;
            end
            any_push = 0;

            exp_wptr = 2'b00;
            exp_rptr = 2'b00;
            #1;

            check_outputs();
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Push 2, Pop 1");
            reset_dut();

            any_push = 1;
            repeat(2) @(posedge clk);
            #1;
            any_push = 0;

            any_pop = 1;
            @(posedge clk);
            #1;
            any_pop = 0;
            exp_wptr = 2'b10;
            exp_rptr = 2'b01;
            #1;

            check_outputs();
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Simultaneous Push and Pop");
            reset_dut();
            any_push = 1;
            any_pop = 1;
            @(posedge clk);
            #1;
            any_push = 0;
            any_pop = 0;
            exp_wptr = 2'b01;
            exp_rptr = 2'b01;
            #1;

            check_outputs();
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
        begin
            if () begin
                $display("PASS");
                $display("  Outputs: ",
                         );
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ",
                         );
                $display("  Got:      ",
                         );
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
        $dumpvars(0,any_pop, any_push, clk, reset);
    end

endmodule
