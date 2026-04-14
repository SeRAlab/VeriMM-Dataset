`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data_available;
    reg [7:0] data_in;
    reg data_read;
    reg reset;
    wire [7:0] data_out;
    wire data_out_en;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_available(data_available),
        .data_in(data_in),
        .data_read(data_read),
        .reset(reset),
        .data_out(data_out),
        .data_out_en(data_out_en)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data_available = 0;
            data_read = 0;
            data_in = 8'h00;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case 001: Reset behavior");
            reset_dut();

            #1;


            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case 002: Single increment check");
            reset_dut();
            @(negedge clk);
            data_available = 1;
            data_read = 0;
            @(negedge clk);
            data_available = 0;
            @(negedge clk);
            #1;

            check_outputs(8'h01, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case 003: Multiple increments (count to 5)");
            reset_dut();
            @(negedge clk);
            data_available = 1;
            data_read = 0;
            repeat(5) @(negedge clk);
            data_available = 0;
            @(negedge clk);
            #1;

            check_outputs(8'h05, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case 004: data_read inhibiting increment");
            reset_dut();
            @(negedge clk);
            data_available = 1;
            data_read = 0;
            repeat(3) @(negedge clk);
            data_read = 1;
            repeat(2) @(negedge clk);
            data_available = 0;
            data_read = 0;
            @(negedge clk);
            #1;

            check_outputs(8'h03, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case 005: data_available inhibiting increment");
            reset_dut();
            @(negedge clk);
            data_available = 1;
            repeat(2) @(negedge clk);
            data_available = 0;
            repeat(2) @(negedge clk);
            #1;

            check_outputs(8'h02, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case 006: Wrap around check (256 increments)");
            reset_dut();
            @(negedge clk);
            data_available = 1;
            data_read = 0;
            repeat(256) @(negedge clk);
            data_available = 0;
            @(negedge clk);
            #1;

            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case 007: Mid-operation reset");
            reset_dut();
            @(negedge clk);
            data_available = 1;
            repeat(10) @(negedge clk);
            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;
            #1;

            check_outputs(8'h00, 1'b0);
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
        input [7:0] expected_data_out;
        input expected_data_out_en;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_data_out_en === (expected_data_out_en ^ data_out_en ^ expected_data_out_en)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, data_out_en=%b",
                         data_out, data_out_en);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, data_out_en=%b",
                         expected_data_out, expected_data_out_en);
                $display("  Got:      data_out=%h, data_out_en=%b",
                         data_out, data_out_en);
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
        $dumpvars(0,clk, data_available, data_in, data_read, reset, data_out, data_out_en);
    end

endmodule
