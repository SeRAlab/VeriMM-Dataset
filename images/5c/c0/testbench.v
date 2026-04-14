`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [4:0] D;
    reg clk;
    reg en;
    reg rst;
    wire [4:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D(D),
        .clk(clk),
        .en(en),
        .rst(rst),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        en = 0;
        D = 5'b00000;
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
        $display("Testcase %0d: Verifying Reset State", test_num);
        reset_dut();

        #1;


        check_outputs(5'b00000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Basic Right Shift (11111 -> 01111)", test_num);
        reset_dut();
        D = 5'b11111;
        en = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(5'b01111);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: MSB to LSB shift (10001 -> 01000)", test_num);
        reset_dut();
        D = 5'b10001;
        en = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(5'b01000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Enable signal inactive (Hold 0)", test_num);
        reset_dut();
        D = 5'b11111;
        en = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(5'b00000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Reset priority over Enable", test_num);
        reset_dut();
        D = 5'b11111;
        en = 1;
        rst = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(5'b00000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Pattern Shift (10101 -> 01010)", test_num);
        reset_dut();
        D = 5'b10101;
        en = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(5'b01010);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Hold previous shifted value", test_num);
        reset_dut();

        D = 5'b11000;
        en = 1;
        @(posedge clk);
        #1;

        en = 0;
        D = 5'b00000;
        @(posedge clk);
        #1;
        #1;

        check_outputs(5'b01100);
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
        input [4:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,D, clk, en, rst, Q);
    end

endmodule
