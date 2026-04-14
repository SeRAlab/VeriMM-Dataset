`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg in_sign_a;
    reg in_sign_b;
    reg rst;
    wire out_sign;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in_sign_a(in_sign_a),
        .in_sign_b(in_sign_b),
        .rst(rst),
        .out_sign(out_sign)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        in_sign_a = 0;
        in_sign_b = 0;
        @(posedge clk);
        #1;
        rst = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: XOR(0, 0) -> Expected 0", test_num);
        reset_dut();
        in_sign_a = 0;
        in_sign_b = 0;
        @(posedge clk);
        #2;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: XOR(0, 1) -> Expected 1", test_num);
        reset_dut();
        in_sign_a = 0;
        in_sign_b = 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: XOR(1, 0) -> Expected 1", test_num);
        reset_dut();
        in_sign_a = 1;
        in_sign_b = 0;
        @(posedge clk);
        #2;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: XOR(1, 1) -> Expected 0", test_num);
        reset_dut();
        in_sign_a = 1;
        in_sign_b = 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Sequential transitions (1,0)->(1,1) -> Expected 0 at end", test_num);
        reset_dut();

        in_sign_a = 1;
        in_sign_b = 0;
        @(posedge clk);
        #2;

        in_sign_a = 1;
        in_sign_b = 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Reset priority test -> Expected 0", test_num);
        reset_dut();
        in_sign_a = 1;
        in_sign_b = 0;
        rst = 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(0);
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
        input expected_out_sign;
        begin
            if (expected_out_sign === (expected_out_sign ^ out_sign ^ expected_out_sign)) begin
                $display("PASS");
                $display("  Outputs: out_sign=%b",
                         out_sign);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_sign=%b",
                         expected_out_sign);
                $display("  Got:      out_sign=%b",
                         out_sign);
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
        $dumpvars(0,clk, in_sign_a, in_sign_b, rst, out_sign);
    end

endmodule
