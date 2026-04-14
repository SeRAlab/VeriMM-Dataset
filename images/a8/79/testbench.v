`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    wire carry;
    wire [3:0] out;
    wire [6:0] seg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .carry(carry),
        .out(out),
        .seg(seg)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 4'd0, 7'h3f);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Increment to 1", test_num);
            reset_dut();
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 4'd1, 7'h06);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Increment to 5", test_num);
            reset_dut();
            repeat(5) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 4'd5, 7'h6d);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Terminal Count 9 and Carry", test_num);
            reset_dut();
            repeat(9) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 4'd9, 7'h6f);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Wrap-around logic (10 clocks)", test_num);
            reset_dut();
            repeat(10) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 4'd0, 7'h3f);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Multi-cycle wrap (23 clocks)", test_num);
            reset_dut();
            repeat(23) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 4'd3, 7'h4f);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Reset during operation", test_num);
            reset_dut();
            repeat(4) @(posedge clk);
            reset_dut();
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 4'd2, 7'h5b);
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
        input expected_carry;
        input [3:0] expected_out;
        input [6:0] expected_seg;
        begin
            if (expected_carry === (expected_carry ^ carry ^ expected_carry) &&
                expected_out === (expected_out ^ out ^ expected_out) &&
                expected_seg === (expected_seg ^ seg ^ expected_seg)) begin
                $display("PASS");
                $display("  Outputs: carry=%b, out=%h, seg=%h",
                         carry, out, seg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: carry=%b, out=%h, seg=%h",
                         expected_carry, expected_out, expected_seg);
                $display("  Got:      carry=%b, out=%h, seg=%h",
                         carry, out, seg);
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
        $dumpvars(0,clk, reset, carry, out, seg);
    end

endmodule
