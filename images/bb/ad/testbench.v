`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] data;
    reg load;
    reg reset;
    wire [4:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .load(load),
        .reset(reset),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            reset = 1;
            load = 0;
            data = 0;
            @(posedge clk);
            reset = 0;
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic reset and count to 5", test_num);
            reset_dut();

            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(5'd5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Synchronous load", test_num);
            reset_dut();
            @(posedge clk);
            load = 1;
            data = 5'h1A;
            @(posedge clk);
            load = 0;
            #1;
            #1;

            check_outputs(5'h1A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Counter wrap-around from 31 to 0", test_num);
            reset_dut();
            @(posedge clk);
            load = 1;
            data = 5'h1F;
            @(posedge clk);
            load = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset priority over load signal", test_num);
            reset_dut();
            @(posedge clk);
            reset = 1;
            load = 1;
            data = 5'h0A;
            @(posedge clk);
            reset = 0;
            load = 0;
            #1;
            #1;

            check_outputs(5'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Counting sequence after load", test_num);
            reset_dut();
            @(posedge clk);
            load = 1;
            data = 5'h05;
            @(posedge clk);
            load = 0;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(5'd8);
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
        input [4:0] expected_q;
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
        $dumpvars(0,clk, data, load, reset, q);
    end

endmodule
