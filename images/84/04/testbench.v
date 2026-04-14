`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg input_signal;
    wire pulse_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .input_signal(input_signal),
        .pulse_signal(pulse_signal)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            input_signal = 0;
            @(negedge clk);
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Pulse Start Verification", test_num);
            reset_dut();
            @(posedge clk);
            input_signal <= 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Pulse Termination Verification", test_num);
            reset_dut();
            @(posedge clk);
            input_signal <= 1;
            @(posedge clk);
            input_signal <= 0;

            repeat(PW) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Sustained Input Signal Test", test_num);
            reset_dut();
            @(posedge clk);
            input_signal <= 1;
            repeat(PW + 1) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Ignore Input while Pulse Active Test", test_num);
            reset_dut();
            @(posedge clk);
            input_signal <= 1;
            @(posedge clk);
            input_signal <= 0;
            @(posedge clk);
            input_signal <= 1;
            repeat(PW - 1) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Sequential Pulse Triggering Test", test_num);
            reset_dut();

            @(posedge clk);
            input_signal <= 1;
            @(posedge clk);
            input_signal <= 0;
            repeat(PW + 1) @(posedge clk);


            @(posedge clk);
            input_signal <= 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
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
        input expected_pulse_signal;
        begin
            if (expected_pulse_signal === (expected_pulse_signal ^ pulse_signal ^ expected_pulse_signal)) begin
                $display("PASS");
                $display("  Outputs: pulse_signal=%b",
                         pulse_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pulse_signal=%b",
                         expected_pulse_signal);
                $display("  Got:      pulse_signal=%b",
                         pulse_signal);
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
        $dumpvars(0,clk, input_signal, pulse_signal);
    end

endmodule
