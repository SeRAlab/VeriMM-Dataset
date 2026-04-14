`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    wire [31:0] sum_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .sum_out(sum_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            data_in = 0;
            repeat(2) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running testcase%03d: Basic small values", test_num);
            reset_dut();
            @(negedge clk) data_in = 8'd10;
            @(negedge clk) data_in = 8'd20;
            @(negedge clk) data_in = 8'd30;
            @(negedge clk) data_in = 8'd0;
            expected_sum = expected_sum + 10 + 20 + 30;
            #1;
            #1;

            check_outputs(expected_sum);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running testcase%03d: Large values (0xFF)", test_num);
            reset_dut();
            @(negedge clk) data_in = 8'hFF;
            @(negedge clk) data_in = 8'hFF;
            @(negedge clk) data_in = 8'hFF;
            @(negedge clk) data_in = 8'd0;
            expected_sum = expected_sum + 255 + 255 + 255;
            #1;
            #1;

            check_outputs(expected_sum);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running testcase%03d: Zero addition check", test_num);
            reset_dut();
            repeat(5) @(negedge clk) data_in = 8'd0;
            @(negedge clk);
            expected_sum = expected_sum + 0;
            #1;
            #1;

            check_outputs(expected_sum);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Running testcase%03d: Repeated small increments", test_num);
            reset_dut();
            for (i = 0; i < 10; i = i + 1) begin
                @(negedge clk) data_in = 8'd1;
            end
            @(negedge clk) data_in = 8'd0;
            expected_sum = expected_sum + 10;
            #1;
            #1;

            check_outputs(expected_sum);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running testcase%03d: Power of two sequence", test_num);
            reset_dut();
            @(negedge clk) data_in = 8'd128;
            @(negedge clk) data_in = 8'd64;
            @(negedge clk) data_in = 8'd32;
            @(negedge clk) data_in = 8'd16;
            @(negedge clk) data_in = 8'd0;
            expected_sum = expected_sum + 128 + 64 + 32 + 16;
            #1;
            #1;

            check_outputs(expected_sum);
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
        input [31:0] expected_sum_out;
        begin
            if (expected_sum_out === (expected_sum_out ^ sum_out ^ expected_sum_out)) begin
                $display("PASS");
                $display("  Outputs: sum_out=%h",
                         sum_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sum_out=%h",
                         expected_sum_out);
                $display("  Got:      sum_out=%h",
                         sum_out);
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
        $dumpvars(0,clk, data_in, sum_out);
    end

endmodule
