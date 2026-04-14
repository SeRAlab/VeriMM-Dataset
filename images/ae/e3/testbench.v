`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg down;
    reg set_ena;
    reg up;
    wire [3:0] BCD_out_next;
    wire TC;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .down(down),
        .set_ena(set_ena),
        .up(up),
        .BCD_out_next(BCD_out_next),
        .TC(TC)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        set_ena = 0;
        up = 1;
        down = 0;
        repeat(10) @(posedge clk);
        set_ena = 1;
        up = 1;
        down = 1;
        #2;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Increment 0 to 1", test_num);
        reset_dut();
        set_ena = 0;
        up = 0;
        down = 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(4'h1, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Count up to 9 (TC check)", test_num);
        reset_dut();
        set_ena = 0;
        up = 0;
        down = 1;
        repeat(9) @(posedge clk);
        #2;
        #1;

        check_outputs(4'h9, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Wrap-around 9 back to 0", test_num);
        reset_dut();
        set_ena = 0;
        up = 0;
        down = 1;
        repeat(10) @(posedge clk);
        #2;
        #1;

        check_outputs(4'h0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Wrap-around 0 down to 9 (TC check)", test_num);
        reset_dut();
        set_ena = 0;
        up = 1;
        down = 0;
        @(posedge clk);
        #2;
        #1;

        check_outputs(4'h9, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Check set_ena disables counting", test_num);
        reset_dut();

        set_ena = 0; up = 0; down = 1;
        repeat(5) @(posedge clk);

        set_ena = 1;
        repeat(3) @(posedge clk);
        #2;
        #1;

        check_outputs(4'h5, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Decrement from 3 to 1", test_num);
        reset_dut();

        set_ena = 0; up = 0; down = 1;
        repeat(3) @(posedge clk);

        up = 1; down = 0;
        repeat(2) @(posedge clk);
        #2;
        #1;

        check_outputs(4'h1, 1'b0);
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
        input [3:0] expected_BCD_out_next;
        input expected_TC;
        begin
            if (expected_BCD_out_next === (expected_BCD_out_next ^ BCD_out_next ^ expected_BCD_out_next) &&
                expected_TC === (expected_TC ^ TC ^ expected_TC)) begin
                $display("PASS");
                $display("  Outputs: BCD_out_next=%h, TC=%b",
                         BCD_out_next, TC);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: BCD_out_next=%h, TC=%b",
                         expected_BCD_out_next, expected_TC);
                $display("  Got:      BCD_out_next=%h, TC=%b",
                         BCD_out_next, TC);
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
        $dumpvars(0,clk, down, set_ena, up, BCD_out_next, TC);
    end

endmodule
