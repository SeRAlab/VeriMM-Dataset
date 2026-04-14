`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg in1;
    reg in2;
    reg rst;
    wire out1;
    wire out2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in1(in1),
        .in2(in2),
        .rst(rst),
        .out1(out1),
        .out2(out2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            in1 = 0;
            in2 = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running Testcase %03d: Reset to S0", test_num);
            reset_dut();
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Testcase %03d: S0 to S1 Transition", test_num);
            reset_dut();
            in1 = 1; in2 = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Testcase %03d: S0 to S1 to S2 Transition", test_num);
            reset_dut();

            in1 = 1; in2 = 0;
            @(posedge clk);
            #1;

            in1 = 0; in2 = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Testcase %03d: Verify S0 Stability", test_num);
            reset_dut();
            in1 = 0; in2 = 0;
            @(posedge clk);
            @(posedge clk);
            #2;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Running Testcase %03d: Reset during operation", test_num);
            reset_dut();

            in1 = 1; in2 = 0;
            @(posedge clk);
            #1;

            rst = 1;
            @(posedge clk);
            #1;
            rst = 0;
            #2;
            #1;

            check_outputs(1, 0);
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
        input expected_out1;
        input expected_out2;
        begin
            if (expected_out1 === (expected_out1 ^ out1 ^ expected_out1) &&
                expected_out2 === (expected_out2 ^ out2 ^ expected_out2)) begin
                $display("PASS");
                $display("  Outputs: out1=%b, out2=%b",
                         out1, out2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out1=%b, out2=%b",
                         expected_out1, expected_out2);
                $display("  Got:      out1=%b, out2=%b",
                         out1, out2);
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
        $dumpvars(0,clk, in1, in2, rst, out1, out2);
    end

endmodule
