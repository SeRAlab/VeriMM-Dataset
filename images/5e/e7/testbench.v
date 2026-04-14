`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] data;
    reg [3:0] shift_amount;
    wire [15:0] shifted_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data(data),
        .shift_amount(shift_amount),
        .shifted_data(shifted_data)
    );
    task testcase001;

    begin
        $display("Testcase 001: No shift (shift_amount = 0)");
        test_num = 1;
        data = 16'hABCD;
        shift_amount = 4'd0;
        #1;

        check_outputs(16'hABCD);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: Shift right by 1");
        test_num = 2;
        data = 16'hFFFF;
        shift_amount = 4'd1;
        #1;

        check_outputs(16'h7FFF);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: Shift right by 2");
        test_num = 3;
        data = 16'hAAAA;
        shift_amount = 4'd2;
        #1;

        check_outputs(16'h2AAA);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Shift right by 4 (stage 2 boundary)");
        test_num = 4;
        data = 16'hF0F0;
        shift_amount = 4'd4;
        #1;

        check_outputs(16'h0F0F);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Shift right by 8 (stage 3 boundary)");
        test_num = 5;
        data = 16'hFF00;
        shift_amount = 4'd8;
        #1;

        check_outputs(16'h00FF);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: Shift right by maximum amount (15)");
        test_num = 6;
        data = 16'h8000;
        shift_amount = 4'd15;
        #1;

        check_outputs(16'h0001);
    end
        endtask

    task testcase007;

    begin
        $display("Testcase 007: Shift right resulting in zero");
        test_num = 7;
        data = 16'h000F;
        shift_amount = 4'd4;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase008;

    begin
        $display("Testcase 008: Arbitrary shift amount (7)");
        test_num = 8;
        data = 16'hFFFF;
        shift_amount = 4'd7;
        #1;

        check_outputs(16'h01FF);
    end
        endtask

    task testcase009;

    begin
        $display("Testcase 009: Arbitrary pattern shift (12)");
        test_num = 9;
        data = 16'h5A5A;
        shift_amount = 4'd12;
        #1;

        check_outputs(16'h0005);
    end
        endtask

    task testcase010;

    begin
        $display("Testcase 010: Zero data input");
        test_num = 10;
        data = 16'h0000;
        shift_amount = 4'd8;
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
        input [15:0] expected_shifted_data;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_shifted_data === (expected_shifted_data ^ shifted_data ^ expected_shifted_data)) begin
                $display("PASS");
                $display("  Outputs: shifted_data=%h",
                         shifted_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: shifted_data=%h",
                         expected_shifted_data);
                $display("  Got:      shifted_data=%h",
                         shifted_data);
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
