`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [23:0] a;
    reg [23:0] b;
    reg clk;
    reg reset_n;
    wire [23:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .reset_n(reset_n),
        .sum(sum)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset_n = 0;
            a = 0;
            b = 0;
            #15;
            reset_n = 1;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic Addition (1 + 1)", test_num);
            reset_dut();
            a = 24'h000001;
            b = 24'h000001;
            @(posedge clk);
            #2;
            #1;

            check_outputs(24'h000002);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero Addition (0 + 0)", test_num);
            reset_dut();
            a = 24'h000000;
            b = 24'h000000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(24'h000000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Maximum Value and Zero", test_num);
            reset_dut();
            a = 24'hFFFFFF;
            b = 24'h000000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(24'hFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Overflow Case (Max + 1)", test_num);
            reset_dut();
            a = 24'hFFFFFF;
            b = 24'h000001;
            @(posedge clk);
            #2;

            #1;


            check_outputs(24'h000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bit Alternation Pattern", test_num);
            reset_dut();
            a = 24'hAAAAAA;
            b = 24'h555555;
            @(posedge clk);
            #2;
            #1;

            check_outputs(24'hFFFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Carry Propagation through all bits", test_num);
            reset_dut();
            a = 24'hFFFFFE;
            b = 24'h000001;
            @(posedge clk);
            #2;
            #1;

            check_outputs(24'hFFFFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Mid-range Random Addition", test_num);
            reset_dut();
            a = 24'h123456;
            b = 24'h654321;
            @(posedge clk);
            #2;
            #1;

            check_outputs(24'h777777);
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
        input [23:0] expected_sum;
        begin
            if (expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: sum=%h",
                         sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sum=%h",
                         expected_sum);
                $display("  Got:      sum=%h",
                         sum);
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
        $dumpvars(0,a, b, clk, reset_n, sum);
    end

endmodule
