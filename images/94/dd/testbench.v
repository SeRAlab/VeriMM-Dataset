`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg sig;
    wire [13:0] f;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .sig(sig),
        .f(f)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        sig = 0;
        repeat(2000) @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Zero Frequency Signal", test_num);
        reset_dut();

        repeat(1200) @(posedge clk);
        #1;
        #1;

        check_outputs(14'd0);
    end
        endtask

    task testcase002;

    integer i;
    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Low Frequency (10 pulses)", test_num);
        reset_dut();


        for (i = 0; i < 10; i = i + 1) begin
            sig = 1; repeat(50) @(posedge clk);
            sig = 0; repeat(50) @(posedge clk);
        end

        repeat(1200) @(posedge clk);
        #1;
        #1;

        check_outputs(14'd10);
    end
        endtask

    task testcase003;

    integer i;
    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Medium Frequency (100 pulses)", test_num);
        reset_dut();


        for (i = 0; i < 100; i = i + 1) begin
            sig = 1; repeat(5) @(posedge clk);
            sig = 0; repeat(5) @(posedge clk);
        end

        repeat(1200) @(posedge clk);
        #1;
        #1;

        check_outputs(14'd100);
    end
        endtask

    task testcase004;

    integer i;
    begin
        test_num = test_num + 1;
        $display("Test Case %03d: High Frequency (250 pulses)", test_num);
        reset_dut();


        for (i = 0; i < 250; i = i + 1) begin
            sig = 1; repeat(2) @(posedge clk);
            sig = 0; repeat(2) @(posedge clk);
        end

        repeat(1200) @(posedge clk);
        #1;
        #1;

        check_outputs(14'd250);
    end
        endtask

    task testcase005;

    integer i;
    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Asymmetrical Signal (50 pulses)", test_num);
        reset_dut();

        for (i = 0; i < 50; i = i + 1) begin
            sig = 1; repeat(5)  @(posedge clk);
            sig = 0; repeat(15) @(posedge clk);
        end

        repeat(1200) @(posedge clk);
        #1;
        #1;

        check_outputs(14'd50);
    end
        endtask

    task testcase006;

    integer i;
    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Maximum Frequency Signal (500 pulses)", test_num);
        reset_dut();

        for (i = 0; i < 500; i = i + 1) begin
            sig = 1; @(posedge clk);
            sig = 0; @(posedge clk);
        end

        repeat(1200) @(posedge clk);
        #1;
        #1;

        check_outputs(14'd500);
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
        input [13:0] expected_f;
        begin
            if (expected_f === (expected_f ^ f ^ expected_f)) begin
                $display("PASS");
                $display("  Outputs: f=%h",
                         f);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: f=%h",
                         expected_f);
                $display("  Got:      f=%h",
                         f);
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
        $dumpvars(0,clk, sig, f);
    end

endmodule
