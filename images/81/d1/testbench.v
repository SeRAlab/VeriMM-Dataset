`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg config_chained;
    reg [7:0] config_char;
    reg config_valid;
    reg [7:0] input_char;
    reg input_valid;
    reg prev_matched;
    reg rst;
    wire this_matched;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .config_chained(config_chained),
        .config_char(config_char),
        .config_valid(config_valid),
        .input_char(input_char),
        .input_valid(input_valid),
        .prev_matched(prev_matched),
        .rst(rst),
        .this_matched(this_matched)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            config_valid = 0;
            config_char = 8'h0;
            config_chained = 0;
            input_valid = 0;
            input_char = 8'h0;
            prev_matched = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            config_valid = 1; config_char = 8'h41; config_chained = 0;
            @(posedge clk);
            config_valid = 0;

            input_valid = 1; input_char = 8'h41;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            config_valid = 1; config_char = 8'h41; config_chained = 0;
            @(posedge clk);
            config_valid = 0;

            input_valid = 1; input_char = 8'h42;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            config_valid = 1; config_char = 8'h42; config_chained = 1;
            @(posedge clk);
            config_valid = 0;

            input_valid = 1; input_char = 8'h42; prev_matched = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            config_valid = 1; config_char = 8'h42; config_chained = 1;
            @(posedge clk);
            config_valid = 0;

            input_valid = 1; input_char = 8'h42; prev_matched = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            config_valid = 1; config_char = 8'h43; config_chained = 1;
            @(posedge clk);
            config_valid = 0;

            input_valid = 1; input_char = 8'h5A; prev_matched = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();

            config_valid = 1; config_char = 8'h58; config_chained = 0;
            @(posedge clk);

            config_valid = 0; config_char = 8'h59;
            @(posedge clk);

            input_valid = 1; input_char = 8'h58;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();

            config_valid = 1; config_char = 8'h4D; config_chained = 0;
            @(posedge clk);
            config_valid = 0;

            input_valid = 0; input_char = 8'h4D;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();

            config_valid = 1; config_char = 8'h31; config_chained = 0;
            @(posedge clk);

            config_valid = 1; config_char = 8'h32; config_chained = 0;
            @(posedge clk);
            config_valid = 0;

            input_valid = 1; input_char = 8'h32;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
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
        input expected_this_matched;
        begin
            if (expected_this_matched === (expected_this_matched ^ this_matched ^ expected_this_matched)) begin
                $display("PASS");
                $display("  Outputs: this_matched=%b",
                         this_matched);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: this_matched=%b",
                         expected_this_matched);
                $display("  Got:      this_matched=%b",
                         this_matched);
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
        $dumpvars(0,clk, config_chained, config_char, config_valid, input_char, input_valid, prev_matched, rst, this_matched);
    end

endmodule
