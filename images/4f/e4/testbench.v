`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg a;
    reg b;
    reg clk;
    reg [3:0] in;
    reg reset;
    wire final_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .in(in),
        .reset(reset),
        .final_out(final_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            a = 0;
            b = 0;
            in = 4'b0000;
            @(posedge clk);
            #2 reset = 0;
            $display("DUT Reset sequence completed.");
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset and All Zeros", test_num);
            reset_dut();
            in = 4'b0000; a = 0; b = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(calc_expected(4'b0000, 0, 0));
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones Input", test_num);
            reset_dut();
            in = 4'b1111; a = 0; b = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(calc_expected(4'b1111, 0, 0));
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Control Signal A High", test_num);
            reset_dut();
            in = 4'b1010; a = 1; b = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(calc_expected(4'b1010, 1, 0));
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Control Signal B High", test_num);
            reset_dut();
            in = 4'b0101; a = 0; b = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(calc_expected(4'b0101, 0, 1));
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Both Controls High", test_num);
            reset_dut();
            in = 4'b1100; a = 1; b = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(calc_expected(4'b1100, 1, 1));
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Odd Parity Input", test_num);
            reset_dut();
            in = 4'b1110; a = 0; b = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(calc_expected(4'b1110, 0, 0));
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
        input expected_final_out;
        begin
            if (expected_final_out === (expected_final_out ^ final_out ^ expected_final_out)) begin
                $display("PASS");
                $display("  Outputs: final_out=%b",
                         final_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: final_out=%b",
                         expected_final_out);
                $display("  Got:      final_out=%b",
                         final_out);
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
        $dumpvars(0,a, b, clk, in, reset, final_out);
    end

endmodule
