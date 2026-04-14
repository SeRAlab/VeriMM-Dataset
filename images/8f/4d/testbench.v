`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] D;
    reg clk;
    reg shift;
    wire Q3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D(D),
        .clk(clk),
        .shift(shift),
        .Q3(Q3)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        D = 4'b0000;
        shift = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Parallel Load 1010", test_num);
        D = 4'b1010;
        shift = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Parallel Load 0111", test_num);
        D = 4'b0111;
        shift = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Shift once (move Q2 to Q3)", test_num);
        D = 4'b0111;
        shift = 0;
        @(posedge clk);
        #1;
        D = 4'b0000;
        shift = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Shift twice (move Q1 to Q3)", test_num);
        D = 4'b0011;
        shift = 0;
        @(posedge clk);
        #1;
        D = 4'b0000;
        shift = 1;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Shift three times (move Q0 to Q3)", test_num);
        D = 4'b0001;
        shift = 0;
        @(posedge clk);
        #1;
        D = 4'b0000;
        shift = 1;
        repeat(3) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Shift in 1s for 4 cycles", test_num);
        D = 4'b0000;
        shift = 0;
        @(posedge clk);
        #1;
        D = 4'b1000;
        shift = 1;
        repeat(4) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Shift in 0s for 4 cycles", test_num);
        D = 4'b1111;
        shift = 0;
        @(posedge clk);
        #1;
        D = 4'b0000;
        shift = 1;
        repeat(4) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
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
        input expected_Q3;
        begin
            if (expected_Q3 === (expected_Q3 ^ Q3 ^ expected_Q3)) begin
                $display("PASS");
                $display("  Outputs: Q3=%b",
                         Q3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q3=%b",
                         expected_Q3);
                $display("  Got:      Q3=%b",
                         Q3);
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
        $dumpvars(0,D, clk, shift, Q3);
    end

endmodule
