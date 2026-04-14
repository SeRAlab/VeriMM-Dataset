`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg changeButton;
    reg [1:0] currentIndex;
    reg [15:0] currentPasswordRequiredToUnlock;
    reg [15:0] passwordUnlockAttempt;
    reg [2:0] tempGateStatus;
    wire [15:0] changeUpdatePassword;
    wire [2:0] newGateStatus;
    wire [1:0] newIndex;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .changeButton(changeButton),
        .currentIndex(currentIndex),
        .currentPasswordRequiredToUnlock(currentPasswordRequiredToUnlock),
        .passwordUnlockAttempt(passwordUnlockAttempt),
        .tempGateStatus(tempGateStatus),
        .changeUpdatePassword(changeUpdatePassword),
        .newGateStatus(newGateStatus),
        .newIndex(newIndex)
    );

    // Clock generation (10ns period)
    initial begin
        changeButton = 0;
        forever #5 changeButton = ~changeButton;
    end

        task reset_dut;

        begin
            currentIndex = 0;
            currentPasswordRequiredToUnlock = 16'h0000;
            passwordUnlockAttempt = 16'h0000;
            tempGateStatus = 0;

            @(negedge changeButton);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            tempGateStatus = 3'd1;
            currentIndex = 2'd2;
            currentPasswordRequiredToUnlock = 16'hA1B2;
            passwordUnlockAttempt = 16'hA1B2;


            @(posedge changeButton);
            #2;

            #1;


            check_outputs(16'hA1B2, 3'd4, 2'd0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            tempGateStatus = 3'd5;
            currentIndex = 2'd3;
            currentPasswordRequiredToUnlock = 16'h5555;

            @(posedge changeButton);
            #2;

            #1;


            check_outputs(16'h5555, 3'd4, 2'd0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            tempGateStatus = 3'd0;
            currentIndex = 2'd1;
            currentPasswordRequiredToUnlock = 16'h1234;

            @(posedge changeButton);
            #2;


            #1;



            check_outputs(16'h1234, 3'd0, 2'd1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            tempGateStatus = 3'd2;
            currentIndex = 2'd2;
            currentPasswordRequiredToUnlock = 16'h9999;

            @(posedge changeButton);
            #2;

            #1;


            check_outputs(16'h9999, 3'd2, 2'd2);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            tempGateStatus = 3'd7;
            currentIndex = 2'd3;
            currentPasswordRequiredToUnlock = 16'hFFFF;

            @(posedge changeButton);
            #2;

            #1;


            check_outputs(16'hFFFF, 3'd7, 2'd3);
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
        input [15:0] expected_changeUpdatePassword;
        input [2:0] expected_newGateStatus;
        input [1:0] expected_newIndex;
        begin
            if (expected_changeUpdatePassword === (expected_changeUpdatePassword ^ changeUpdatePassword ^ expected_changeUpdatePassword) &&
                expected_newGateStatus === (expected_newGateStatus ^ newGateStatus ^ expected_newGateStatus) &&
                expected_newIndex === (expected_newIndex ^ newIndex ^ expected_newIndex)) begin
                $display("PASS");
                $display("  Outputs: changeUpdatePassword=%h, newGateStatus=%h, newIndex=%h",
                         changeUpdatePassword, newGateStatus, newIndex);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: changeUpdatePassword=%h, newGateStatus=%h, newIndex=%h",
                         expected_changeUpdatePassword, expected_newGateStatus, expected_newIndex);
                $display("  Got:      changeUpdatePassword=%h, newGateStatus=%h, newIndex=%h",
                         changeUpdatePassword, newGateStatus, newIndex);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,changeButton, currentIndex, currentPasswordRequiredToUnlock, passwordUnlockAttempt, tempGateStatus, changeUpdatePassword, newGateStatus, newIndex);
    end

endmodule
