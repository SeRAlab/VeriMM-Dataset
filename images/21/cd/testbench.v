`timescale 1ns/1ps

module pipeline_2stage_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg rst;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipeline_2stage dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            data_in = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            @(negedge clk);
            data_in = 8'd10;
            @(negedge clk);
            data_in = 8'd0;
            repeat(1) @(negedge clk);
            $display("Test Case 001: Input 10 -> Expected 23");
            #1;

            check_outputs(8'd23);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            @(negedge clk);
            data_in = 8'd0;
            @(negedge clk);
            repeat(1) @(negedge clk);
            $display("Test Case 002: Input 0 -> Expected 3");
            #1;

            check_outputs(8'd3);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            @(negedge clk);
            data_in = 8'd126;
            @(negedge clk);
            data_in = 8'd0;
            repeat(1) @(negedge clk);
            $display("Test Case 003: Input 126 -> Expected 255");
            #1;

            check_outputs(8'd255);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            @(negedge clk);
            data_in = 8'd128;
            @(negedge clk);
            data_in = 8'd0;
            repeat(1) @(negedge clk);
            $display("Test Case 004: Input 128 -> Expected 3 (Overflow)");
            #1;

            check_outputs(8'd3);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            @(negedge clk);
            data_in = 8'd200;
            @(negedge clk);
            data_in = 8'd0;
            repeat(1) @(negedge clk);
            $display("Test Case 005: Input 200 -> Expected 147");
            #1;

            check_outputs(8'd147);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pipeline_2stage Testbench");
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
        input [7:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clk, data_in, rst, data_out);
    end

endmodule
