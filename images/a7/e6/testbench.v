`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    wire led0;
    wire led1;
    wire led2;
    wire led3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .led0(led0),
        .led1(led1),
        .led2(led2),
        .led3(led3)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            @(posedge clk);
            #1 reset = 0;

        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Reset Functionality", test_num);
            reset_dut();
            @(posedge clk);
            #1;

            #1;


            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Increment to 1", test_num);
            reset_dut();
            @(posedge clk);
            #1;
            #1;

            check_outputs(1, 0, 0, 0);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            $display("Test %0d: Count to 5 (0101)", test_num);
            reset_dut();
            for (i = 0; i < 5; i = i + 1) begin
                @(posedge clk);
            end
            #1;

            #1;


            check_outputs(1, 0, 1, 0);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            $display("Test %0d: Count to 10 (1010)", test_num);
            reset_dut();
            for (i = 0; i < 10; i = i + 1) begin
                @(posedge clk);
            end
            #1;

            #1;


            check_outputs(0, 1, 0, 1);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            $display("Test %0d: Max value 15 (1111)", test_num);
            reset_dut();
            for (i = 0; i < 15; i = i + 1) begin
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(1, 1, 1, 1);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = 6;
            $display("Test %0d: Rollover from 15 to 0", test_num);
            reset_dut();
            for (i = 0; i < 16; i = i + 1) begin
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase007;

        integer i;
        begin
            test_num = 7;
            $display("Test %0d: Wrap around to 3 (19 clocks)", test_num);
            reset_dut();
            for (i = 0; i < 19; i = i + 1) begin
                @(posedge clk);
            end
            #1;

            #1;


            check_outputs(1, 1, 0, 0);
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
        input expected_led0;
        input expected_led1;
        input expected_led2;
        input expected_led3;
        begin
            if (expected_led0 === (expected_led0 ^ led0 ^ expected_led0) &&
                expected_led1 === (expected_led1 ^ led1 ^ expected_led1) &&
                expected_led2 === (expected_led2 ^ led2 ^ expected_led2) &&
                expected_led3 === (expected_led3 ^ led3 ^ expected_led3)) begin
                $display("PASS");
                $display("  Outputs: led0=%b, led1=%b, led2=%b, led3=%b",
                         led0, led1, led2, led3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: led0=%b, led1=%b, led2=%b, led3=%b",
                         expected_led0, expected_led1, expected_led2, expected_led3);
                $display("  Got:      led0=%b, led1=%b, led2=%b, led3=%b",
                         led0, led1, led2, led3);
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
        $dumpvars(0,clk, reset, led0, led1, led2, led3);
    end

endmodule
