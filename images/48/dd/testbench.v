`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg up;
    wire [2:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .up(up),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            reset = 1;
            up = 0;
            @(posedge clk);
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase001: Initial Reset check");
            test_num = 1;
            reset_dut();
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase002: Single Count Up");
            test_num = 2;
            reset_dut();
            up = 1;
            @(posedge clk);
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase003: Count Up to 5");
            test_num = 3;
            reset_dut();
            up = 1;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(3'b101);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase004: Upward Wraparound (7 to 0)");
            test_num = 4;
            reset_dut();
            up = 1;
            repeat(8) @(posedge clk);
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase005: Single Count Down (0 to 7)");
            test_num = 5;
            reset_dut();
            up = 0;
            @(posedge clk);
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase006: Count Down from 0 to 5");
            test_num = 6;
            reset_dut();
            up = 0;
            repeat(3) @(posedge clk);
            #1;

            check_outputs(3'b101);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase007: Downward Full Cycle");
            test_num = 7;
            reset_dut();
            up = 0;
            repeat(8) @(posedge clk);
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase008: Direction change (Up 4 times, Down 2 times)");
            test_num = 8;
            reset_dut();
            up = 1;
            repeat(4) @(posedge clk);
            up = 0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase009: Direction change (Down 2 times, Up 3 times)");
            test_num = 9;
            reset_dut();
            up = 0;
            repeat(2) @(posedge clk);
            up = 1;
            repeat(3) @(posedge clk);
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase010;

        begin
            $display("Testcase010: Synchronous reset while counting");
            test_num = 10;
            reset_dut();
            up = 1;
            repeat(3) @(posedge clk);
            reset = 1;
            @(posedge clk);
            reset = 0;
            #1;

            check_outputs(3'b000);
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
        input [2:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, reset, up, q);
    end

endmodule
