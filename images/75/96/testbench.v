`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [17:0] InitialOut;
    reg clk;
    reg [3:0] dt;
    reg [17:0] funct;
    reg reset;
    wire [17:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .InitialOut(InitialOut),
        .clk(clk),
        .dt(dt),
        .funct(funct),
        .reset(reset),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        input [17:0] init_val;
        begin
            reset = 0;
            InitialOut = init_val;
            funct = 18'd0;
            dt = 4'd0;
            @(posedge clk);
            #1;
            reset = 1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Reset", test_num);
            reset_dut(18'h12345);

            #1;


            check_outputs(18'h12345);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Simple Accumulation (dt=0)", test_num);
            reset_dut(18'd0);
            funct = 18'd100;
            dt = 4'd0;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(18'd500);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Integration with Positive Shift", test_num);
            reset_dut(18'd1000);
            funct = 18'd128;
            dt = 4'd4;
            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(18'd1080);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Integration with Negative Numbers", test_num);
            reset_dut(18'd0);
            funct = -18'sd64;
            dt = 4'd3;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(-18'sd40);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Shift result is zero", test_num);
            reset_dut(18'd500);
            funct = 18'd15;
            dt = 4'd4;
            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(18'd500);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Negative Arithmetic Shift Preservation", test_num);
            reset_dut(18'd0);
            funct = -18'sd1;
            dt = 4'd5;
            repeat(20) @(posedge clk);
            #1;
            #1;

            check_outputs(-18'sd20);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Overflow Wrap-around", test_num);
            reset_dut(18'sd131000);
            funct = 18'sd10;
            dt = 4'd0;
            repeat(10) @(posedge clk);
            #1;

            #1;


            check_outputs(18'h2001C);
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
        input [17:0] expected_out;
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
        $dumpvars(0,InitialOut, clk, dt, funct, reset, out);
    end

endmodule
