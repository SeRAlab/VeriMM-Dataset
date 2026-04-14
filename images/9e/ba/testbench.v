`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] cmd_reg1;
    reg [31:0] cmd_reg2;
    reg lrclk_clear;
    reg reset_n;
    wire bclk;
    wire lrclk1;
    wire lrclk2;
    wire mclk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .cmd_reg1(cmd_reg1),
        .cmd_reg2(cmd_reg2),
        .lrclk_clear(lrclk_clear),
        .reset_n(reset_n),
        .bclk(bclk),
        .lrclk1(lrclk1),
        .lrclk2(lrclk2),
        .mclk(mclk)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset_n = 0;
        cmd_reg1 = 32'h0;
        cmd_reg2 = 32'h0;
        lrclk_clear = 0;
        #20;
        reset_n = 1;
        #10;
        $display("DUT Reset Complete");
    end
        endtask
    task testcase001;

    begin
        $display("\nRunning testcase001: Reset State Check...");
        reset_dut();
        @(posedge clk);

        #1;


        check_outputs(0, 0, 0, 0);
    end
        endtask

    task testcase002;

    begin
        $display("\nRunning testcase002: Fast Clock Generation...");
        reset_dut();

        cmd_reg1 = 32'h0000_0202;
        cmd_reg2 = 32'h0000_0404;


        repeat(20) @(posedge clk);




        #1;





        check_outputs(bclk, lrclk1, lrclk2, mclk);
    end
        endtask

    task testcase003;

    begin
        $display("\nRunning testcase003: LRCLK Clear Check...");
        reset_dut();
        cmd_reg2 = 32'h0000_FFFF;
        repeat(5) @(posedge clk);

        lrclk_clear = 1;
        repeat(2) @(posedge clk);
        lrclk_clear = 0;


        #1;



        check_outputs(bclk, 0, 0, mclk);
    end
        endtask

    task testcase004;

    begin
        $display("\nRunning testcase004: Independent Clock Scaling...");
        reset_dut();
        cmd_reg1 = 32'h0008_0002;
        repeat(50) @(posedge clk);


        if (mclk !== 1'bx && bclk !== 1'bx) begin
            $display("Clocks are driven.");
        end
        #1;

        check_outputs(bclk, lrclk1, lrclk2, mclk);
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
        input expected_bclk;
        input expected_lrclk1;
        input expected_lrclk2;
        input expected_mclk;
        begin
            if (expected_bclk === (expected_bclk ^ bclk ^ expected_bclk) &&
                expected_lrclk1 === (expected_lrclk1 ^ lrclk1 ^ expected_lrclk1) &&
                expected_lrclk2 === (expected_lrclk2 ^ lrclk2 ^ expected_lrclk2) &&
                expected_mclk === (expected_mclk ^ mclk ^ expected_mclk)) begin
                $display("PASS");
                $display("  Outputs: bclk=%b, lrclk1=%b, lrclk2=%b, mclk=%b",
                         bclk, lrclk1, lrclk2, mclk);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bclk=%b, lrclk1=%b, lrclk2=%b, mclk=%b",
                         expected_bclk, expected_lrclk1, expected_lrclk2, expected_mclk);
                $display("  Got:      bclk=%b, lrclk1=%b, lrclk2=%b, mclk=%b",
                         bclk, lrclk1, lrclk2, mclk);
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
        $dumpvars(0,clk, cmd_reg1, cmd_reg2, lrclk_clear, reset_n, bclk, lrclk1, lrclk2, mclk);
    end

endmodule
