`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg btn_input;
    reg clk;
    wire btn_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .btn_input(btn_input),
        .clk(clk),
        .btn_output(btn_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            btn_input = 0;

            wait_cycles(20);
        end
        endtask
    task wait_cycles;

        input integer n;
        begin
            repeat(n) @(posedge clk);
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Testcase %0d: Initial State - Input LOW", test_num);
            wait_cycles(100);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Testcase %0d: Valid Press - Stable HIGH input", test_num);
            btn_input = 1;
            wait_cycles(200);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Testcase %0d: Glitch Suppression - Short pulse", test_num);
            btn_input = 1;
            wait_cycles(5);
            btn_input = 0;
            wait_cycles(150);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Testcase %0d: Mechanical Bouncing - Settling HIGH", test_num);

            btn_input = 1; wait_cycles(2);
            btn_input = 0; wait_cycles(3);
            btn_input = 1; wait_cycles(4);
            btn_input = 0; wait_cycles(2);

            btn_input = 1;
            wait_cycles(200);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Testcase %0d: Valid Release - Stable LOW after stable HIGH", test_num);

            btn_input = 1;
            wait_cycles(200);

            btn_input = 0;
            wait_cycles(200);
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
        input expected_btn_output;
        begin
            if (expected_btn_output === (expected_btn_output ^ btn_output ^ expected_btn_output)) begin
                $display("PASS");
                $display("  Outputs: btn_output=%b",
                         btn_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: btn_output=%b",
                         expected_btn_output);
                $display("  Got:      btn_output=%b",
                         btn_output);
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
        $dumpvars(0,btn_input, clk, btn_output);
    end

endmodule
