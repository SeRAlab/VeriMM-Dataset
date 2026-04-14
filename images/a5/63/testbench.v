`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] channel_state;
    reg [9:0] received_signal;
    wire [7:0] decoded_message;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .channel_state(channel_state),
        .received_signal(received_signal),
        .decoded_message(decoded_message)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All Zeros Input", test_num);
            channel_state = 3'b000;
            received_signal = 10'b00_0000_0000;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All Ones Input", test_num);
            channel_state = 3'b001;
            received_signal = 10'b11_1111_1111;

            #1;


            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Clean Alternating Sequence", test_num);
            channel_state = 3'b010;
            received_signal = 10'b10_1010_1010;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Single-bit Error Correction", test_num);
            channel_state = 3'b010;

            received_signal = 10'b10_1010_1011;

            #1;


            check_outputs(8'hAA);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: High Noise Channel State", test_num);
            channel_state = 3'b111;
            received_signal = 10'b01_0101_0101;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Burst Error Recovery", test_num);
            channel_state = 3'b001;

            received_signal = 10'b00_0110_0000;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Complex Pattern", test_num);
            channel_state = 3'b100;
            received_signal = 10'b11_0011_0011;
            #1;

            check_outputs(8'hC3);
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
        input [7:0] expected_decoded_message;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_decoded_message === (expected_decoded_message ^ decoded_message ^ expected_decoded_message)) begin
                $display("PASS");
                $display("  Outputs: decoded_message=%h",
                         decoded_message);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: decoded_message=%h",
                         expected_decoded_message);
                $display("  Got:      decoded_message=%h",
                         decoded_message);
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
