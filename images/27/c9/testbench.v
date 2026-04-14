`timescale 1ns/1ps

module CholeskyDecomp_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg clk;
    reg reset;
    wire [3:0] l11;
    wire [3:0] l21;
    wire [3:0] l22;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    CholeskyDecomp dut (
        .a(a),
        .b(b),
        .clk(clk),
        .reset(reset),
        .l11(l11),
        .l21(l21),
        .l22(l22)
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
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = 4'd1;
            b = 4'd0;
            repeat(5) @(posedge clk);
            $display("Testcase %0d: Input a=%d, b=%d (Identity-like)", test_num, a, b);
            #1;

            check_outputs(4'd1, 4'd0, 4'd1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = 4'd4;
            b = 4'd0;
            repeat(5) @(posedge clk);
            $display("Testcase %0d: Input a=%d, b=%d (Diagonal Scaling)", test_num, a, b);
            #1;

            check_outputs(4'd2, 4'd0, 4'd2);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = 4'd4;
            b = 4'd2;
            repeat(5) @(posedge clk);
            $display("Testcase %0d: Input a=%d, b=%d (Standard Decomposition)", test_num, a, b);
            #1;

            check_outputs(4'd2, 4'd1, 4'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = 4'd9;
            b = 4'd0;
            repeat(5) @(posedge clk);
            $display("Testcase %0d: Input a=%d, b=%d (Diagonal Scaling)", test_num, a, b);
            #1;

            check_outputs(4'd3, 4'd0, 4'd3);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = 4'd9;
            b = 4'd3;
            repeat(5) @(posedge clk);
            $display("Testcase %0d: Input a=%d, b=%d (Mixed Elements)", test_num, a, b);
            #1;

            check_outputs(4'd3, 4'd1, 4'd2);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("CholeskyDecomp Testbench");
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
        input [3:0] expected_l11;
        input [3:0] expected_l21;
        input [3:0] expected_l22;
        begin
            if (expected_l11 === (expected_l11 ^ l11 ^ expected_l11) &&
                expected_l21 === (expected_l21 ^ l21 ^ expected_l21) &&
                expected_l22 === (expected_l22 ^ l22 ^ expected_l22)) begin
                $display("PASS");
                $display("  Outputs: l11=%h, l21=%h, l22=%h",
                         l11, l21, l22);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: l11=%h, l21=%h, l22=%h",
                         expected_l11, expected_l21, expected_l22);
                $display("  Got:      l11=%h, l21=%h, l22=%h",
                         l11, l21, l22);
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
        $dumpvars(0,a, b, clk, reset, l11, l21, l22);
    end

endmodule
