`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg cin;
    reg clk;
    reg reset;
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
        .reset(reset),
        .sum(sum)
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
        cin = 0;
        @(posedge clk);
        #1;
        reset = 0;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        a = 4'd4;
        b = 4'd2;
        cin = 0;
        @(posedge clk);
        #1;
        test_num = test_num + 1;
        $display("Testcase %0d: 4 + 2 (No Cin)", test_num);
        #1;

        check_outputs(4'd6);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        a = 4'd5;
        b = 4'd3;
        cin = 1;
        @(posedge clk);
        #1;
        test_num = test_num + 1;
        $display("Testcase %0d: 5 + 3 + 1 (With Cin)", test_num);
        #1;

        check_outputs(4'd9);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        a = 4'hF;
        b = 4'h1;
        cin = 0;
        @(posedge clk);
        #1;
        test_num = test_num + 1;
        $display("Testcase %0d: 15 + 1 (Overflow wrap to 0)", test_num);
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        a = 4'hF;
        b = 4'hF;
        cin = 1;
        @(posedge clk);
        #1;
        test_num = test_num + 1;
        $display("Testcase %0d: 15 + 15 + 1 (Max sum bits)", test_num);
        #1;

        check_outputs(4'hF);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        a = 4'h5;
        b = 4'h5;
        cin = 0;
        reset = 1;
        @(posedge clk);
        #1;
        test_num = test_num + 1;
        $display("Testcase %0d: Reset while adding (Should output 0)", test_num);
        #1;

        check_outputs(4'h0);
        reset = 0;
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        a = 4'h0;
        b = 4'h0;
        cin = 0;
        @(posedge clk);
        #1;
        test_num = test_num + 1;
        $display("Testcase %0d: 0 + 0 + 0", test_num);
        #1;

        check_outputs(4'h0);
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
        input [3:0] expected_sum;
        begin
            if (expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: sum=%h",
                         sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sum=%h",
                         expected_sum);
                $display("  Got:      sum=%h",
                         sum);
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
        $dumpvars(0,a, b, cin, clk, reset, sum);
    end

endmodule
