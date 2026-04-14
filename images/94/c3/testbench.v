`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] channel_response;
    reg [7:0] transmitted_signal;
    wire [7:0] equalized_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .channel_response(channel_response),
        .transmitted_signal(transmitted_signal),
        .equalized_signal(equalized_signal)
    );
    task testcase001;

    begin
        test_num = 1;
        transmitted_signal = 8'd100;
        channel_response = 8'd1;
        #1;

        check_outputs(8'd100);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        transmitted_signal = 8'd200;
        channel_response = 8'd2;
        #1;

        check_outputs(8'd100);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        transmitted_signal = 8'd100;
        channel_response = 8'd4;
        #1;

        check_outputs(8'd25);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        transmitted_signal = 8'd255;
        channel_response = 8'd1;
        #1;

        check_outputs(8'd255);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        transmitted_signal = 8'd150;
        channel_response = 8'd10;
        #1;

        check_outputs(8'd15);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        transmitted_signal = 8'd0;
        channel_response = 8'd5;
        #1;

        check_outputs(8'd0);
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
        input [7:0] expected_equalized_signal;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_equalized_signal === (expected_equalized_signal ^ equalized_signal ^ expected_equalized_signal)) begin
                $display("PASS");
                $display("  Outputs: equalized_signal=%h",
                         equalized_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: equalized_signal=%h",
                         expected_equalized_signal);
                $display("  Got:      equalized_signal=%h",
                         equalized_signal);
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
