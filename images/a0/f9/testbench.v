`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg clk;
    wire eq;
    wire gt;
    wire lt;
    wire overflow;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .clk(clk),
        .eq(eq),
        .gt(gt),
        .lt(lt),
        .overflow(overflow)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            A = 8'd0;
            B = 8'd0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: A=0, B=0 (Equality)", test_num);
            A = 8'sd0; B = 8'sd0;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(1, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: A=50, B=20 (A > B)", test_num);
            A = 8'sd50; B = 8'sd20;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(0, 1, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: A=15, B=40 (A < B)", test_num);
            A = 8'sd15; B = 8'sd40;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(0, 0, 1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: A=-10, B=-30 (A > B)", test_num);
            A = -8'sd10; B = -8'sd30;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(0, 1, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: A=-50, B=-20 (A < B)", test_num);
            A = -8'sd50; B = -8'sd20;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(0, 0, 1, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: A=10, B=-10 (A > B)", test_num);
            A = 8'sd10; B = -8'sd10;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(0, 1, 0, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: A=-12, B=5 (A < B)", test_num);
            A = -8'sd12; B = 8'sd5;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(0, 0, 1, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: A=127, B=127 (Equality)", test_num);
            A = 8'sd127; B = 8'sd127;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(1, 0, 0, 0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: A=100, B=-50 (A > B, Overflow)", test_num);
            A = 8'sd100; B = -8'sd50;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(0, 1, 0, 1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: A=-100, B=50 (A < B, Overflow)", test_num);
            A = -8'sd100; B = 8'sd50;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(0, 0, 1, 1);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: A=127, B=-128 (A > B, Overflow)", test_num);
            A = 8'sd127; B = -8'sd128;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(0, 1, 0, 1);
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
        testcase011();
        
        
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
        input expected_eq;
        input expected_gt;
        input expected_lt;
        input expected_overflow;
        begin
            if (expected_eq === (expected_eq ^ eq ^ expected_eq) &&
                expected_gt === (expected_gt ^ gt ^ expected_gt) &&
                expected_lt === (expected_lt ^ lt ^ expected_lt) &&
                expected_overflow === (expected_overflow ^ overflow ^ expected_overflow)) begin
                $display("PASS");
                $display("  Outputs: eq=%b, gt=%b, lt=%b, overflow=%b",
                         eq, gt, lt, overflow);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: eq=%b, gt=%b, lt=%b, overflow=%b",
                         expected_eq, expected_gt, expected_lt, expected_overflow);
                $display("  Got:      eq=%b, gt=%b, lt=%b, overflow=%b",
                         eq, gt, lt, overflow);
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
        $dumpvars(0,A, B, clk, eq, gt, lt, overflow);
    end

endmodule
