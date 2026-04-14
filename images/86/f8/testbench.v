`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg in0;
    reg in1;
    reg in2;
    reg in3;
    reg reset;
    wire [1:0] out;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .reset(reset),
        .out(out),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            in0 = 0;
            in1 = 0;
            in2 = 0;
            in3 = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test %0d: All inputs inactive", test_num);
            @(negedge clk);
            in0 = 0; in1 = 0; in2 = 0; in3 = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(2'b00, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test %0d: in0 active (highest priority)", test_num);
            @(negedge clk);
            in0 = 1; in1 = 0; in2 = 0; in3 = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(2'b00, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test %0d: in1 active", test_num);
            @(negedge clk);
            in0 = 0; in1 = 1; in2 = 0; in3 = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(2'b01, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test %0d: in2 active", test_num);
            @(negedge clk);
            in0 = 0; in1 = 0; in2 = 1; in3 = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(2'b10, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test %0d: in3 active", test_num);
            @(negedge clk);
            in0 = 0; in1 = 0; in2 = 0; in3 = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(2'b11, 1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Test %0d: Multiple inputs (in0 and in3), in0 wins", test_num);
            @(negedge clk);
            in0 = 1; in1 = 0; in2 = 0; in3 = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(2'b00, 1'b1);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Test %0d: Multiple inputs (in1, in2, in3), in1 wins", test_num);
            @(negedge clk);
            in0 = 0; in1 = 1; in2 = 1; in3 = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(2'b01, 1'b1);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            $display("Test %0d: All inputs active, in0 wins", test_num);
            @(negedge clk);
            in0 = 1; in1 = 1; in2 = 1; in3 = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(2'b00, 1'b1);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            test_num = 9;
            $display("Test %0d: Reset while input is active", test_num);
            @(negedge clk);
            in0 = 1;
            reset = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(2'b00, 1'b0);
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
        input [1:0] expected_out;
        input expected_valid;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: out=%h, valid=%b",
                         out, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h, valid=%b",
                         expected_out, expected_valid);
                $display("  Got:      out=%h, valid=%b",
                         out, valid);
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
        $dumpvars(0,clk, in0, in1, in2, in3, reset, out, valid);
    end

endmodule
