`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] a;
    reg clk;
    reg reset;
    wire [3:0] y1;
    wire [3:0] y2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .clk(clk),
        .reset(reset),
        .y1(y1),
        .y2(y2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            a = 4'h0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Basic Reset Logic", test_num);
            reset = 1;
            a = 4'hA;
            @(posedge clk);
            #2;

            #1;


            check_outputs(4'h0, 4'hA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Normal Operation", test_num);
            reset_dut();
            a = 4'h5;
            @(posedge clk);
            #2;

            #1;


            check_outputs(4'h5, 4'h5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Successive Data Updates", test_num);
            reset_dut();

            a = 4'h3;
            @(posedge clk);
            #1;

            a = 4'hC;
            @(posedge clk);
            #2;

            #1;


            check_outputs(4'hC, 4'hC);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Reset during Operation", test_num);
            reset_dut();


            a = 4'h7;
            @(posedge clk);
            #1;


            reset = 1;
            a = 4'hE;
            @(posedge clk);
            #2;

            #1;


            check_outputs(4'h0, 4'hE);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Recovery from Reset", test_num);


            reset = 1;
            a = 4'h1;
            @(posedge clk);
            #1;


            reset = 0;
            a = 4'hB;
            @(posedge clk);
            #2;

            #1;


            check_outputs(4'hB, 4'hB);
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
        input [3:0] expected_y1;
        input [3:0] expected_y2;
        begin
            if (expected_y1 === (expected_y1 ^ y1 ^ expected_y1) &&
                expected_y2 === (expected_y2 ^ y2 ^ expected_y2)) begin
                $display("PASS");
                $display("  Outputs: y1=%h, y2=%h",
                         y1, y2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y1=%h, y2=%h",
                         expected_y1, expected_y2);
                $display("  Got:      y1=%h, y2=%h",
                         y1, y2);
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
        $dumpvars(0,a, clk, reset, y1, y2);
    end

endmodule
