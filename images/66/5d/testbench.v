`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg enable;
    reg [15:0] encoder_in;
    wire [3:0] binary_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .enable(enable),
        .encoder_in(encoder_in),
        .binary_out(binary_out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Enable low, input all zeros", test_num);
        enable = 0;
        encoder_in = 16'h0000;
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Enable low, bit 15 set (should be 0)", test_num);
        enable = 0;
        encoder_in = 16'h8000;
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Enable high, input all zeros", test_num);
        enable = 1;
        encoder_in = 16'h0000;
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Enable high, bit 1 set (2^1)", test_num);
        enable = 1;
        encoder_in = 16'h0002;
        #1;

        check_outputs(4'd1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Enable high, bit 4 set (2^4)", test_num);
        enable = 1;
        encoder_in = 16'h0010;
        #1;

        check_outputs(4'd4);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: Enable high, bit 8 set (2^8)", test_num);
        enable = 1;
        encoder_in = 16'h0100;
        #1;

        check_outputs(4'd8);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %03d: Enable high, bit 15 set (2^15)", test_num);
        enable = 1;
        encoder_in = 16'h8000;
        #1;

        check_outputs(4'd15);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %03d: Enable high, bit 0 set (not in 1-15 range, should be 0)", test_num);
        enable = 1;
        encoder_in = 16'h0001;
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %03d: Enable high, multiple bits (priority check - MSB 10)", test_num);
        enable = 1;
        encoder_in = 16'h0404;
        #1;

        check_outputs(4'd10);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %03d: Enable high, all bits set (priority check - MSB 15)", test_num);
        enable = 1;
        encoder_in = 16'hFFFF;
        #1;

        check_outputs(4'd15);
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
        input [3:0] expected_binary_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_binary_out === (expected_binary_out ^ binary_out ^ expected_binary_out)) begin
                $display("PASS");
                $display("  Outputs: binary_out=%h",
                         binary_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: binary_out=%h",
                         expected_binary_out);
                $display("  Got:      binary_out=%h",
                         binary_out);
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
