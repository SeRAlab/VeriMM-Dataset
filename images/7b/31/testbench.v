`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg c1;
    reg c2;
    reg c3;
    reg clk;
    reg rst;
    wire f;
    wire g;
    wire [3:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c1(c1),
        .c2(c2),
        .c3(c3),
        .clk(clk),
        .rst(rst),
        .f(f),
        .g(g),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            a = 0;
            b = 0;
            c1 = 0;
            c2 = 0;
            c3 = 0;
            @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Reset State check...");
            reset_dut();
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0, 1'b1, 4'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Load 10, 4 (ra > rb)...");
            reset_dut();
            a = 4'd10; b = 4'd4; c1 = 1;
            @(posedge clk);
            #1 c1 = 0;
            #1;

            check_outputs(1'b1, 1'b0, 4'h0);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Load 3, 7 (ra < rb)...");
            reset_dut();
            a = 4'd3; b = 4'd7; c1 = 1;
            @(posedge clk);
            #1 c1 = 0;
            #1;

            check_outputs(1'b0, 1'b0, 4'h0);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Subtract ra (c2)...");
            reset_dut();
            a = 4'd10; b = 4'd4; c1 = 1;
            @(posedge clk);
            #1 c1 = 0; c2 = 1;
            @(posedge clk);
            #1 c2 = 0;
            #1;

            check_outputs(1'b1, 1'b0, 4'h0);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Subtract rb (c3)...");
            reset_dut();
            a = 4'd2; b = 4'd8; c1 = 1;
            @(posedge clk);
            #1 c1 = 0; c3 = 1;
            @(posedge clk);
            #1 c3 = 0;
            #1;

            check_outputs(1'b0, 1'b0, 4'h0);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Reach equality (ra=rb=4)...");
            reset_dut();
            a = 4'd12; b = 4'd4; c1 = 1;
            @(posedge clk);
            #1 c1 = 0; c2 = 1;
            @(posedge clk);
            @(posedge clk);
            #1 c2 = 0;
            #1;

            check_outputs(1'b0, 1'b1, 4'h4);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: Max load 15, 15...");
            reset_dut();
            a = 4'd15; b = 4'd15; c1 = 1;
            @(posedge clk);
            #1 c1 = 0;
            #1;

            check_outputs(1'b0, 1'b1, 4'hF);
        end
        endtask

    task testcase008;

        begin
            $display("Running testcase008: Complex Subtraction sequence...");
            reset_dut();
            a = 4'd7; b = 4'd3; c1 = 1;
            @(posedge clk);
            #1 c1 = 0; c2 = 1;
            @(posedge clk);
            @(posedge clk);
            #1 c2 = 0; c3 = 1;
            @(posedge clk);
            @(posedge clk);
            #1 c3 = 0;
            #1;

            check_outputs(1'b0, 1'b1, 4'h1);
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
        input expected_f;
        input expected_g;
        input [3:0] expected_q;
        begin
            if (expected_f === (expected_f ^ f ^ expected_f) &&
                expected_g === (expected_g ^ g ^ expected_g) &&
                expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: f=%b, g=%b, q=%h",
                         f, g, q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: f=%b, g=%b, q=%h",
                         expected_f, expected_g, expected_q);
                $display("  Got:      f=%b, g=%b, q=%h",
                         f, g, q);
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
        $dumpvars(0,a, b, c1, c2, c3, clk, rst, f, g, q);
    end

endmodule
