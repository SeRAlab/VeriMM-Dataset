`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg CE;
    reg CLK;
    reg [16:0] process_input;
    wire [15:0] process_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CE(CE),
        .CLK(CLK),
        .process_input(process_input),
        .process_output(process_output)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Pass-through (Bit 16 = 0)", test_num);

        CE = 1;
        process_input = 17'h0_AAAA;
        @(posedge CLK);
        #2;
        #1;

        check_outputs(16'hAAAA);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Bitwise Inversion (Bit 16 = 1)", test_num);
        CE = 1;
        process_input = 17'h1_AAAA;
        @(posedge CLK);
        #2;
        #1;

        check_outputs(16'h5555);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Clock Enable De-assertion (CE = 0)", test_num);

        CE = 1;
        process_input = 17'h0_1234;
        @(posedge CLK);
        #2;


        CE = 0;
        process_input = 17'h0_FFFF;
        @(posedge CLK);
        #2;

        #1;


        check_outputs(16'h1234);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Boundary Values (All 0s and 1s)", test_num);
        CE = 1;


        process_input = 17'h0_0000;
        @(posedge CLK);
        #2;


        process_input = 17'h1_FFFF;
        @(posedge CLK);
        #2;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Mode Switching Logic", test_num);
        CE = 1;


        process_input = 17'h0_F0F0;
        @(posedge CLK);
        #2;

        process_input = 17'h1_F0F0;
        @(posedge CLK);
        #2;
        #1;

        check_outputs(16'h0F0F);
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
        input [15:0] expected_process_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_process_output === (expected_process_output ^ process_output ^ expected_process_output)) begin
                $display("PASS");
                $display("  Outputs: process_output=%h",
                         process_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: process_output=%h",
                         expected_process_output);
                $display("  Got:      process_output=%h",
                         process_output);
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

endmodule
