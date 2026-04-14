`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg areset;
    reg clk;
    reg [7:0] data;
    reg ena;
    reg load;
    wire [7:0] parallel_out;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .areset(areset),
        .clk(clk),
        .data(data),
        .ena(ena),
        .load(load),
        .parallel_out(parallel_out),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        areset = 0;
        forever #5 areset = ~areset;
    end

        task reset_dut;

        begin
            areset = 1;
            load = 0;
            ena = 0;
            data = 8'h00;
            #12;
            areset = 0;
            #8;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Initial Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Load Data Check", test_num);
            reset_dut();
            @(posedge clk);
            data = 8'hA5;
            load = 1;
            @(posedge clk);
            load = 0;
            #1;
            #1;

            check_outputs(8'hA5, 8'hA5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Shift Left (1 bit) Check", test_num);
            reset_dut();

            @(posedge clk);
            data = 8'h01;
            load = 1;
            @(posedge clk);
            load = 0;
            ena = 1;
            @(posedge clk);
            ena = 0;
            #1;
            #1;

            check_outputs(8'h02, 8'h02);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Multi-shift Left Check", test_num);
            reset_dut();

            @(posedge clk);
            data = 8'h80;
            load = 1;
            @(posedge clk);
            load = 0;
            ena = 1;
            @(posedge clk);
            ena = 0;
            #1;
            #1;

            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Load Priority Check", test_num);
            reset_dut();

            @(posedge clk);
            data = 8'h55;
            load = 1;
            @(posedge clk);

            data = 8'hFF;
            load = 1;
            ena = 1;
            @(posedge clk);
            load = 0;
            ena = 0;
            #1;

            #1;


            check_outputs(8'hFF, 8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Data Hold Check", test_num);
            reset_dut();
            @(posedge clk);
            data = 8'h3C;
            load = 1;
            @(posedge clk);
            load = 0;
            ena = 0;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h3C, 8'h3C);
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
        input [7:0] expected_parallel_out;
        input [7:0] expected_q;
        begin
            if (expected_parallel_out === (expected_parallel_out ^ parallel_out ^ expected_parallel_out) &&
                expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: parallel_out=%h, q=%h",
                         parallel_out, q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: parallel_out=%h, q=%h",
                         expected_parallel_out, expected_q);
                $display("  Got:      parallel_out=%h, q=%h",
                         parallel_out, q);
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
        $dumpvars(0,areset, clk, data, ena, load, parallel_out, q);
    end

endmodule
