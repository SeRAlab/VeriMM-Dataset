`timescale 1ns/1ps

module up_down_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg mode;
    reg rst;
    wire [2:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    up_down_counter dut (
        .clk(clk),
        .en(en),
        .mode(mode),
        .rst(rst),
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
            rst = 1;
            en = 0;
            mode = 0;
            @(negedge clk);
            rst = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic Increment");
            reset_dut();
            en = 1;
            mode = 0;
            repeat(3) @(negedge clk);
            #1;

            check_outputs(3'd3);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Basic Decrement with Wrap-around");
            reset_dut();
            en = 1;
            mode = 1;
            repeat(2) @(negedge clk);
            #1;

            check_outputs(3'd6);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Enable Signal De-asserted");
            reset_dut();
            en = 0;
            mode = 0;
            repeat(5) @(negedge clk);
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Up-Down Mode Switching");
            reset_dut();
            en = 1;
            mode = 0;
            repeat(5) @(negedge clk);
            mode = 1;
            repeat(2) @(negedge clk);
            #1;

            check_outputs(3'd3);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Full Cycle Increment");
            reset_dut();
            en = 1;
            mode = 0;
            repeat(8) @(negedge clk);
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Synchronous Reset Mid-count");
            reset_dut();
            en = 1;
            mode = 0;
            repeat(4) @(negedge clk);
            rst = 1;
            @(negedge clk);
            rst = 0;
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: Multiple Wrap-around Decrement");
            reset_dut();
            en = 1;
            mode = 1;
            repeat(9) @(negedge clk);
            #1;

            check_outputs(3'd7);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("up_down_counter Testbench");
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
        input [2:0] expected_count;
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
        $dumpvars(0,clk, en, mode, rst, count);
    end

endmodule
