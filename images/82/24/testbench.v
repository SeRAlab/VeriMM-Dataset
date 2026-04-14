`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] max_count;
    reg start_stop;
    wire [31:0] count;
    wire max_reached;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .max_count(max_count),
        .start_stop(start_stop),
        .count(count),
        .max_reached(max_reached)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            start_stop = 0;
            max_count = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Count to 5");
            test_num = 1;
            reset_dut();
            max_count = 5;
            start_stop = 1;

            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(5, 1);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Halt counter mid-way");
            test_num = 2;
            reset_dut();
            max_count = 10;
            start_stop = 1;
            repeat(4) @(posedge clk);
            start_stop = 0;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(4, 0);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Clear max_reached on stop");
            test_num = 3;
            reset_dut();
            max_count = 3;
            start_stop = 1;
            repeat(3) @(posedge clk);
            start_stop = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3, 0);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Wraparound behavior");
            test_num = 4;
            reset_dut();
            max_count = 2;
            start_stop = 1;



            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Large max_count (255)");
            test_num = 5;
            reset_dut();
            max_count = 32'd255;
            start_stop = 1;
            repeat(255) @(posedge clk);
            #1;
            #1;

            check_outputs(255, 1);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: max_count = 0");
            test_num = 6;
            reset_dut();
            max_count = 0;
            start_stop = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(0, 1);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: Resume after halt");
            test_num = 7;
            reset_dut();
            max_count = 10;
            start_stop = 1;
            repeat(5) @(posedge clk);
            start_stop = 0;
            repeat(2) @(posedge clk);
            start_stop = 1;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(7, 0);
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
        input [31:0] expected_count;
        input expected_max_reached;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count) &&
                expected_max_reached === (expected_max_reached ^ max_reached ^ expected_max_reached)) begin
                $display("PASS");
                $display("  Outputs: count=%h, max_reached=%b",
                         count, max_reached);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h, max_reached=%b",
                         expected_count, expected_max_reached);
                $display("  Got:      count=%h, max_reached=%b",
                         count, max_reached);
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
        $dumpvars(0,clk, max_count, start_stop, count, max_reached);
    end

endmodule
