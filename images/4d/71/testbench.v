`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] DATA_IN;
    reg LOAD;
    reg [15:0] a;
    reg [15:0] b;
    reg clk;
    reg reset;
    wire [15:0] DATA_OUT;
    wire eq;
    wire greater_eq;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .DATA_IN(DATA_IN),
        .LOAD(LOAD),
        .a(a),
        .b(b),
        .clk(clk),
        .reset(reset),
        .DATA_OUT(DATA_OUT),
        .eq(eq),
        .greater_eq(greater_eq)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            DATA_IN = 0;
            LOAD = 0;
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
            $display("\nTestcase %03d: Reset Check", test_num);
            reset_dut();
            a = 16'h1234;
            b = 16'h5678;


            #2;
            #1;

            check_outputs(16'h0000, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Load Equal to A and > B", test_num);
            reset_dut();
            a = 16'hAAAA;
            b = 16'h1111;
            DATA_IN = 16'hAAAA;
            LOAD = 1;
            @(posedge clk);
            #1;
            LOAD = 0;
            #1;

            check_outputs(16'hAAAA, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Load < A and < B", test_num);
            reset_dut();
            a = 16'hFFFF;
            b = 16'h8000;
            DATA_IN = 16'h4444;
            LOAD = 1;
            @(posedge clk);
            #1;
            LOAD = 0;
            #1;

            check_outputs(16'h4444, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Load exactly equal to B", test_num);
            reset_dut();
            a = 16'h0000;
            b = 16'h5555;
            DATA_IN = 16'h5555;
            LOAD = 1;
            @(posedge clk);
            #1;
            LOAD = 0;

            #1;


            check_outputs(16'h5555, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: No load when LOAD signal is low", test_num);
            reset_dut();

            DATA_IN = 16'h1234;
            LOAD = 1;
            @(posedge clk);
            #1;

            LOAD = 0;
            DATA_IN = 16'hFFFF;
            @(posedge clk);
            #1;
            a = 16'h1234;
            b = 16'h1234;
            #1;

            check_outputs(16'h1234, 1'b1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Boundary Max Values", test_num);
            reset_dut();
            a = 16'hFFFF;
            b = 16'hFFFF;
            DATA_IN = 16'hFFFF;
            LOAD = 1;
            @(posedge clk);
            #1;
            LOAD = 0;
            #1;

            check_outputs(16'hFFFF, 1'b1, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Sequential loading", test_num);
            reset_dut();
            a = 16'h3333;
            b = 16'h2222;


            DATA_IN = 16'h1111;
            LOAD = 1;
            @(posedge clk);
            #1;


            DATA_IN = 16'h3333;
            @(posedge clk);
            #1;
            LOAD = 0;
            #1;

            check_outputs(16'h3333, 1'b1, 1'b1);
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
        input [15:0] expected_DATA_OUT;
        input expected_eq;
        input expected_greater_eq;
        begin
            if (expected_DATA_OUT === (expected_DATA_OUT ^ DATA_OUT ^ expected_DATA_OUT) &&
                expected_eq === (expected_eq ^ eq ^ expected_eq) &&
                expected_greater_eq === (expected_greater_eq ^ greater_eq ^ expected_greater_eq)) begin
                $display("PASS");
                $display("  Outputs: DATA_OUT=%h, eq=%b, greater_eq=%b",
                         DATA_OUT, eq, greater_eq);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DATA_OUT=%h, eq=%b, greater_eq=%b",
                         expected_DATA_OUT, expected_eq, expected_greater_eq);
                $display("  Got:      DATA_OUT=%h, eq=%b, greater_eq=%b",
                         DATA_OUT, eq, greater_eq);
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
        $dumpvars(0,DATA_IN, LOAD, a, b, clk, reset, DATA_OUT, eq, greater_eq);
    end

endmodule
