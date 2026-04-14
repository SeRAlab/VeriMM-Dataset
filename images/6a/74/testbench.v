`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_in;
    reg inc_in;
    reg rst_in;
    wire ov_out;
    wire [18:0] x_index_out;
    wire [18:0] y_index_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_in(clk_in),
        .inc_in(inc_in),
        .rst_in(rst_in),
        .ov_out(ov_out),
        .x_index_out(x_index_out),
        .y_index_out(y_index_out)
    );

    // Clock generation (10ns period)
    initial begin
        inc_in = 0;
        forever #5 inc_in = ~inc_in;
    end

        task reset_dut;

        begin
            rst_in = 1;
            inc_in = 0;
            @(posedge clk_in);
            #1;
            rst_in = 0;
            @(posedge clk_in);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Basic Increment", test_num);
            reset_dut();
            repeat (10) begin
                inc_in = 1;
                @(posedge clk_in);
                #1 inc_in = 0;
                @(posedge clk_in);
            end
            #1;

            check_outputs(0, 19'd10, 19'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: X-axis Wrap Around", test_num);
            reset_dut();
            repeat (320) begin
                inc_in = 1;
                @(posedge clk_in);
                #1 inc_in = 0;
                @(posedge clk_in);
            end
            #1;

            check_outputs(0, 19'd0, 19'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Multiple Line Wraps", test_num);
            reset_dut();

            repeat (1650) begin
                inc_in = 1;
                @(posedge clk_in);
                #1 inc_in = 0;
                @(posedge clk_in);
            end
            #1;

            check_outputs(0, 19'd50, 19'd5);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Full Frame Overflow", test_num);
            reset_dut();

            for (i = 0; i < 76800; i = i + 1) begin
                inc_in = 1;
                @(posedge clk_in);
                #1 inc_in = 0;

            end

            #1;


            check_outputs(1, 19'd0, 19'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Mid-Count Reset", test_num);
            reset_dut();
            repeat (500) begin
                inc_in = 1;
                @(posedge clk_in);
                #1 inc_in = 0;
                @(posedge clk_in);
            end

            rst_in = 1;
            @(posedge clk_in);
            #1 rst_in = 0;
            #1;

            check_outputs(0, 19'd0, 19'd0);
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
        input expected_ov_out;
        input [18:0] expected_x_index_out;
        input [18:0] expected_y_index_out;
        begin
            if (expected_ov_out === (expected_ov_out ^ ov_out ^ expected_ov_out) &&
                expected_x_index_out === (expected_x_index_out ^ x_index_out ^ expected_x_index_out) &&
                expected_y_index_out === (expected_y_index_out ^ y_index_out ^ expected_y_index_out)) begin
                $display("PASS");
                $display("  Outputs: ov_out=%b, x_index_out=%h, y_index_out=%h",
                         ov_out, x_index_out, y_index_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ov_out=%b, x_index_out=%h, y_index_out=%h",
                         expected_ov_out, expected_x_index_out, expected_y_index_out);
                $display("  Got:      ov_out=%b, x_index_out=%h, y_index_out=%h",
                         ov_out, x_index_out, y_index_out);
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
        $dumpvars(0,clk_in, inc_in, rst_in, ov_out, x_index_out, y_index_out);
    end

endmodule
