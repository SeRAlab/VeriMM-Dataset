`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] channel_response;
    reg [3:0] rx_signal;
    wire [3:0] eq_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .channel_response(channel_response),
        .rx_signal(rx_signal),
        .eq_signal(eq_signal)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All Zeros", test_num);
            rx_signal = 4'b0000;
            channel_response = 4'b0000;

            #1;


            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Max Signal, No Distortion", test_num);
            rx_signal = 4'b1111;
            channel_response = 4'b0000;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero Signal, Max Distortion Pattern", test_num);
            rx_signal = 4'b0000;
            channel_response = 4'b1111;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating Bits", test_num);
            rx_signal = 4'b1010;
            channel_response = 4'b0101;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Mixed Pattern", test_num);
            rx_signal = 4'b1100;
            channel_response = 4'b1010;
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Inverse Signal/Channel", test_num);
            rx_signal = 4'b1001;
            channel_response = 4'b1001;
            #1;

            check_outputs(4'b0000);
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
        input [3:0] expected_eq_signal;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_eq_signal === (expected_eq_signal ^ eq_signal ^ expected_eq_signal)) begin
                $display("PASS");
                $display("  Outputs: eq_signal=%h",
                         eq_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: eq_signal=%h",
                         expected_eq_signal);
                $display("  Got:      eq_signal=%h",
                         eq_signal);
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
