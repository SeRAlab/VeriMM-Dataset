`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ce;
    reg clk;
    reg [13:0] in;
    reg rst;
    wire [22:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ce(ce),
        .clk(clk),
        .in(in),
        .rst(rst),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            rst = 1;
            ce = 0;
            in = 0;
            @(posedge clk);
            #1;
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Basic Addition", test_num);
            reset_dut();
            @(posedge clk);
            in = 14'd500; ce = 1;
            @(posedge clk);
            in = 14'd1200; ce = 1;
            @(posedge clk);
            ce = 0;
            #1;
            #1;

            check_outputs(23'd1700);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Clock Enable (ce) Check", test_num);
            reset_dut();
            @(posedge clk);
            in = 14'd1000; ce = 1;
            @(posedge clk);
            in = 14'd5000; ce = 0;
            @(posedge clk);
            in = 14'd5000; ce = 0;
            @(posedge clk);
            in = 14'd250; ce = 1;
            @(posedge clk);
            ce = 0;
            #1;
            #1;

            check_outputs(23'd1250);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Large Value Accumulation", test_num);
            reset_dut();
            @(posedge clk);
            in = 14'h3FFF;
            ce = 1;
            for (i = 0; i < 100; i = i + 1) begin
                @(posedge clk);
            end
            ce = 0;
            #1;
            #1;

            check_outputs(23'd1638300);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Reset Priority", test_num);
            reset_dut();
            @(posedge clk);
            in = 14'd100; ce = 1;
            @(posedge clk);
            in = 14'd200; ce = 1;
            @(posedge clk);
            rst = 1;
            @(posedge clk);
            rst = 0;
            in = 14'd50; ce = 1;
            @(posedge clk);
            ce = 0;
            #1;
            #1;

            check_outputs(23'd50);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Zero Addition", test_num);
            reset_dut();
            @(posedge clk);
            in = 14'd8000; ce = 1;
            @(posedge clk);
            in = 14'd0; ce = 1;
            @(posedge clk);
            in = 14'd0; ce = 1;
            @(posedge clk);
            ce = 0;
            #1;
            #1;

            check_outputs(23'd8000);
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
        input [22:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,ce, clk, in, rst, out);
    end

endmodule
