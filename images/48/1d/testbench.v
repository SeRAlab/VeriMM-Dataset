`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg aclk;
    reg [1:0] input_signals;
    wire ff_output;
    wire lut_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .aclk(aclk),
        .input_signals(input_signals),
        .ff_output(ff_output),
        .lut_output(lut_output)
    );

    // Clock generation (10ns period)
    initial begin
        aclk = 0;
        forever #5 aclk = ~aclk;
    end

        task reset_dut;

        begin
            input_signals = 2'b00;
            @(posedge aclk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Input 11 (Both High)", test_num);
            reset_dut();
            input_signals = 2'b11;
            @(posedge aclk);
            #2;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Input 00 (Both Low)", test_num);
            reset_dut();
            input_signals = 2'b11;
            @(posedge aclk);
            #1;
            input_signals = 2'b00;
            @(posedge aclk);
            #2;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Input 10", test_num);
            reset_dut();
            input_signals = 2'b10;
            @(posedge aclk);
            #2;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Input 01", test_num);
            reset_dut();
            input_signals = 2'b01;
            @(posedge aclk);
            #2;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Timing Check (Combinational vs Sequential)", test_num);
            reset_dut();
            input_signals = 2'b11;
            @(posedge aclk);
            #2;
            input_signals = 2'b00;
            #2;

            #1;


            check_outputs(1'b1, 1'b0);
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
        input expected_ff_output;
        input expected_lut_output;
        begin
            if (expected_ff_output === (expected_ff_output ^ ff_output ^ expected_ff_output) &&
                expected_lut_output === (expected_lut_output ^ lut_output ^ expected_lut_output)) begin
                $display("PASS");
                $display("  Outputs: ff_output=%b, lut_output=%b",
                         ff_output, lut_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ff_output=%b, lut_output=%b",
                         expected_ff_output, expected_lut_output);
                $display("  Got:      ff_output=%b, lut_output=%b",
                         ff_output, lut_output);
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
        $dumpvars(0,aclk, input_signals, ff_output, lut_output);
    end

endmodule
