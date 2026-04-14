`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] channel_enable;
    reg clk;
    reg reset;
    reg start;
    wire [2:0] active_channel;
    wire [7:0] channel_data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .channel_enable(channel_enable),
        .clk(clk),
        .reset(reset),
        .start(start),
        .active_channel(active_channel),
        .channel_data_out(channel_data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            channel_enable = 8'h00;
            start = 0;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task pulse_start;

        begin
            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;
        end
        endtask

    task testcase001;

        begin
            $display("Running testcase001: Single Channel (0)");
            reset_dut();
            channel_enable = 8'h01;
            pulse_start();

            @(posedge clk);
            #1;

            check_outputs(3'd0, 8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Single Channel (5)");
            reset_dut();
            channel_enable = 8'h20;
            pulse_start();
            @(posedge clk);
            #1;

            check_outputs(3'd5, 8'h05);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Round-robin 0 -> 1");
            reset_dut();
            channel_enable = 8'h03;
            pulse_start();
            pulse_start();
            @(posedge clk);
            #1;

            check_outputs(3'd1, 8'h01);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Skip Channel (0 -> 2)");
            reset_dut();
            channel_enable = 8'h05;
            pulse_start();
            pulse_start();
            @(posedge clk);
            #1;

            check_outputs(3'd2, 8'h02);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Wrap-around (7 -> 0)");
            reset_dut();
            channel_enable = 8'h81;
            pulse_start();
            pulse_start();
            pulse_start();
            @(posedge clk);
            #1;

            check_outputs(3'd0, 8'h00);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: All Channels Enabled Sequence");
            reset_dut();
            channel_enable = 8'hFF;

            pulse_start();
            pulse_start();
            pulse_start();
            pulse_start();
            @(posedge clk);
            #1;

            check_outputs(3'd3, 8'h03);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dma_controller Testbench");
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
        input [2:0] expected_active_channel;
        input [7:0] expected_channel_data_out;
        begin
            if (expected_active_channel === (expected_active_channel ^ active_channel ^ expected_active_channel) &&
                expected_channel_data_out === (expected_channel_data_out ^ channel_data_out ^ expected_channel_data_out)) begin
                $display("PASS");
                $display("  Outputs: active_channel=%h, channel_data_out=%h",
                         active_channel, channel_data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: active_channel=%h, channel_data_out=%h",
                         expected_active_channel, expected_channel_data_out);
                $display("  Got:      active_channel=%h, channel_data_out=%h",
                         active_channel, channel_data_out);
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
        $dumpvars(0,channel_enable, clk, reset, start, active_channel, channel_data_out);
    end

endmodule
