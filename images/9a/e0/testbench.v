`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data;
    reg reset;
    wire [3:0] length;
    wire [3:0] start_index;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .reset(reset),
        .length(length),
        .start_index(start_index)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data = 16'h0000;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All Zeros (16'h0000)", test_num);
            reset_dut();
            data = 16'h0000;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd0, 4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Single bit at index 0 (16'h0001)", test_num);
            reset_dut();
            data = 16'h0001;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd1, 4'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Single bit at index 15 (16'h8000)", test_num);
            reset_dut();
            data = 16'h8000;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd1, 4'd15);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Three bits at index 0 (16'h0007)", test_num);
            reset_dut();
            data = 16'h0007;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd3, 4'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Three bits at index 13 (16'hE000)", test_num);
            reset_dut();
            data = 16'hE000;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd3, 4'd13);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Six bits in middle (16'h07E0)", test_num);
            reset_dut();
            data = 16'h07E0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd6, 4'd5);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Two sequences, 4 is longer than 3 (16'hF070)", test_num);
            reset_dut();
            data = 16'hF070;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd4, 4'd12);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Two sequences, 4 is longer than 3 (16'h070F)", test_num);
            reset_dut();
            data = 16'h070F;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd4, 4'd0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: 15 consecutive 1s (16'h7FFF)", test_num);
            reset_dut();
            data = 16'h7FFF;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd15, 4'd0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating bits (16'h5555)", test_num);
            reset_dut();
            data = 16'h5555;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd1, 4'd0);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All ones (16'hFFFF)", test_num);
            reset_dut();
            data = 16'hFFFF;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd0, 4'd0);
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
        testcase011();
        
        
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
        input [3:0] expected_length;
        input [3:0] expected_start_index;
        begin
            if (expected_length === (expected_length ^ length ^ expected_length) &&
                expected_start_index === (expected_start_index ^ start_index ^ expected_start_index)) begin
                $display("PASS");
                $display("  Outputs: length=%h, start_index=%h",
                         length, start_index);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: length=%h, start_index=%h",
                         expected_length, expected_start_index);
                $display("  Got:      length=%h, start_index=%h",
                         length, start_index);
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
        $dumpvars(0,clk, data, reset, length, start_index);
    end

endmodule
