`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg clk;
    reg rst_n;
    reg sub;
    wire rise;
    wire [31:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .rst_n(rst_n),
        .sub(sub),
        .rise(rise),
        .sum(sum)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            a = 0;
            b = 0;
            sub = 0;
            #10;
            rst_n = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset Behavior", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple Addition (15 + 25)", test_num);
            reset_dut();
            a = 32'd15;
            b = 32'd25;
            sub = 1'b0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 32'd40);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple Subtraction (100 - 30)", test_num);
            reset_dut();
            a = 32'd100;
            b = 32'd30;
            sub = 1'b1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 32'd70);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition Wrap-around", test_num);
            reset_dut();
            a = 32'hFFFF_FFFF;
            b = 32'h0000_0001;
            sub = 1'b0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 32'h0000_0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction Underflow", test_num);
            reset_dut();
            a = 32'h0000_0005;
            b = 32'h0000_000A;
            sub = 1'b1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0, 32'hFFFF_FFFB);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Rise Flag Detection", test_num);
            reset_dut();


            a = 32'h0000_0001;
            b = 32'h0000_0000;
            sub = 1'b0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b1, 32'h0000_0001);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: No Rise Flag on 1->0 transition", test_num);
            reset_dut();


            a = 32'h1; b = 32'h0;
            @(posedge clk);
            #2;


            a = 32'h1; b = 32'h1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0, 32'h0);
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
        input expected_rise;
        input [31:0] expected_sum;
        begin
            if (expected_rise === (expected_rise ^ rise ^ expected_rise) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: rise=%b, sum=%h",
                         rise, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rise=%b, sum=%h",
                         expected_rise, expected_sum);
                $display("  Got:      rise=%b, sum=%h",
                         rise, sum);
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
        $dumpvars(0,a, b, clk, rst_n, sub, rise, sum);
    end

endmodule
