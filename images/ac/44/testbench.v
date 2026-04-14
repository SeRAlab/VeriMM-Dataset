`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg clk;
    reg reset;
    reg start;
    wire done;
    wire [14:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .clk(clk),
        .reset(reset),
        .start(start),
        .done(done),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            start = 0;
            A = 0;
            B = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 0 x 0", test_num);
            reset_dut();
            A = 8'sd0; B = 8'sd0;
            start = 1;
            @(posedge clk); #1;
            start = 0;
            while (!done) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 15'sd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 32 x 16", test_num);
            reset_dut();
            A = 8'sd32; B = 8'sd16;
            start = 1;
            @(posedge clk); #1;
            start = 0;
            while (!done) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 15'sd2);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: -64 x 8", test_num);
            reset_dut();
            A = -8'sd64; B = 8'sd8;
            start = 1;
            @(posedge clk); #1;
            start = 0;
            while (!done) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, -15'sd2);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: -16 x -32", test_num);
            reset_dut();
            A = -8'sd16; B = -8'sd32;
            start = 1;
            @(posedge clk); #1;
            start = 0;
            while (!done) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 15'sd2);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 127 x 127", test_num);
            reset_dut();
            A = 8'sd127; B = 8'sd127;
            start = 1;
            @(posedge clk); #1;
            start = 0;
            while (!done) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 15'sd63);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: -128 x -128", test_num);
            reset_dut();
            A = -8'sd128; B = -8'sd128;
            start = 1;
            @(posedge clk); #1;
            start = 0;
            while (!done) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 15'sd64);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: -128 x 1", test_num);
            reset_dut();
            A = -8'sd128; B = 8'sd1;
            start = 1;
            @(posedge clk); #1;
            start = 0;
            while (!done) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, -15'sd1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 127 x 1", test_num);
            reset_dut();
            A = 8'sd127; B = 8'sd1;
            start = 1;
            @(posedge clk); #1;
            start = 0;
            while (!done) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 15'sd0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: -128 x 127", test_num);
            reset_dut();
            A = -8'sd128; B = 8'sd127;
            start = 1;
            @(posedge clk); #1;
            start = 0;
            while (!done) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, -15'sd64);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset during operation", test_num);
            reset_dut();
            A = 8'sd50; B = 8'sd50;
            start = 1;
            @(posedge clk);
            reset = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 15'sd0);
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
        input expected_done;
        input [14:0] expected_result;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: done=%b, result=%h",
                         done, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, result=%h",
                         expected_done, expected_result);
                $display("  Got:      done=%b, result=%h",
                         done, result);
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
        $dumpvars(0,A, B, clk, reset, start, done, result);
    end

endmodule
