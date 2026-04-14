`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg resetn;
    wire [3:0] a_out;
    wire [3:0] b_out;
    wire [3:0] c_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .resetn(resetn),
        .a_out(a_out),
        .b_out(b_out),
        .c_out(c_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            resetn = 0;
            repeat(2) @(negedge clk);
            resetn = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %03d: Initial Reset State", test_num);
            reset_dut();




            #1;





            check_outputs(4'd0, 4'd0, 4'd1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %03d: State after 2nd edge", test_num);
            reset_dut();
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'd1, 4'd1, 4'd2);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %03d: State after 3rd edge", test_num);
            reset_dut();
            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(4'd2, 4'd2, 4'd2);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %03d: Saturation Check (Count = 10)", test_num);
            reset_dut();
            repeat(9) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd2, 4'd2, 4'd2);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %03d: Mid-operation Reset", test_num);
            reset_dut();
            repeat(5) @(posedge clk);
            @(negedge clk);
            resetn = 0;
            #2;
            #1;

            check_outputs(4'd0, 4'd0, 4'd0);
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
        input [3:0] expected_a_out;
        input [3:0] expected_b_out;
        input [3:0] expected_c_out;
        begin
            if (expected_a_out === (expected_a_out ^ a_out ^ expected_a_out) &&
                expected_b_out === (expected_b_out ^ b_out ^ expected_b_out) &&
                expected_c_out === (expected_c_out ^ c_out ^ expected_c_out)) begin
                $display("PASS");
                $display("  Outputs: a_out=%h, b_out=%h, c_out=%h",
                         a_out, b_out, c_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: a_out=%h, b_out=%h, c_out=%h",
                         expected_a_out, expected_b_out, expected_c_out);
                $display("  Got:      a_out=%h, b_out=%h, c_out=%h",
                         a_out, b_out, c_out);
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
        $dumpvars(0,clk, resetn, a_out, b_out, c_out);
    end

endmodule
