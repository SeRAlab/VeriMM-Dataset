`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] config_chained;
    reg [7:0] config_high;
    reg [7:0] config_low;
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
        .config_high(config_high),
        .config_low(config_low),
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
            config_low = 8'h00;
            config_high = 8'h00;
            config_chained = 2'b00;
            input_char = 8'h00;
            input_valid = 0;
            prev_matched = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Basic range match [10, 20], input 15", test_num);
            reset_dut();

            config_low = 8'd10;
            config_high = 8'd20;
            config_chained = 2'b00;
            config_valid = 1'b1;
            @(posedge clk);
            #1 config_valid = 1'b0;

            input_char = 8'd15;
            input_valid = 1'b1;
            prev_matched = 1'b0;
            @(posedge clk);
            #2 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Below range [10, 20], input 5", test_num);
            reset_dut();
            config_low = 8'd10;
            config_high = 8'd20;
            config_chained = 2'b00;
            config_valid = 1'b1;
            @(posedge clk);
            #1 config_valid = 1'b0;
            input_char = 8'd5;
            input_valid = 1'b1;
            prev_matched = 1'b0;
            @(posedge clk);
            #2 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Above range [10, 20], input 25", test_num);
            reset_dut();
            config_low = 8'd10;
            config_high = 8'd20;
            config_chained = 2'b00;
            config_valid = 1'b1;
            @(posedge clk);
            #1 config_valid = 1'b0;
            input_char = 8'd25;
            input_valid = 1'b1;
            prev_matched = 1'b0;
            @(posedge clk);
            #2 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Chained match [10, 20], prev_matched=1", test_num);
            reset_dut();
            config_low = 8'd10;
            config_high = 8'd20;
            config_chained = 2'b01;
            config_valid = 1'b1;
            @(posedge clk);
            #1 config_valid = 1'b0;
            input_char = 8'd15;
            input_valid = 1'b1;
            prev_matched = 1'b1;
            @(posedge clk);
            #2 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Chained mismatch [10, 20], prev_matched=0", test_num);
            reset_dut();
            config_low = 8'd10;
            config_high = 8'd20;
            config_chained = 2'b01;
            config_valid = 1'b1;
            @(posedge clk);
            #1 config_valid = 1'b0;
            input_char = 8'd15;
            input_valid = 1'b1;
            prev_matched = 1'b0;
            @(posedge clk);
            #2 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: In-range but input_valid=0", test_num);
            reset_dut();
            config_low = 8'd10;
            config_high = 8'd20;
            config_chained = 2'b00;
            config_valid = 1'b1;
            @(posedge clk);
            #1 config_valid = 1'b0;
            input_char = 8'd15;
            input_valid = 1'b0;
            prev_matched = 1'b0;
            @(posedge clk);
            #2 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Single character range [65, 65]", test_num);
            reset_dut();
            config_low = 8'd65;
            config_high = 8'd65;
            config_chained = 2'b00;
            config_valid = 1'b1;
            @(posedge clk);
            #1 config_valid = 1'b0;
            input_char = 8'd65;
            input_valid = 1'b1;
            @(posedge clk);
            #2 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Boundary Low [10, 20], input 10", test_num);
            reset_dut();
            config_low = 8'd10;
            config_high = 8'd20;
            config_chained = 2'b00;
            config_valid = 1'b1;
            @(posedge clk);
            #1 config_valid = 1'b0;
            input_char = 8'd10;
            input_valid = 1'b1;
            @(posedge clk);
            #2 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Boundary High [10, 20], input 20", test_num);
            reset_dut();
            config_low = 8'd10;
            config_high = 8'd20;
            config_chained = 2'b00;
            config_valid = 1'b1;
            @(posedge clk);
            #1 config_valid = 1'b0;
            input_char = 8'd20;
            input_valid = 1'b1;
            @(posedge clk);
            #2 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: Full range [0, 255], input 128", test_num);
            reset_dut();
            config_low = 8'd0;
            config_high = 8'd255;
            config_chained = 2'b00;
            config_valid = 1'b1;
            @(posedge clk);
            #1 config_valid = 1'b0;
            input_char = 8'd128;
            input_valid = 1'b1;
            @(posedge clk);
            #2 #1;
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
        $dumpvars(0,clk, config_chained, config_high, config_low, config_valid, input_char, input_valid, prev_matched, rst, this_matched);
    end

endmodule
