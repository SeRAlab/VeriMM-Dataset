`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg h;
    wire [2:0] s;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .h(h),
        .s(s)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin


            h = 1;
            repeat(2) @(posedge clk);
            @(negedge clk);
        end
        endtask
    task testcase001;

        reg [2:0] start_val;
        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Single Increment Check", test_num);
            reset_dut();
            start_val = s;
            h = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(start_val + 3'd1);
        end
        endtask

    task testcase002;

        reg [2:0] start_val;
        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Multiple Increment Check (3 steps)", test_num);
            reset_dut();
            start_val = s;
            h = 0;
            repeat(3) @(posedge clk);
            #2;
            #1;

            check_outputs(start_val + 3'd3);
        end
        endtask

    task testcase003;

        reg [2:0] start_val;
        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Hold Logic Check", test_num);
            reset_dut();
            start_val = s;
            h = 1;
            repeat(4) @(posedge clk);
            #2;
            #1;

            check_outputs(start_val);
        end
        endtask

    task testcase004;

        reg [2:0] start_val;
        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Wrap-around Check (8 steps)", test_num);
            reset_dut();
            start_val = s;
            h = 0;
            repeat(8) @(posedge clk);
            #2;
            #1;

            check_outputs(start_val);
        end
        endtask

    task testcase005;

        reg [2:0] start_val;
        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Interleaved Halt Check", test_num);
            reset_dut();
            start_val = s;

            h = 0; @(posedge clk);
            h = 1; @(posedge clk);
            h = 0; @(posedge clk);
            h = 1; @(posedge clk);

            #2;
            #1;

            check_outputs(start_val + 3'd2);
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
        input [2:0] expected_s;
        begin
            if (expected_s === (expected_s ^ s ^ expected_s)) begin
                $display("PASS");
                $display("  Outputs: s=%h",
                         s);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: s=%h",
                         expected_s);
                $display("  Got:      s=%h",
                         s);
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
        $dumpvars(0,clk, h, s);
    end

endmodule
