`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] D;
    reg clock;
    reg load;
    reg reset;
    reg shift_left;
    reg shift_right;
    wire [3:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D(D),
        .clock(clock),
        .load(load),
        .reset(reset),
        .shift_left(shift_left),
        .shift_right(shift_right),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            @(negedge clock);
            reset = 1;
            load = 0;
            shift_left = 0;
            shift_right = 0;
            D = 4'b0000;
            @(negedge clock);
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Reset", test_num);
            reset_dut();
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Parallel Load 4'hA", test_num);
            reset_dut();
            @(negedge clock);
            D = 4'b1010;
            load = 1;
            @(negedge clock);
            load = 0;
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Shift Left (0001 -> 0010)", test_num);
            reset_dut();

            @(negedge clock);
            D = 4'b0001;
            load = 1;
            @(negedge clock);
            load = 0;
            shift_left = 1;
            @(negedge clock);
            shift_left = 0;
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Shift Right (1000 -> 0100)", test_num);
            reset_dut();

            @(negedge clock);
            D = 4'b1000;
            load = 1;
            @(negedge clock);
            load = 0;
            shift_right = 1;
            @(negedge clock);
            shift_right = 0;
            #1;

            check_outputs(4'b0100);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Multiple Shift Lefts (0011 -> 1100)", test_num);
            reset_dut();
            @(negedge clock);
            D = 4'b0011;
            load = 1;
            @(negedge clock);
            load = 0;
            shift_left = 1;
            repeat(2) @(negedge clock);
            shift_left = 0;
            #1;

            check_outputs(4'b1100);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Multiple Shift Rights (1100 -> 0011)", test_num);
            reset_dut();
            @(negedge clock);
            D = 4'b1100;
            load = 1;
            @(negedge clock);
            load = 0;
            shift_right = 1;
            repeat(2) @(negedge clock);
            shift_right = 0;
            #1;

            check_outputs(4'b0011);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Load Priority check", test_num);
            reset_dut();
            @(negedge clock);
            D = 4'b0101;
            load = 1;
            shift_left = 1;
            shift_right = 1;
            @(negedge clock);
            load = 0;
            shift_left = 0;
            shift_right = 0;
            #1;

            check_outputs(4'b0101);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Hold value", test_num);
            reset_dut();
            @(negedge clock);
            D = 4'b1111;
            load = 1;
            @(negedge clock);
            load = 0;
            repeat(2) @(negedge clock);
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test Case %0d: Shift Left Overflow", test_num);
            reset_dut();
            @(negedge clock);
            D = 4'b1000;
            load = 1;
            @(negedge clock);
            load = 0;
            shift_left = 1;
            @(negedge clock);
            shift_left = 0;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test Case %0d: Shift Right Underflow", test_num);
            reset_dut();
            @(negedge clock);
            D = 4'b0001;
            load = 1;
            @(negedge clock);
            load = 0;
            shift_right = 1;
            @(negedge clock);
            shift_right = 0;
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
        input [3:0] expected_Q;
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
        $dumpvars(0,D, clock, load, reset, shift_left, shift_right, Q);
    end

endmodule
