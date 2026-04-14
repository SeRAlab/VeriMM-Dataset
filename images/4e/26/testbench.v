`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] parallel_input;
    reg parallel_load;
    reg reset;
    reg shift_left;
    reg shift_right;
    wire [3:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .parallel_input(parallel_input),
        .parallel_load(parallel_load),
        .reset(reset),
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
        reset = 1;
        parallel_load = 0;
        shift_left = 0;
        shift_right = 0;
        parallel_input = 0;
        @(posedge clk);
        #1;
        reset = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Verify Reset", test_num);
        reset_dut();
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Parallel Load (4'hA)", test_num);
        reset_dut();
        parallel_load = 1;
        parallel_input = 4'hA;
        @(posedge clk);
        #1;
        parallel_load = 0;
        #1;

        check_outputs(4'hA);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Shift Left (Load 1, Shift 1)", test_num);
        reset_dut();

        parallel_load = 1;
        parallel_input = 4'b0001;
        @(posedge clk);
        #1;

        parallel_load = 0;
        shift_left = 1;
        @(posedge clk);
        #1;
        shift_left = 0;
        #1;

        check_outputs(4'b0010);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Shift Right (Load 8, Shift 1)", test_num);
        reset_dut();

        parallel_load = 1;
        parallel_input = 4'b1000;
        @(posedge clk);
        #1;

        parallel_load = 0;
        shift_right = 1;
        @(posedge clk);
        #1;
        shift_right = 0;
        #1;

        check_outputs(4'b0100);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Shift Left 3 times (Load 1)", test_num);
        reset_dut();

        parallel_load = 1;
        parallel_input = 4'b0001;
        @(posedge clk);
        #1;

        parallel_load = 0;
        shift_left = 1;
        repeat(3) @(posedge clk);
        #1;
        shift_left = 0;
        #1;

        check_outputs(4'b1000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Shift Right 3 times (Load 8)", test_num);
        reset_dut();

        parallel_load = 1;
        parallel_input = 4'b1000;
        @(posedge clk);
        #1;

        parallel_load = 0;
        shift_right = 1;
        repeat(3) @(posedge clk);
        #1;
        shift_right = 0;
        #1;

        check_outputs(4'b0001);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Shift Left 4 times (Load F -> Should be 0)", test_num);
        reset_dut();
        parallel_load = 1;
        parallel_input = 4'hF;
        @(posedge clk);
        #1;
        parallel_load = 0;
        shift_left = 1;
        repeat(4) @(posedge clk);
        #1;
        shift_left = 0;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Shift Right 4 times (Load F -> Should be 0)", test_num);
        reset_dut();
        parallel_load = 1;
        parallel_input = 4'hF;
        @(posedge clk);
        #1;
        parallel_load = 0;
        shift_right = 1;
        repeat(4) @(posedge clk);
        #1;
        shift_right = 0;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Priority Check (Load vs Shift)", test_num);
        reset_dut();
        parallel_load = 1;
        parallel_input = 4'hC;
        shift_left = 1;
        @(posedge clk);
        #1;
        parallel_load = 0;
        shift_left = 0;
        #1;

        check_outputs(4'hC);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: Reset Priority over Load", test_num);
        reset_dut();
        reset = 1;
        parallel_load = 1;
        parallel_input = 4'hF;
        @(posedge clk);
        #1;
        reset = 0;
        parallel_load = 0;
        #1;

        check_outputs(4'b0000);
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
        input [3:0] expected_q;
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
        $dumpvars(0,clk, parallel_input, parallel_load, reset, shift_left, shift_right, q);
    end

endmodule
