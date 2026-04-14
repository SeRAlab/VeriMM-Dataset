`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] PWM_input;
    reg clk;
    reg input2;
    wire LED;
    wire a;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .PWM_input(PWM_input),
        .clk(clk),
        .input2(input2),
        .LED(LED),
        .a(a)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            PWM_input = 0;
            input2 = 0;

            repeat(2) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Zero PWM Input", test_num);
            reset_dut();
            PWM_input = 0;
            input2 = 0;
            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Passthrough Input2 to 'a'", test_num);
            reset_dut();
            PWM_input = 0;
            input2 = 1;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Accumulation threshold (16)", test_num);
            reset_dut();
            input2 = 0;
            PWM_input = 4;

            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Accumulator wrap-around", test_num);
            reset_dut();
            input2 = 1;
            PWM_input = 8;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: High PWM value accumulation", test_num);
            reset_dut();
            input2 = 0;
            PWM_input = 15;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(1, 0);
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
        input expected_LED;
        input expected_a;
        begin
            if (expected_LED === (expected_LED ^ LED ^ expected_LED) &&
                expected_a === (expected_a ^ a ^ expected_a)) begin
                $display("PASS");
                $display("  Outputs: LED=%b, a=%b",
                         LED, a);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: LED=%b, a=%b",
                         expected_LED, expected_a);
                $display("  Got:      LED=%b, a=%b",
                         LED, a);
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
        $dumpvars(0,PWM_input, clk, input2, LED, a);
    end

endmodule
