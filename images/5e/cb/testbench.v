`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg CE;
    reg CLK;
    reg [31:0] process_input;
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
    task pulse_clk;

    begin
        #5 CLK = 1;
        #5 CLK = 0;
    end
        endtask

    task reset_signals;

    begin
        CLK = 0;
        CE = 0;
        process_input = 0;
        #5;
    end
        endtask

    task testcase001;

    begin
        reset_signals();
        test_num = test_num + 1;
        $display("Testcase %0d: LSBs = 1 logic check", test_num);
        CE = 1;
        process_input = 32'hA5A5_0001;
        pulse_clk();
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        reset_signals();
        test_num = test_num + 1;
        $display("Testcase %0d: Normal summation (LSBs != 1)", test_num);
        CE = 1;
        process_input = 32'h0010_0020;
        pulse_clk();
        #1;

        check_outputs(16'h0030);
    end
        endtask

    task testcase003;

    begin
        reset_signals();
        test_num = test_num + 1;
        $display("Testcase %0d: LSBs = 0 check", test_num);
        CE = 1;
        process_input = 32'h1234_0000;
        pulse_clk();
        #1;

        check_outputs(16'h1234);
    end
        endtask

    task testcase004;

    begin
        reset_signals();
        test_num = test_num + 1;
        $display("Testcase %0d: Summation overflow check", test_num);
        CE = 1;
        process_input = 32'hFFFF_0002;
        pulse_clk();
        #1;

        check_outputs(16'h0001);
    end
        endtask

    task testcase005;

    begin
        reset_signals();
        test_num = test_num + 1;
        $display("Testcase %0d: Clock Enable (CE) functionality check", test_num);


        CE = 1;
        process_input = 32'h0005_0005;
        pulse_clk();


        CE = 0;
        process_input = 32'h0010_0010;
        pulse_clk();

        #1;


        check_outputs(16'h000A);
    end
        endtask

    task testcase006;

    begin
        reset_signals();
        test_num = test_num + 1;
        $display("Testcase %0d: LSBs = 1 with zero MSBs", test_num);
        CE = 1;
        process_input = 32'h0000_0001;
        pulse_clk();
        #1;

        check_outputs(16'h0000);
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
