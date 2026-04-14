`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg [31:0] input_signal;
    wire [15:0] output_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .input_signal(input_signal),
        .output_signal(output_signal)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Minimum value (0)", test_num);
        input_signal = 32'h0000_0000;

        clk = 0; #5; clk = 1; #5; clk = 0;
        #1;

        check_outputs(16'h0001);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Middle-range value", test_num);
        input_signal = 32'h1234_5678;
        clk = 0; #5; clk = 1; #5; clk = 0;
        #1;

        check_outputs(16'h5679);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: High upper bits, zero lower bits", test_num);
        input_signal = 32'hFFFF_0000;
        clk = 0; #5; clk = 1; #5; clk = 0;
        #1;

        check_outputs(16'h0001);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Lower 16-bit rollover (FFFF -> 0000)", test_num);
        input_signal = 32'h0000_FFFF;
        clk = 0; #5; clk = 1; #5; clk = 0;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Internal carry check (7FFF)", test_num);
        input_signal = 32'hAAAA_7FFF;
        clk = 0; #5; clk = 1; #5; clk = 0;
        #1;

        check_outputs(16'h8000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Maximum 32-bit input", test_num);
        input_signal = 32'hFFFF_FFFF;
        clk = 0; #5; clk = 1; #5; clk = 0;
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
        input [15:0] expected_output_signal;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output_signal === (expected_output_signal ^ output_signal ^ expected_output_signal)) begin
                $display("PASS");
                $display("  Outputs: output_signal=%h",
                         output_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_signal=%h",
                         expected_output_signal);
                $display("  Got:      output_signal=%h",
                         output_signal);
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
