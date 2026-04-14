`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] input_signal;
    wire [3:0] output_signal_1;
    wire [3:0] output_signal_2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .input_signal(input_signal),
        .output_signal_1(output_signal_1),
        .output_signal_2(output_signal_2)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Zeros", test_num);
            input_signal = 8'h00;
            #1;

            check_outputs(4'h0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Ones", test_num);
            input_signal = 8'hFF;
            #1;

            check_outputs(4'hF, 4'hF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: High Nibble Pattern", test_num);
            input_signal = 8'hA0;
            #1;

            check_outputs(4'hA, 4'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Low Nibble Pattern", test_num);
            input_signal = 8'h05;
            #1;

            check_outputs(4'h0, 4'h5);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Alternating Pattern 1", test_num);
            input_signal = 8'h5A;
            #1;

            check_outputs(4'h5, 4'hA);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Alternating Pattern 2", test_num);
            input_signal = 8'hA5;
            #1;

            check_outputs(4'hA, 4'h5);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Sequential Nibbles", test_num);
            input_signal = 8'h12;
            #1;

            check_outputs(4'h1, 4'h2);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Random Bits", test_num);
            input_signal = 8'hC3;
            #1;

            check_outputs(4'hC, 4'h3);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Higher Nibble Boundary", test_num);
            input_signal = 8'h80;
            #1;

            check_outputs(4'h8, 4'h0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Lower Nibble Boundary", test_num);
            input_signal = 8'h08;
            #1;

            check_outputs(4'h0, 4'h8);
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
        input [3:0] expected_output_signal_1;
        input [3:0] expected_output_signal_2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output_signal_1 === (expected_output_signal_1 ^ output_signal_1 ^ expected_output_signal_1) &&
                expected_output_signal_2 === (expected_output_signal_2 ^ output_signal_2 ^ expected_output_signal_2)) begin
                $display("PASS");
                $display("  Outputs: output_signal_1=%h, output_signal_2=%h",
                         output_signal_1, output_signal_2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_signal_1=%h, output_signal_2=%h",
                         expected_output_signal_1, expected_output_signal_2);
                $display("  Got:      output_signal_1=%h, output_signal_2=%h",
                         output_signal_1, output_signal_2);
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
