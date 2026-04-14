`timescale 1ns/1ps

module rnn_inference_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] h_prev;
    reg [4:0] x;
    wire [4:0] h_next;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rnn_inference dut (
        .h_prev(h_prev),
        .x(x),
        .h_next(h_next)
    );
    task testcase001;

        begin
            $display("Test Case 001: Zero inputs");
            test_num = 1;
            x = 5'b00000;
            h_prev = 5'b00000;

            #1;


            check_outputs(5'b00000);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Simple positive addition");
            test_num = 2;
            x = 5'b00100;
            h_prev = 5'b00110;

            #1;


            check_outputs(5'b01010);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Positive result at boundary");
            test_num = 3;
            x = 5'b01010;
            h_prev = 5'b00101;

            #1;


            check_outputs(5'b01111);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Negative result (ReLU clipping)");
            test_num = 4;
            x = 5'b11011;
            h_prev = 5'b00010;

            #1;


            check_outputs(5'b00000);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Both inputs negative (ReLU clipping)");
            test_num = 5;
            x = 5'b11110;
            h_prev = 5'b11101;

            #1;


            check_outputs(5'b00000);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: Mixed signs resulting in positive");
            test_num = 6;
            x = 5'b11011;
            h_prev = 5'b01100;

            #1;


            check_outputs(5'b00111);
        end
        endtask

    task testcase007;

        begin
            $display("Test Case 007: Net zero result");
            test_num = 7;
            x = 5'b00111;
            h_prev = 5'b11001;

            #1;


            check_outputs(5'b00000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rnn_inference Testbench");
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
        input [4:0] expected_h_next;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_h_next === (expected_h_next ^ h_next ^ expected_h_next)) begin
                $display("PASS");
                $display("  Outputs: h_next=%h",
                         h_next);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: h_next=%h",
                         expected_h_next);
                $display("  Got:      h_next=%h",
                         h_next);
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
