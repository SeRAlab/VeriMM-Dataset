`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg cin;
    reg clk;
    reg rst;
    wire cout;
    wire [3:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .cin(cin),
        .clk(clk),
        .rst(rst),
        .cout(cout),
        .sum(sum)
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
            cin = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("\nTestcase 001: Reset Check");
            reset_dut();

            #1;


            check_outputs(1'b0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: Simple Addition (No Carry Out)");
            reset_dut();
            a = 4'h2;
            b = 4'h3;
            cin = 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 4'h5);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: Addition with Carry-in");
            reset_dut();
            a = 4'h5;
            b = 4'h5;
            cin = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 4'hb);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: Overflow Check (15 + 1)");
            reset_dut();
            a = 4'hf;
            b = 4'h1;
            cin = 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 4'h0);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: Maximum Sum (15 + 15 + 1)");
            reset_dut();
            a = 4'hf;
            b = 4'hf;
            cin = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 4'hf);
        end
        endtask

    task testcase006;

        begin
            $display("\nTestcase 006: Result exactly 15");
            reset_dut();
            a = 4'h7;
            b = 4'h8;
            cin = 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 4'hf);
        end
        endtask

    task testcase007;

        begin
            $display("\nTestcase 007: Zero addition");
            reset_dut();
            a = 4'h0;
            b = 4'h0;
            cin = 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 4'h0);
        end
        endtask

    task testcase008;

        begin
            $display("\nTestcase 008: Verify Synchronous Reset behavior");
            reset_dut();
            a = 4'h8;
            b = 4'h8;
            cin = 1'b0;
            @(posedge clk);
            #1;

            rst = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 4'h0);
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
        input expected_cout;
        input [3:0] expected_sum;
        begin
            if (expected_cout === (expected_cout ^ cout ^ expected_cout) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: cout=%b, sum=%h",
                         cout, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cout=%b, sum=%h",
                         expected_cout, expected_sum);
                $display("  Got:      cout=%b, sum=%h",
                         cout, sum);
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
        $dumpvars(0,a, b, cin, clk, rst, cout, sum);
    end

endmodule
