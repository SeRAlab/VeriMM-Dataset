`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] a1;
    reg [1:0] a2;
    reg [1:0] a3;
    reg [1:0] a4;
    reg [1:0] a5;
    reg [1:0] a6;
    reg clk;
    reg [26:0] din1;
    reg [3:0] din2;
    reg [3:0] din3;
    reg [3:0] off1;
    reg [3:0] off2;
    reg rst;
    wire [3:0] dout1;
    wire [3:0] dout2;
    wire [26:0] dout3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a1(a1),
        .a2(a2),
        .a3(a3),
        .a4(a4),
        .a5(a5),
        .a6(a6),
        .clk(clk),
        .din1(din1),
        .din2(din2),
        .din3(din3),
        .off1(off1),
        .off2(off2),
        .rst(rst),
        .dout1(dout1),
        .dout2(dout2),
        .dout3(dout3)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        a1 = 0; a2 = 0; a3 = 0; a4 = 0; a5 = 0; a6 = 0;
        off1 = 0; off2 = 0;
        din1 = 0; din2 = 0; din3 = 0;
        #20;
        rst = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Verifying reset state", test_num);

        #1;


        check_outputs(4'h0, 4'h0, 27'h0);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Bank A (27-bit) Write/Read Address 2", test_num);
        a1 = 2'd2;
        din1 = 27'h5A5A5A5;
        @(posedge clk);
        #2;
        a6 = 2'd2;
        #1;
        #1;

        check_outputs(4'h0, 4'h0, 27'h5A5A5A5);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Bank B and C Basic Write/Read", test_num);

        a2 = 2'd1;
        din2 = 4'hA;
        a3 = 2'd1;
        din3 = 4'h5;
        @(posedge clk);
        #2;

        a4 = 2'd1;
        a5 = 2'd1;
        off1 = 4'h0;
        off2 = 4'h0;
        #1;
        #1;

        check_outputs(4'hA, 4'h5, 27'h0);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Persistence and multi-address test", test_num);

        a1 = 2'd0; din1 = 27'h1111111;
        a1 = 2'd3; din1 = 27'h7FFFFFF;
        @(posedge clk); #5;
        a1 = 2'd3; din1 = 27'h7FFFFFF;
        @(posedge clk); #5;


        a6 = 2'd3;
        #1;
        #1;

        check_outputs(4'h0, 4'h0, 27'h7FFFFFF);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Offset Addition Test", test_num);


        a2 = 2'd3; din2 = 4'h2;
        a3 = 2'd3; din3 = 4'h4;
        @(posedge clk);
        #2;


        a4 = 2'd3; off1 = 4'h3;
        a5 = 2'd3; off2 = 4'h8;
        #1;
        #1;

        check_outputs(4'h5, 4'hC, 27'h0);
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
        input [3:0] expected_dout1;
        input [3:0] expected_dout2;
        input [26:0] expected_dout3;
        begin
            if (expected_dout1 === (expected_dout1 ^ dout1 ^ expected_dout1) &&
                expected_dout2 === (expected_dout2 ^ dout2 ^ expected_dout2) &&
                expected_dout3 === (expected_dout3 ^ dout3 ^ expected_dout3)) begin
                $display("PASS");
                $display("  Outputs: dout1=%h, dout2=%h, dout3=%h",
                         dout1, dout2, dout3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout1=%h, dout2=%h, dout3=%h",
                         expected_dout1, expected_dout2, expected_dout3);
                $display("  Got:      dout1=%h, dout2=%h, dout3=%h",
                         dout1, dout2, dout3);
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
        $dumpvars(0,a1, a2, a3, a4, a5, a6, clk, din1, din2, din3, off1, off2, rst, dout1, dout2, dout3);
    end

endmodule
