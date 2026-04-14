`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clkIn;
    reg demoOrRealModeIn;
    reg monitorOrMissedSceneIn;
    reg [3:0] resetSetLoadStartIn;
    reg [3:0] toggleSwitches13To10In;
    reg [3:0] toggleSwitches17To14In;
    wire clkOut;
    wire demoOrRealModeOut;
    wire monitorOrMissedSceneOut;
    wire [3:0] resetSetLoadStartOut;
    wire [3:0] toggleSwitches13To10Out;
    wire [3:0] toggleSwitches17To14Out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clkIn(clkIn),
        .demoOrRealModeIn(demoOrRealModeIn),
        .monitorOrMissedSceneIn(monitorOrMissedSceneIn),
        .resetSetLoadStartIn(resetSetLoadStartIn),
        .toggleSwitches13To10In(toggleSwitches13To10In),
        .toggleSwitches17To14In(toggleSwitches17To14In),
        .clkOut(clkOut),
        .demoOrRealModeOut(demoOrRealModeOut),
        .monitorOrMissedSceneOut(monitorOrMissedSceneOut),
        .resetSetLoadStartOut(resetSetLoadStartOut),
        .toggleSwitches13To10Out(toggleSwitches13To10Out),
        .toggleSwitches17To14Out(toggleSwitches17To14Out)
    );
    task testcase001;

        begin
            $display("\nTestcase 001: All Zeros");
            clkIn = 1'b0;
            demoOrRealModeIn = 1'b0;
            monitorOrMissedSceneIn = 1'b0;
            resetSetLoadStartIn = 4'b0000;
            toggleSwitches13To10In = 4'b0000;
            toggleSwitches17To14In = 4'b0000;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0, 4'b0000, 4'b0000, 4'b0000);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: All Ones");
            clkIn = 1'b1;
            demoOrRealModeIn = 1'b1;
            monitorOrMissedSceneIn = 1'b1;
            resetSetLoadStartIn = 4'b1111;
            toggleSwitches13To10In = 4'b1111;
            toggleSwitches17To14In = 4'b1111;
            #1;

            check_outputs(1'b1, 1'b1, 1'b1, 4'b1111, 4'b1111, 4'b1111);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: Mixed Bus Patterns (Pattern A)");
            clkIn = 1'b0;
            demoOrRealModeIn = 1'b1;
            monitorOrMissedSceneIn = 1'b0;
            resetSetLoadStartIn = 4'b1010;
            toggleSwitches13To10In = 4'b0101;
            toggleSwitches17To14In = 4'b1100;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0, 4'b1010, 4'b0101, 4'b1100);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: Mixed Bus Patterns (Pattern B)");
            clkIn = 1'b1;
            demoOrRealModeIn = 1'b0;
            monitorOrMissedSceneIn = 1'b1;
            resetSetLoadStartIn = 4'b0110;
            toggleSwitches13To10In = 4'b1001;
            toggleSwitches17To14In = 4'b0011;
            #1;

            check_outputs(1'b1, 1'b0, 1'b1, 4'b0110, 4'b1001, 4'b0011);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: Boundary Values on Switches");
            clkIn = 1'b0;
            demoOrRealModeIn = 1'b1;
            monitorOrMissedSceneIn = 1'b1;
            resetSetLoadStartIn = 4'b0001;
            toggleSwitches13To10In = 4'b1000;
            toggleSwitches17To14In = 4'b0110;
            #1;

            check_outputs(1'b0, 1'b1, 1'b1, 4'b0001, 4'b1000, 4'b0110);
        end
        endtask

    task testcase006;

        begin
            $display("\nTestcase 006: Alternating Clock and Mode Signal");
            clkIn = 1'b1;
            demoOrRealModeIn = 1'b1;
            monitorOrMissedSceneIn = 1'b0;
            resetSetLoadStartIn = 4'b1110;
            toggleSwitches13To10In = 4'b0001;
            toggleSwitches17To14In = 4'b1011;
            #1;

            check_outputs(1'b1, 1'b1, 1'b0, 4'b1110, 4'b0001, 4'b1011);
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
        input expected_clkOut;
        input expected_demoOrRealModeOut;
        input expected_monitorOrMissedSceneOut;
        input [3:0] expected_resetSetLoadStartOut;
        input [3:0] expected_toggleSwitches13To10Out;
        input [3:0] expected_toggleSwitches17To14Out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_clkOut === (expected_clkOut ^ clkOut ^ expected_clkOut) &&
                expected_demoOrRealModeOut === (expected_demoOrRealModeOut ^ demoOrRealModeOut ^ expected_demoOrRealModeOut) &&
                expected_monitorOrMissedSceneOut === (expected_monitorOrMissedSceneOut ^ monitorOrMissedSceneOut ^ expected_monitorOrMissedSceneOut) &&
                expected_resetSetLoadStartOut === (expected_resetSetLoadStartOut ^ resetSetLoadStartOut ^ expected_resetSetLoadStartOut) &&
                expected_toggleSwitches13To10Out === (expected_toggleSwitches13To10Out ^ toggleSwitches13To10Out ^ expected_toggleSwitches13To10Out) &&
                expected_toggleSwitches17To14Out === (expected_toggleSwitches17To14Out ^ toggleSwitches17To14Out ^ expected_toggleSwitches17To14Out)) begin
                $display("PASS");
                $display("  Outputs: clkOut=%b, demoOrRealModeOut=%b, monitorOrMissedSceneOut=%b, resetSetLoadStartOut=%h, toggleSwitches13To10Out=%h, toggleSwitches17To14Out=%h",
                         clkOut, demoOrRealModeOut, monitorOrMissedSceneOut, resetSetLoadStartOut, toggleSwitches13To10Out, toggleSwitches17To14Out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clkOut=%b, demoOrRealModeOut=%b, monitorOrMissedSceneOut=%b, resetSetLoadStartOut=%h, toggleSwitches13To10Out=%h, toggleSwitches17To14Out=%h",
                         expected_clkOut, expected_demoOrRealModeOut, expected_monitorOrMissedSceneOut, expected_resetSetLoadStartOut, expected_toggleSwitches13To10Out, expected_toggleSwitches17To14Out);
                $display("  Got:      clkOut=%b, demoOrRealModeOut=%b, monitorOrMissedSceneOut=%b, resetSetLoadStartOut=%h, toggleSwitches13To10Out=%h, toggleSwitches17To14Out=%h",
                         clkOut, demoOrRealModeOut, monitorOrMissedSceneOut, resetSetLoadStartOut, toggleSwitches13To10Out, toggleSwitches17To14Out);
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
