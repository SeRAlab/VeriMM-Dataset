`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] vector_in;
    wire signal_out0;
    wire signal_out1;
    wire signal_out2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .vector_in(vector_in),
        .signal_out0(signal_out0),
        .signal_out1(signal_out1),
        .signal_out2(signal_out2)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: All zeros (3'b000)", test_num);
            vector_in = 3'b000;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: All ones (3'b111)", test_num);
            vector_in = 3'b111;
            #1;

            check_outputs(1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Least Significant Bit (3'b001)", test_num);
            vector_in = 3'b001;
            #1;

            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Middle Bit (3'b010)", test_num);
            vector_in = 3'b010;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Most Significant Bit (3'b100)", test_num);
            vector_in = 3'b100;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Alternating pattern (3'b101)", test_num);
            vector_in = 3'b101;
            #1;

            check_outputs(1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Inverse alternating (3'b010)", test_num);
            vector_in = 3'b010;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Multiple bits (3'b011)", test_num);
            vector_in = 3'b011;
            #1;

            check_outputs(1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test Case %0d: Multiple bits (3'b110)", test_num);
            vector_in = 3'b110;
            #1;

            check_outputs(1'b0, 1'b1, 1'b1);
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
        input expected_signal_out0;
        input expected_signal_out1;
        input expected_signal_out2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_signal_out0 === (expected_signal_out0 ^ signal_out0 ^ expected_signal_out0) &&
                expected_signal_out1 === (expected_signal_out1 ^ signal_out1 ^ expected_signal_out1) &&
                expected_signal_out2 === (expected_signal_out2 ^ signal_out2 ^ expected_signal_out2)) begin
                $display("PASS");
                $display("  Outputs: signal_out0=%b, signal_out1=%b, signal_out2=%b",
                         signal_out0, signal_out1, signal_out2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: signal_out0=%b, signal_out1=%b, signal_out2=%b",
                         expected_signal_out0, expected_signal_out1, expected_signal_out2);
                $display("  Got:      signal_out0=%b, signal_out1=%b, signal_out2=%b",
                         signal_out0, signal_out1, signal_out2);
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
