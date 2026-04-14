`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data;
    reg parallel_load;
    reg shift;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .parallel_load(parallel_load),
        .shift(shift),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            parallel_load = 0;
            shift = 0;
            data = 8'h00;

            parallel_load = 1;
            @(negedge clk);
            parallel_load = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Parallel Load 0xAA", test_num);
            @(negedge clk);
            data = 8'hAA;
            parallel_load = 1;
            shift = 0;
            @(negedge clk);
            parallel_load = 0;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Shift Right 0xFF once", test_num);
            @(negedge clk);
            data = 8'hFF;
            parallel_load = 1;
            @(negedge clk);
            parallel_load = 0;
            shift = 1;
            @(negedge clk);
            shift = 0;
            #1;

            check_outputs(8'h7F);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Shift Right 0x80 three times", test_num);
            @(negedge clk);
            data = 8'h80;
            parallel_load = 1;
            @(negedge clk);
            parallel_load = 0;
            shift = 1;
            repeat(3) @(negedge clk);
            shift = 0;
            #1;

            check_outputs(8'h10);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Priority Check (Load and Shift both High)", test_num);
            @(negedge clk);
            data = 8'h55;
            parallel_load = 1;
            @(negedge clk);
            data = 8'hCC;
            parallel_load = 1;
            shift = 1;
            @(negedge clk);
            parallel_load = 0;
            shift = 0;
            #1;

            check_outputs(8'hCC);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Hold State", test_num);
            @(negedge clk);
            data = 8'hA5;
            parallel_load = 1;
            @(negedge clk);
            parallel_load = 0;
            shift = 0;
            repeat(2) @(negedge clk);
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Shift Right 0x01 until 0", test_num);
            @(negedge clk);
            data = 8'h01;
            parallel_load = 1;
            @(negedge clk);
            parallel_load = 0;
            shift = 1;
            @(negedge clk);
            shift = 0;
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
        testcase006();
        
        
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
        input [7:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, data, parallel_load, shift, q);
    end

endmodule
