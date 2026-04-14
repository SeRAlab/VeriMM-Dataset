`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg control;
    reg [3:0] data;
    reg load;
    reg reset;
    wire [3:0] count;
    wire max_reached;
    wire min_reached;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .control(control),
        .data(data),
        .load(load),
        .reset(reset),
        .count(count),
        .max_reached(max_reached),
        .min_reached(min_reached)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            load = 0;
            control = 1;
            data = 4'h0;
            #15;
            reset = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Initial Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(4'h0, 1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Load Data 4'hA", test_num);
            reset_dut();
            @(posedge clk);
            data = 4'hA;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            #1;

            check_outputs(4'hA, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Count Up from 0 to 3", test_num);
            reset_dut();
            control = 1;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h3, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Count Down from 4'h5 to 4'h2", test_num);
            reset_dut();

            data = 4'h5;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            control = 0;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h2, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Check Max Reached (15)", test_num);
            reset_dut();
            data = 4'hF;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            #1;

            check_outputs(4'hF, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Up Count Wrap-around (15 to 0)", test_num);
            reset_dut();
            data = 4'hF;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            control = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h0, 1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Down Count Wrap-around (0 to 15)", test_num);
            reset_dut();
            control = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'hF, 1'b1, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Load Priority Over Counting", test_num);
            reset_dut();
            control = 1;
            data = 4'h7;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            #1;

            check_outputs(4'h7, 1'b0, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Check Min Reached (0)", test_num);
            reset_dut();
            data = 4'h1;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            control = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h0, 1'b0, 1'b1);
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
        input expected_max_reached;
        input expected_min_reached;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count) &&
                expected_max_reached === (expected_max_reached ^ max_reached ^ expected_max_reached) &&
                expected_min_reached === (expected_min_reached ^ min_reached ^ expected_min_reached)) begin
                $display("PASS");
                $display("  Outputs: count=%h, max_reached=%b, min_reached=%b",
                         count, max_reached, min_reached);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h, max_reached=%b, min_reached=%b",
                         expected_count, expected_max_reached, expected_min_reached);
                $display("  Got:      count=%h, max_reached=%b, min_reached=%b",
                         count, max_reached, min_reached);
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
        $dumpvars(0,clk, control, data, load, reset, count, max_reached, min_reached);
    end

endmodule
