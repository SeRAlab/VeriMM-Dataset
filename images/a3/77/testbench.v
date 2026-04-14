`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data_in;
    reg rst;
    reg [3:0] sample;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .sample(sample),
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
            sample = 0;
            @(posedge clk);
            #2;
            rst = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Shift in 8 ones (Expecting 0xFF)", test_num);
            reset_dut();

            for (i = 0; i < 8; i = i + 1) begin
                @(negedge clk);
                sample = 6;
                data_in = 1;
            end

            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase002;

        reg [7:0] pattern;
        integer i;
        begin
            test_num = test_num + 1;
            pattern = 8'hA5;
            $display("\nTestcase %0d: Shift in pattern 0x%h", test_num, pattern);
            reset_dut();

            for (i = 7; i >= 0; i = i - 1) begin
                @(negedge clk);
                sample = 6;
                data_in = pattern[i];
            end

            @(posedge clk);
            #2;
            #1;

            check_outputs(pattern);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Verify sample signal gating", test_num);
            reset_dut();


            for (i = 0; i < 4; i = i + 1) begin
                @(negedge clk);
                sample = 6;
                data_in = 1;
            end


            for (i = 0; i < 4; i = i + 1) begin
                @(negedge clk);
                sample = 3;
                data_in = 0;
            end



            for (i = 0; i < 4; i = i + 1) begin
                @(negedge clk);
                sample = 6;
                data_in = 0;
            end

            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hF0);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Interleaved sample signals", test_num);
            reset_dut();






            @(negedge clk); sample = 6; data_in = 1;

            @(negedge clk); sample = 0; data_in = 0;

            @(negedge clk); sample = 6; data_in = 1;

            @(negedge clk); sample = 5; data_in = 1;

            @(negedge clk); sample = 6; data_in = 0;

            @(negedge clk); sample = 7; data_in = 0;

            @(negedge clk); sample = 6; data_in = 1;

            @(negedge clk); sample = 6; data_in = 1;

            @(negedge clk); sample = 6; data_in = 1;

            @(negedge clk); sample = 6; data_in = 1;

            @(negedge clk); sample = 6; data_in = 1;

            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hDF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset during operation", test_num);
            reset_dut();


            @(negedge clk); sample = 6; data_in = 1;
            @(negedge clk); sample = 6; data_in = 1;
            @(negedge clk); sample = 6; data_in = 1;


            @(negedge clk);
            rst = 1;

            @(posedge clk);
            #2;
            rst = 0;


            #1;



            check_outputs(8'h00);
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
        $dumpvars(0,clk, data_in, rst, sample, data_out);
    end

endmodule
