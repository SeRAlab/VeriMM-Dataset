`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ButtonIn;
    reg clk;
    reg rst;
    wire ButtonOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ButtonIn(ButtonIn),
        .clk(clk),
        .rst(rst),
        .ButtonOut(ButtonOut)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            ButtonIn = 0;
            #20;
            rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Button Press", test_num);
            reset_dut();
            ButtonIn = 1;
            #10000;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Button Release", test_num);
            reset_dut();

            ButtonIn = 1;
            #10000;

            ButtonIn = 0;
            #10000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Glitch Rejection (Short Pulse)", test_num);
            reset_dut();

            for (i = 0; i < 10; i = i + 1) begin
                ButtonIn = 1; #20;
                ButtonIn = 0; #20;
            end
            #5000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bouncy Press Handling", test_num);
            reset_dut();

            for (i = 0; i < 5; i = i + 1) begin
                ButtonIn = 1; #50;
                ButtonIn = 0; #50;
            end

            ButtonIn = 1;
            #10000;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bouncy Release Handling", test_num);
            reset_dut();

            ButtonIn = 1;
            #10000;

            for (i = 0; i < 5; i = i + 1) begin
                ButtonIn = 0; #50;
                ButtonIn = 1; #50;
            end

            ButtonIn = 0;
            #10000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Mid-Operation", test_num);
            reset_dut();
            ButtonIn = 1;
            #10000;
            rst = 1;
            #50;
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
        input expected_ButtonOut;
        begin
            if (expected_ButtonOut === (expected_ButtonOut ^ ButtonOut ^ expected_ButtonOut)) begin
                $display("PASS");
                $display("  Outputs: ButtonOut=%b",
                         ButtonOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ButtonOut=%b",
                         expected_ButtonOut);
                $display("  Got:      ButtonOut=%b",
                         ButtonOut);
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
        $dumpvars(0,ButtonIn, clk, rst, ButtonOut);
    end

endmodule
