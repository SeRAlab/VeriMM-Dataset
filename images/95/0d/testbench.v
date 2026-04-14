`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] x;
    reg [3:0] y;
    wire cOut;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .x(x),
        .y(y),
        .cOut(cOut),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            x = 4'd0;
            y = 4'd0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            x = 4'd5;
            y = 4'd3;
            @(posedge clk);
            #2;
            $display("Test %0d: x=5, y=3 (No Carry)", test_num);
            #1;

            check_outputs(1'b0, 8'd8);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            x = 4'd7;
            y = 4'd8;
            @(posedge clk);
            #2;
            $display("Test %0d: x=7, y=8 (Boundary No Carry)", test_num);
            #1;

            check_outputs(1'b0, 8'd15);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            x = 4'd8;
            y = 4'd8;
            @(posedge clk);
            #2;
            $display("Test %0d: x=8, y=8 (Carry Out, Sum 0)", test_num);
            #1;

            check_outputs(1'b1, 8'd0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            x = 4'd15;
            y = 4'd15;
            @(posedge clk);
            #2;
            $display("Test %0d: x=15, y=15 (Carry Out, Max Sum)", test_num);
            #1;

            check_outputs(1'b1, 8'd14);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            x = 4'd0;
            y = 4'd0;
            @(posedge clk);
            #2;
            $display("Test %0d: x=0, y=0", test_num);
            #1;

            check_outputs(1'b0, 8'd0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            x = 4'd10;
            y = 4'd7;
            @(posedge clk);
            #2;
            $display("Test %0d: x=10, y=7 (Carry Out, Sum 1)", test_num);
            #1;

            check_outputs(1'b1, 8'd1);
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
        input expected_cOut;
        input [7:0] expected_out;
        begin
            if (expected_cOut === (expected_cOut ^ cOut ^ expected_cOut) &&
                expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: cOut=%b, out=%h",
                         cOut, out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cOut=%b, out=%h",
                         expected_cOut, expected_out);
                $display("  Got:      cOut=%b, out=%h",
                         cOut, out);
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
        $dumpvars(0,clk, x, y, cOut, out);
    end

endmodule
