`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg count_en;
    reg [3:0] data_in;
    reg load;
    reg reset;
    wire [3:0] count_val;
    wire overflow;
    wire underflow;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .count_en(count_en),
        .data_in(data_in),
        .load(load),
        .reset(reset),
        .count_val(count_val),
        .overflow(overflow),
        .underflow(underflow)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            count_en = 0;
            load = 0;
            data_in = 4'b0;
            @(posedge clk);
            #1 reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(4'h0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            load = 1;
            data_in = 4'hA;
            @(posedge clk);
            #1 load = 0;
            #1;

            check_outputs(4'hA, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            load = 1; data_in = 4'h5; @(posedge clk); #1 load = 0;

            count_en = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h6, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            load = 1; data_in = 4'hF; @(posedge clk); #1 load = 0;

            count_en = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h0, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            load = 1; data_in = 4'h7; @(posedge clk); #1 load = 0;

            count_en = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h6, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();

            count_en = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'hF, 1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            load = 1;
            data_in = 4'h5;
            count_en = 1;
            reset = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h0, 1'b0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            load = 1;
            data_in = 4'hB;
            count_en = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'hB, 1'b0, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            reset_dut();
            count_en = 1;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(4'h3, 1'b0, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            reset_dut();
            count_en = 1;
            @(posedge clk);
            #1 count_en = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h0, 1'b0, 1'b0);
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
        input [3:0] expected_count_val;
        input expected_overflow;
        input expected_underflow;
        begin
            if (expected_count_val === (expected_count_val ^ count_val ^ expected_count_val) &&
                expected_overflow === (expected_overflow ^ overflow ^ expected_overflow) &&
                expected_underflow === (expected_underflow ^ underflow ^ expected_underflow)) begin
                $display("PASS");
                $display("  Outputs: count_val=%h, overflow=%b, underflow=%b",
                         count_val, overflow, underflow);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count_val=%h, overflow=%b, underflow=%b",
                         expected_count_val, expected_overflow, expected_underflow);
                $display("  Got:      count_val=%h, overflow=%b, underflow=%b",
                         count_val, overflow, underflow);
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
        $dumpvars(0,clk, count_en, data_in, load, reset, count_val, overflow, underflow);
    end

endmodule
