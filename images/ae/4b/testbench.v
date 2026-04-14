`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [7:0] load_value;
    reg rst_n;
    reg shift_left;
    reg shift_right;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .load(load),
        .load_value(load_value),
        .rst_n(rst_n),
        .shift_left(shift_left),
        .shift_right(shift_right),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst_n = 0;
        load = 0;
        load_value = 8'h00;
        shift_left = 0;
        shift_right = 0;
        @(posedge clk);
        #1;
        rst_n = 1;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Initial Reset Check", test_num);
        reset_dut();
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Parallel Load 0xAA", test_num);
        reset_dut();
        load = 1;
        load_value = 8'hAA;
        @(posedge clk);
        #1;
        load = 0;
        #1;

        check_outputs(8'hAA);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Shift Left (0x01 -> 0x02)", test_num);
        reset_dut();
        load = 1;
        load_value = 8'h01;
        @(posedge clk);
        #1;
        load = 0;
        shift_left = 1;
        @(posedge clk);
        #1;
        shift_left = 0;
        #1;

        check_outputs(8'h02);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Shift Right (0x80 -> 0x40)", test_num);
        reset_dut();
        load = 1;
        load_value = 8'h80;
        @(posedge clk);
        #1;
        load = 0;
        shift_right = 1;
        @(posedge clk);
        #1;
        shift_right = 0;
        #1;

        check_outputs(8'h40);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Multiple Shift Lefts", test_num);
        reset_dut();
        load = 1;
        load_value = 8'hFF;
        @(posedge clk);
        #1;
        load = 0;
        shift_left = 1;
        repeat (4) @(posedge clk);
        #1;
        shift_left = 0;
        #1;

        check_outputs(8'hF0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Multiple Shift Rights", test_num);
        reset_dut();
        load = 1;
        load_value = 8'hFF;
        @(posedge clk);
        #1;
        load = 0;
        shift_right = 1;
        repeat (4) @(posedge clk);
        #1;
        shift_right = 0;
        #1;

        check_outputs(8'h0F);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Priority Check (Load vs Shift)", test_num);
        reset_dut();
        load = 1;
        load_value = 8'h55;
        shift_left = 1;
        shift_right = 1;
        @(posedge clk);
        #1;
        load = 0;
        shift_left = 0;
        shift_right = 0;
        #1;

        check_outputs(8'h55);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Shift Out All Bits", test_num);
        reset_dut();
        load = 1;
        load_value = 8'hFF;
        @(posedge clk);
        #1;
        load = 0;
        shift_left = 1;
        repeat (8) @(posedge clk);
        #1;
        shift_left = 0;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Bidirectional Shift Sequence", test_num);
        reset_dut();
        load = 1;
        load_value = 8'h01;
        @(posedge clk);
        #1;
        load = 0;
        shift_left = 1;
        @(posedge clk);
        #1;
        shift_left = 0;
        shift_right = 1;
        @(posedge clk);
        #1;
        shift_right = 1;
        @(posedge clk);
        #1;
        shift_right = 0;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: Load Zero then Shift", test_num);
        reset_dut();
        load = 1;
        load_value = 8'h00;
        @(posedge clk);
        #1;
        load = 0;
        shift_left = 1;
        @(posedge clk);
        #1;
        shift_left = 0;
        #1;

        check_outputs(8'h00);
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
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [7:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, load, load_value, rst_n, shift_left, shift_right, q);
    end

endmodule
