`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg direction;
    reg load;
    reg reset;
    wire [3:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .direction(direction),
        .load(load),
        .reset(reset),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            reset = 1;
            load = 0;
            direction = 0;
            data_in = 4'b0000;
            @(negedge clk);
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Reset check...");
            reset_dut();

            #1;


            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Load 4'hA...");
            reset_dut();
            @(negedge clk);
            load = 1;
            data_in = 4'hA;
            @(negedge clk);
            load = 0;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Counting up 5 times...");
            reset_dut();
            @(negedge clk);
            direction = 1;
            repeat (5) @(negedge clk);
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Loading 4'h7 and counting down 3 times...");
            reset_dut();
            @(negedge clk);
            load = 1;
            data_in = 4'h7;
            @(negedge clk);
            load = 0;
            direction = 0;
            repeat (3) @(negedge clk);
            #1;

            check_outputs(4'h4);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Upward wrap-around (15 -> 0)...");
            reset_dut();
            @(negedge clk);
            load = 1;
            data_in = 4'hF;
            @(negedge clk);
            load = 0;
            direction = 1;
            @(negedge clk);
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Downward wrap-around (0 -> 15)...");
            reset_dut();
            @(negedge clk);
            direction = 0;
            @(negedge clk);
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: Switching directions (Up 3, Down 1)...");
            reset_dut();
            @(negedge clk);
            direction = 1;
            repeat (3) @(negedge clk);
            direction = 0;
            @(negedge clk);
            #1;

            check_outputs(4'h2);
        end
        endtask

    task testcase008;

        begin
            $display("Running testcase008: Load priority over counting...");
            reset_dut();
            @(negedge clk);
            load = 1;
            data_in = 4'hC;
            direction = 1;
            @(negedge clk);
            #1;

            check_outputs(4'hC);
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
        input [3:0] expected_count;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count)) begin
                $display("PASS");
                $display("  Outputs: count=%h",
                         count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h",
                         expected_count);
                $display("  Got:      count=%h",
                         count);
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
        $dumpvars(0,clk, data_in, direction, load, reset, count);
    end

endmodule
