`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] control_signal;
    reg [15:0] input_signal;
    wire [15:0] output_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .control_signal(control_signal),
        .input_signal(input_signal),
        .output_signal(output_signal)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero Input Signal", test_num);
            input_signal = 16'h0000;
            control_signal = 8'hFF;

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero Control Signal (Minimum Gain)", test_num);
            input_signal = 16'hFFFF;
            control_signal = 8'h00;

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mid-range Signal with Unity-ish Gain", test_num);
            input_signal = 16'h1234;
            control_signal = 8'h80;

            #1;


            check_outputs(16'h091A);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Small Signal with High Gain", test_num);
            input_signal = 16'h00FF;
            control_signal = 8'hFF;

            #1;


            check_outputs(16'h00FE);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Large Signal with Gain Adjustment", test_num);
            input_signal = 16'h8000;
            control_signal = 8'h40;

            #1;


            check_outputs(16'h2000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum Input and Maximum Control", test_num);
            input_signal = 16'hFFFF;
            control_signal = 8'hFF;

            #1;


            check_outputs(16'hFF00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Specific Bit Pattern Test", test_num);
            input_signal = 16'hAAAA;
            control_signal = 8'h55;

            #1;


            check_outputs(16'h38E3);
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
