`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] binary_num;
    reg clk;
    reg reset;
    wire [3:0] count_ones;
    wire is_multiple_of_three;
    wire is_odd;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .binary_num(binary_num),
        .clk(clk),
        .reset(reset),
        .count_ones(count_ones),
        .is_multiple_of_three(is_multiple_of_three),
        .is_odd(is_odd)
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
            binary_num = 0;
            @(posedge clk);
            reset = 0;


        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Reset Check");
            reset_dut();

            #1;


            check_outputs(4'd0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Input = 3");
            reset_dut();
            binary_num = 8'd3;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd2, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Input = 10");
            reset_dut();
            binary_num = 8'd10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd2, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Input = 255");
            reset_dut();
            binary_num = 8'd255;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd8, 1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Input = 0");
            reset_dut();
            binary_num = 8'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd0, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Input = 127");
            reset_dut();
            binary_num = 8'd127;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd7, 1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: Input = 64");
            reset_dut();
            binary_num = 8'd64;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd1, 1'b0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            $display("Running testcase008: Input = 21");
            reset_dut();
            binary_num = 8'd21;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd3, 1'b1, 1'b1);
        end
        endtask

    task testcase009;

        begin
            $display("Running testcase009: Input = 12");
            reset_dut();
            binary_num = 8'd12;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd2, 1'b1, 1'b0);
        end
        endtask

    task testcase010;

        begin
            $display("Running testcase010: Input = 1");
            reset_dut();
            binary_num = 8'd1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd1, 1'b0, 1'b1);
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
        input [3:0] expected_count_ones;
        input expected_is_multiple_of_three;
        input expected_is_odd;
        begin
            if (expected_count_ones === (expected_count_ones ^ count_ones ^ expected_count_ones) &&
                expected_is_multiple_of_three === (expected_is_multiple_of_three ^ is_multiple_of_three ^ expected_is_multiple_of_three) &&
                expected_is_odd === (expected_is_odd ^ is_odd ^ expected_is_odd)) begin
                $display("PASS");
                $display("  Outputs: count_ones=%h, is_multiple_of_three=%b, is_odd=%b",
                         count_ones, is_multiple_of_three, is_odd);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count_ones=%h, is_multiple_of_three=%b, is_odd=%b",
                         expected_count_ones, expected_is_multiple_of_three, expected_is_odd);
                $display("  Got:      count_ones=%h, is_multiple_of_three=%b, is_odd=%b",
                         count_ones, is_multiple_of_three, is_odd);
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
        $dumpvars(0,binary_num, clk, reset, count_ones, is_multiple_of_three, is_odd);
    end

endmodule
