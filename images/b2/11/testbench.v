`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    wire tick;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .enable(enable),
        .tick(tick)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            $display("Resetting DUT...");
            enable = 0;
            repeat(5) @(posedge clk);

            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Check disabled state (enable=0)", test_num);
            reset_dut();
            enable = 0;
            repeat(500) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Check initial state after enable", test_num);
            reset_dut();
            enable = 1;

            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        integer timeout;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Verify tick eventually occurs when enabled", test_num);
            reset_dut();
            enable = 1;
            timeout = 0;

            while (tick !== 1'b1 && timeout < 10000) begin
                @(posedge clk);
                timeout = timeout + 1;
            end
            #1;
            if (timeout >= 10000)
                $display("  Error: Timeout waiting for tick pulse.");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Verify tick returns to 0 after one cycle (pulse width check)", test_num);
            reset_dut();
            enable = 1;

            while (tick !== 1'b1) @(posedge clk);

            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Verify tick stops when enable is lowered", test_num);
            reset_dut();
            enable = 1;

            repeat(10) @(posedge clk);
            enable = 0;

            repeat(2000) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        integer ticks_found;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Verify periodic behavior (detecting multiple pulses)", test_num);
            reset_dut();
            enable = 1;
            ticks_found = 0;

            repeat(20000) begin
                @(posedge clk);
                if (tick === 1'b1) ticks_found = ticks_found + 1;
                if (ticks_found == 2) break;
            end
            #1;

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
        input expected_tick;
        begin
            if (expected_tick === (expected_tick ^ tick ^ expected_tick)) begin
                $display("PASS");
                $display("  Outputs: tick=%b",
                         tick);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: tick=%b",
                         expected_tick);
                $display("  Got:      tick=%b",
                         tick);
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
        $dumpvars(0,clk, enable, tick);
    end

endmodule
