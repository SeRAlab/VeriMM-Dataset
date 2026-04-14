`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [19:0] in1;
    reg [19:0] in2;
    wire co1;
    wire co2;
    wire co3;
    wire if_error_delayed;
    wire [20:0] res;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in1(in1),
        .in2(in2),
        .co1(co1),
        .co2(co2),
        .co3(co3),
        .if_error_delayed(if_error_delayed),
        .res(res)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            in1 = 20'd0;
            in2 = 20'd0;
            @(posedge clk);
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simple Addition (100 + 200)", test_num);
            reset_dut();
            in1 = 20'd100;
            in2 = 20'd200;

            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0, 1'b0, 21'd300);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Carry Out Generation", test_num);
            reset_dut();
            in1 = 20'hFFFFF;
            in2 = 20'h00001;
            @(posedge clk);
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 1'b1, 1'b1, 1'b0, 21'h100000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition with Zero", test_num);
            reset_dut();
            in1 = 20'hA5A5A;
            in2 = 20'h00000;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0, 1'b0, 21'h0A5A5A);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum Values", test_num);
            reset_dut();
            in1 = 20'hFFFFF;
            in2 = 20'hFFFFF;
            @(posedge clk);
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 1'b1, 1'b1, 1'b0, 21'h1FFFFE);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bit Pattern A5A5A + 5A5A5", test_num);
            reset_dut();
            in1 = 20'hA5A5A;
            in2 = 20'h5A5A5;
            @(posedge clk);
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 1'b0, 21'h0FFFFF);
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
        input expected_co1;
        input expected_co2;
        input expected_co3;
        input expected_if_error_delayed;
        input [20:0] expected_res;
        begin
            if (expected_co1 === (expected_co1 ^ co1 ^ expected_co1) &&
                expected_co2 === (expected_co2 ^ co2 ^ expected_co2) &&
                expected_co3 === (expected_co3 ^ co3 ^ expected_co3) &&
                expected_if_error_delayed === (expected_if_error_delayed ^ if_error_delayed ^ expected_if_error_delayed) &&
                expected_res === (expected_res ^ res ^ expected_res)) begin
                $display("PASS");
                $display("  Outputs: co1=%b, co2=%b, co3=%b, if_error_delayed=%b, res=%h",
                         co1, co2, co3, if_error_delayed, res);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: co1=%b, co2=%b, co3=%b, if_error_delayed=%b, res=%h",
                         expected_co1, expected_co2, expected_co3, expected_if_error_delayed, expected_res);
                $display("  Got:      co1=%b, co2=%b, co3=%b, if_error_delayed=%b, res=%h",
                         co1, co2, co3, if_error_delayed, res);
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
        $dumpvars(0,clk, in1, in2, co1, co2, co3, if_error_delayed, res);
    end

endmodule
