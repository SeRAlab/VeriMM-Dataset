`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data;
    reg reset;
    wire out;
    wire [3:0] shift_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .reset(reset),
        .out(out),
        .shift_out(shift_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data = 0;
            @(posedge clk);
            #1;
            reset = 0;

        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Reset verification", test_num);
            reset_dut();
            data = 4'b0000;
            #2;
            #1;

            check_outputs(1'b1, 4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Load 1010 and check match", test_num);
            reset_dut();
            data = 4'b1010;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 4'b1010);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Check mismatch (Stored: 1010, Data: 0101)", test_num);
            reset_dut();
            data = 4'b1010;
            @(posedge clk);
            #1;
            data = 4'b0101;
            #2;
            #1;

            check_outputs(1'b0, 4'b1010);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Boundary check all bits high (1111)", test_num);
            reset_dut();
            data = 4'b1111;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 4'b1111);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Boundary check all bits low (0000)", test_num);
            reset_dut();
            data = 4'b1111;
            @(posedge clk);
            data = 4'b0000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 4'b0000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Sequential change check", test_num);
            reset_dut();
            data = 4'b1100;
            @(posedge clk);
            data = 4'b0011;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 4'b0011);
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
        input expected_out;
        input [3:0] expected_shift_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out) &&
                expected_shift_out === (expected_shift_out ^ shift_out ^ expected_shift_out)) begin
                $display("PASS");
                $display("  Outputs: out=%b, shift_out=%h",
                         out, shift_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b, shift_out=%h",
                         expected_out, expected_shift_out);
                $display("  Got:      out=%b, shift_out=%h",
                         out, shift_out);
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
        $dumpvars(0,clk, data, reset, out, shift_out);
    end

endmodule
