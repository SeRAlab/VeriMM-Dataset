`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg new_sample;
    reg rst;
    reg [9:0] sample;
    reg [3:0] sample_channel;
    wire [3:0] channel;
    wire [9:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .new_sample(new_sample),
        .rst(rst),
        .sample(sample),
        .sample_channel(sample_channel),
        .channel(channel),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            new_sample = 0;
            sample = 0;
            sample_channel = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset State Check", test_num);
            reset_dut();

            #1;


            check_outputs(4'h0, 10'h000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Valid Sample Channel 0", test_num);
            reset_dut();
            @(negedge clk);
            sample = 10'h3FF;
            sample_channel = 4'h0;
            new_sample = 1;
            @(posedge clk);
            #1 new_sample = 0;
            #1;

            check_outputs(4'h0, 10'h3FF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Ignore Non-Zero Channel", test_num);
            reset_dut();


            @(negedge clk);
            sample = 10'h123;
            sample_channel = 4'h0;
            new_sample = 1;
            @(posedge clk);


            @(negedge clk);
            sample = 10'hFFF;
            sample_channel = 4'h5;
            new_sample = 1;
            @(posedge clk);
            #1 new_sample = 0;


            #1;



            check_outputs(4'h0, 10'h123);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: No update when new_sample is low", test_num);
            reset_dut();


            @(negedge clk);
            sample = 10'h0AA;
            sample_channel = 4'h0;
            new_sample = 1;
            @(posedge clk);


            @(negedge clk);
            sample = 10'h0BB;
            sample_channel = 4'h0;
            new_sample = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(4'h0, 10'h0AA);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple Sequential Updates", test_num);
            reset_dut();


            @(negedge clk);
            sample = 10'h111;
            sample_channel = 4'h0;
            new_sample = 1;
            @(posedge clk);


            @(negedge clk);
            sample = 10'h222;
            sample_channel = 4'h0;
            new_sample = 1;
            @(posedge clk);
            #1 new_sample = 0;

            #1;


            check_outputs(4'h0, 10'h222);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Values (Max/Min)", test_num);
            reset_dut();


            @(negedge clk);
            sample = 10'h3FF;
            sample_channel = 4'h0;
            new_sample = 1;
            @(posedge clk);


            @(negedge clk);
            sample = 10'h000;
            sample_channel = 4'h0;
            new_sample = 1;
            @(posedge clk);
            #1 new_sample = 0;

            #1;


            check_outputs(4'h0, 10'h000);
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
        input [3:0] expected_channel;
        input [9:0] expected_out;
        begin
            if (expected_channel === (expected_channel ^ channel ^ expected_channel) &&
                expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: channel=%h, out=%h",
                         channel, out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: channel=%h, out=%h",
                         expected_channel, expected_out);
                $display("  Got:      channel=%h, out=%h",
                         channel, out);
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
        $dumpvars(0,clk, new_sample, rst, sample, sample_channel, channel, out);
    end

endmodule
