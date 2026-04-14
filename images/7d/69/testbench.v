`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg GPIOffffff00_we;
    reg [31:0] Peripheral_in;
    reg clk;
    reg rst;
    wire [21:0] GPIOf0;
    wire [1:0] counter_set;
    wire [7:0] led_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .GPIOffffff00_we(GPIOffffff00_we),
        .Peripheral_in(Peripheral_in),
        .clk(clk),
        .rst(rst),
        .GPIOf0(GPIOf0),
        .counter_set(counter_set),
        .led_out(led_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        GPIOffffff00_we = 0;
        Peripheral_in = 0;
        repeat(2) @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Verifying Reset State", test_num);
        reset_dut();

        #1;


        check_outputs(22'h0, 2'h0, 8'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Basic Write Pattern 0xAAAAAAAA", test_num);
        reset_dut();
        @(posedge clk);
        GPIOffffff00_we = 1;
        Peripheral_in = 32'hAAAAAAAA;
        @(posedge clk);
        #1 GPIOffffff00_we = 0;
        #1;

        check_outputs(22'h2AAAAA, 2'h2, 8'hAA);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Verify Write Enable Gating", test_num);
        reset_dut();


        GPIOffffff00_we = 1;
        Peripheral_in = 32'hFFFFFFFF;
        @(posedge clk);


        #1 GPIOffffff00_we = 0;
        Peripheral_in = 32'h00000000;
        repeat(2) @(posedge clk);


        #1;



        check_outputs(22'h3FFFFF, 2'h3, 8'hFF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Checkerboard Pattern", test_num);
        reset_dut();
        GPIOffffff00_we = 1;
        Peripheral_in = 32'h55555555;
        @(posedge clk);
        #1 GPIOffffff00_we = 0;
        #1;

        check_outputs(22'h155555, 2'h1, 8'h55);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Sequential Writes", test_num);
        reset_dut();
        GPIOffffff00_we = 1;
        Peripheral_in = 32'h12345678;
        @(posedge clk);
        #1 Peripheral_in = 32'h87654321;
        @(posedge clk);
        #1 GPIOffffff00_we = 0;
        #1;

        check_outputs(22'h21D950, 2'h3, 8'h21);
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
        input [21:0] expected_GPIOf0;
        input [1:0] expected_counter_set;
        input [7:0] expected_led_out;
        begin
            if (expected_GPIOf0 === (expected_GPIOf0 ^ GPIOf0 ^ expected_GPIOf0) &&
                expected_counter_set === (expected_counter_set ^ counter_set ^ expected_counter_set) &&
                expected_led_out === (expected_led_out ^ led_out ^ expected_led_out)) begin
                $display("PASS");
                $display("  Outputs: GPIOf0=%h, counter_set=%h, led_out=%h",
                         GPIOf0, counter_set, led_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: GPIOf0=%h, counter_set=%h, led_out=%h",
                         expected_GPIOf0, expected_counter_set, expected_led_out);
                $display("  Got:      GPIOf0=%h, counter_set=%h, led_out=%h",
                         GPIOf0, counter_set, led_out);
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
        $dumpvars(0,GPIOffffff00_we, Peripheral_in, clk, rst, GPIOf0, counter_set, led_out);
    end

endmodule
