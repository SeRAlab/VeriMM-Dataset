`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] control_signals;
    reg [3:0] input_data;
    wire [3:0] output_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .control_signals(control_signals),
        .input_data(input_data),
        .output_data(output_data)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Adder Mode - Input 4'h0", test_num);
            control_signals = 4'h1;
            input_data = 4'h0;
            #1;

            check_outputs(4'h1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Adder Mode - Input 4'h7", test_num);
            control_signals = 4'h1;
            input_data = 4'h7;
            #1;

            check_outputs(4'h8);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Adder Mode - Input 4'hF (Overflow)", test_num);
            control_signals = 4'h1;
            input_data = 4'hF;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Encoder Mode - MSB set (4'h8)", test_num);
            control_signals = 4'h2;
            input_data = 4'b1000;
            #1;

            check_outputs(4'd3);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Encoder Mode - Bit 2 set (4'h4)", test_num);
            control_signals = 4'h2;
            input_data = 4'b0100;
            #1;

            check_outputs(4'd2);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Encoder Mode - Bit 1 set (4'h2)", test_num);
            control_signals = 4'h2;
            input_data = 4'b0010;
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Encoder Mode - LSB set (4'h1)", test_num);
            control_signals = 4'h2;
            input_data = 4'b0001;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Encoder Mode - Multiple bits (4'hE)", test_num);
            control_signals = 4'h2;
            input_data = 4'b1110;
            #1;

            check_outputs(4'd3);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Encoder Mode - Zero Input", test_num);
            control_signals = 4'h2;
            input_data = 4'h0;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Inactive Control Signals", test_num);
            control_signals = 4'h0;
            input_data = 4'hA;
            #1;

            check_outputs(4'h0);
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
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [3:0] expected_output_data;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output_data === (expected_output_data ^ output_data ^ expected_output_data)) begin
                $display("PASS");
                $display("  Outputs: output_data=%h",
                         output_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_data=%h",
                         expected_output_data);
                $display("  Got:      output_data=%h",
                         output_data);
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
