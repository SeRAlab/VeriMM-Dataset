`timescale 1ns/1ps

module UpDownCounter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg direction;
    reg enable;
    reg rst;
    wire [2:0] counter_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    UpDownCounter dut (
        .clk(clk),
        .direction(direction),
        .enable(enable),
        .rst(rst),
        .counter_out(counter_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            rst = 1;
            enable = 0;
            direction = 0;
            @(negedge clk);
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Reset Functionality");
            reset_dut();

            #1;


            check_outputs(3'd0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Counting Up (3 cycles)");
            reset_dut();
            @(negedge clk);
            enable = 1;
            direction = 1;
            repeat (3) @(negedge clk);
            #1;

            check_outputs(3'd3);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Counting Down from 0 (Wrap to 7)");
            reset_dut();
            @(negedge clk);
            enable = 1;
            direction = 0;
            @(negedge clk);
            #1;

            check_outputs(3'd7);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Enable signal low (Pause)");
            reset_dut();
            @(negedge clk);
            enable = 0;
            direction = 1;
            repeat (5) @(negedge clk);
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Full Up Cycle (8 steps back to 0)");
            reset_dut();
            @(negedge clk);
            enable = 1;
            direction = 1;
            repeat (8) @(negedge clk);
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Up 2 steps, Down 1 step");
            reset_dut();
            @(negedge clk);
            enable = 1;
            direction = 1;
            repeat (2) @(negedge clk);
            direction = 0;
            @(negedge clk);
            #1;

            check_outputs(3'd1);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Count to 7");
            reset_dut();
            @(negedge clk);
            enable = 1;
            direction = 1;
            repeat (7) @(negedge clk);
            #1;

            check_outputs(3'd7);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Intermittent Enable");
            reset_dut();
            @(negedge clk);
            enable = 1; direction = 1; @(negedge clk);
            enable = 0; @(negedge clk);
            enable = 1; @(negedge clk);
            #1;

            check_outputs(3'd2);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("UpDownCounter Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [2:0] expected_counter_out;
        begin
            if (expected_counter_out === (expected_counter_out ^ counter_out ^ expected_counter_out)) begin
                $display("PASS");
                $display("  Outputs: counter_out=%h",
                         counter_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: counter_out=%h",
                         expected_counter_out);
                $display("  Got:      counter_out=%h",
                         counter_out);
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
        $dumpvars(0,clk, direction, enable, rst, counter_out);
    end

endmodule
