`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg enable_in;
    wire [7:0] data_out;
    wire enable_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .enable_in(enable_in),
        .data_out(data_out),
        .enable_out(enable_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            enable_in = 0;
            data_in = 0;


            repeat(10) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single Byte Write-Read", test_num);
            reset_dut();

            data_in = 8'hA5;
            enable_in = 1;
            @(posedge clk);
            enable_in = 0;

            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(8'hA5, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sequential Burst", test_num);
            reset_dut();

            data_in = 8'h11; enable_in = 1; @(posedge clk);
            data_in = 8'h22; enable_in = 1; @(posedge clk);
            data_in = 8'h33; enable_in = 1; @(posedge clk);
            enable_in = 0;



            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h33, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Initial Readiness", test_num);
            reset_dut();
            #1;
            #1;

            check_outputs(data_out, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Continuous Throughput", test_num);
            reset_dut();

            for (integer i = 0; i < 10; i = i + 1) begin
                data_in = 8'hD0 + i;
                enable_in = 1;
                @(posedge clk);
            end
            enable_in = 0;
            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(8'hD9, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Interleaved Write/Idle", test_num);
            reset_dut();

            data_in = 8'hAA; enable_in = 1; @(posedge clk);
            enable_in = 0; repeat(2) @(posedge clk);

            data_in = 8'hBB; enable_in = 1; @(posedge clk);
            enable_in = 0;

            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(8'hBB, 1'b1);
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
        input expected_enable_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_enable_out === (expected_enable_out ^ enable_out ^ expected_enable_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, enable_out=%b",
                         data_out, enable_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, enable_out=%b",
                         expected_data_out, expected_enable_out);
                $display("  Got:      data_out=%h, enable_out=%b",
                         data_out, enable_out);
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
        $dumpvars(0,clk, data_in, enable_in, data_out, enable_out);
    end

endmodule
