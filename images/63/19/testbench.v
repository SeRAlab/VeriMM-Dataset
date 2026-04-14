`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg clk;
    reg reset;
    wire overflow;
    wire [7:0] s;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .reset(reset),
        .overflow(overflow),
        .s(s)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            a = 0;
            b = 0;
            @(posedge clk);
            #1;
            reset = 0;

        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            a = 8'sd10;
            b = 8'sd20;
            @(posedge clk);
            #1;
            $display("Testcase %0d: 10 + 20", test_num);
            #1;

            check_outputs(1'b0, 8'sd30);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            a = -8'sd15;
            b = -8'sd35;
            @(posedge clk);
            #1;
            $display("Testcase %0d: -15 + -35", test_num);
            #1;

            check_outputs(1'b0, -8'sd50);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            a = 8'sd50;
            b = -8'sd20;
            @(posedge clk);
            #1;
            $display("Testcase %0d: 50 + (-20)", test_num);
            #1;

            check_outputs(1'b0, 8'sd30);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            a = 8'sd120;
            b = 8'sd10;
            @(posedge clk);
            #1;
            $display("Testcase %0d: 120 + 10 (Positive Overflow)", test_num);

            #1;


            check_outputs(1'b1, 8'b10000010);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            a = -8'sd120;
            b = -8'sd10;
            @(posedge clk);
            #1;
            $display("Testcase %0d: -120 + -10 (Negative Overflow)", test_num);

            #1;


            check_outputs(1'b1, 8'b01111110);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            a = 8'sd127;
            b = 8'sd0;
            @(posedge clk);
            #1;
            $display("Testcase %0d: 127 + 0", test_num);
            #1;

            check_outputs(1'b0, 8'sd127);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            a = -8'sd128;
            b = 8'sd0;
            @(posedge clk);
            #1;
            $display("Testcase %0d: -128 + 0", test_num);
            #1;

            check_outputs(1'b0, -8'sd128);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            a = 8'sd127;
            b = 8'sd127;
            @(posedge clk);
            #1;
            $display("Testcase %0d: 127 + 127 (Max Positive Overflow)", test_num);

            #1;


            check_outputs(1'b1, 8'sb11111110);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            reset_dut();
            a = -8'sd128;
            b = -8'sd128;
            @(posedge clk);
            #1;
            $display("Testcase %0d: -128 + -128 (Max Negative Overflow)", test_num);

            #1;


            check_outputs(1'b1, 8'sb00000000);
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
        input expected_overflow;
        input [7:0] expected_s;
        begin
            if (expected_overflow === (expected_overflow ^ overflow ^ expected_overflow) &&
                expected_s === (expected_s ^ s ^ expected_s)) begin
                $display("PASS");
                $display("  Outputs: overflow=%b, s=%h",
                         overflow, s);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: overflow=%b, s=%h",
                         expected_overflow, expected_s);
                $display("  Got:      overflow=%b, s=%h",
                         overflow, s);
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
        $dumpvars(0,a, b, clk, reset, overflow, s);
    end

endmodule
