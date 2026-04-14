`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] e_init;
    reg [7:0] e_input;
    reg [15:0] g_init;
    reg [15:0] g_input;
    reg [7:0] p_init;
    reg [31:0] p_input;
    reg rst;
    wire [31:0] o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .e_init(e_init),
        .e_input(e_input),
        .g_init(g_init),
        .g_input(g_input),
        .p_init(p_init),
        .p_input(p_input),
        .rst(rst),
        .o(o)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        @(posedge clk);
        #1;
        rst = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Basic Initialization", test_num);
        e_init = 32'h12345678;
        g_init = 16'hABCD;
        p_init = 8'hFF;
        e_input = 8'h00;
        g_input = 16'h0000;
        p_input = 32'h00000000;
        reset_dut();

        #1;


        check_outputs(32'h12345678 ^ 16'hABCD ^ 8'hFF);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Single Cycle Processing", test_num);
        e_init = 32'h00000000;
        g_init = 16'h0000;
        p_init = 8'h00;
        reset_dut();

        e_input = 8'hAA;
        g_input = 16'hBBBB;
        p_input = 32'hCCCCCCCC;
        @(posedge clk);
        #1;

        #1;


        check_outputs(32'h000000AA ^ 16'hBBBB ^ 32'hCCCCCCCC);
    end
        endtask

    task testcase003;

    reg [31:0] expect_e, expect_p;
    reg [15:0] expect_g;
    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Multiple Cycle Processing", test_num);
        expect_e = 32'hA5A5A5A5; expect_g = 16'h5555; expect_p = 8'h55;
        e_init = expect_e; g_init = expect_g; p_init = expect_p;
        reset_dut();


        e_input = 8'h01; g_input = 16'h0001; p_input = 32'h00000001;
        expect_e = expect_e ^ 8'h01; expect_g = expect_g ^ 16'h0001; expect_p = expect_p ^ 32'h00000001;
        @(posedge clk);


        #1;
        e_input = 8'hFF; g_input = 16'hFFFF; p_input = 32'hFFFFFFFF;
        expect_e = expect_e ^ 8'hFF; expect_g = expect_g ^ 16'hFFFF; expect_p = expect_p ^ 32'hFFFFFFFF;
        @(posedge clk);

        #1;
        #1;

        check_outputs(expect_e ^ expect_g ^ expect_p);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: All Zeros", test_num);
        e_init = 0; g_init = 0; p_init = 0;
        reset_dut();
        e_input = 0; g_input = 0; p_input = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Reset Override", test_num);

        e_init = 32'hFFFFFFFF; g_init = 16'hFFFF; p_init = 8'hFF;
        reset_dut();


        e_input = 8'h55; g_input = 16'h5555; p_input = 32'h55555555;
        @(posedge clk);


        #1;
        e_init = 32'h11223344; g_init = 16'h5566; p_init = 8'h77;
        reset_dut();

        #1;


        check_outputs(32'h11223344 ^ 16'h5566 ^ 8'h77);
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
        input [31:0] expected_o;
        begin
            if (expected_o === (expected_o ^ o ^ expected_o)) begin
                $display("PASS");
                $display("  Outputs: o=%h",
                         o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o=%h",
                         expected_o);
                $display("  Got:      o=%h",
                         o);
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
        $dumpvars(0,clk, e_init, e_input, g_init, g_input, p_init, p_input, rst, o);
    end

endmodule
