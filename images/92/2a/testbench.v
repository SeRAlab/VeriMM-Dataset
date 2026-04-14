`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg A0;
    reg A1;
    reg A2;
    reg A3;
    reg A4;
    reg D0;
    reg D1;
    reg D2;
    reg D3;
    reg WCLK;
    reg WE;
    wire O0;
    wire O1;
    wire O2;
    wire O3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A0(A0),
        .A1(A1),
        .A2(A2),
        .A3(A3),
        .A4(A4),
        .D0(D0),
        .D1(D1),
        .D2(D2),
        .D3(D3),
        .WCLK(WCLK),
        .WE(WE),
        .O0(O0),
        .O1(O1),
        .O2(O2),
        .O3(O3)
    );

        task reset_dut;

        begin
            A0 = 0; A1 = 0; A2 = 0; A3 = 0; A4 = 0;
            D0 = 0; D1 = 0; D2 = 0; D3 = 0;
            WCLK = 0;
            WE = 0;
            #10;
        end
        endtask
    task pulse_wclk;

        begin
            #5 WCLK = 1;
            #5 WCLK = 0;
            #5;
        end
        endtask

    task testcase001;

        begin
            $display("Testcase 001: Write 4'b1010 to Address 0");
            reset_dut();

            A0=0; A1=0; A2=0; A3=0; A4=0;
            D0=0; D1=1; D2=0; D3=1;
            WE=1;
            pulse_wclk();
            WE=0;
            #5;
            #1;

            check_outputs(0, 1, 0, 1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Write 4'b0111 to Address 31");
            reset_dut();

            A0=1; A1=1; A2=1; A3=1; A4=1;
            D0=1; D1=1; D2=1; D3=0;
            WE=1;
            pulse_wclk();
            WE=0;
            #5;
            #1;

            check_outputs(1, 1, 1, 0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Verify WE=0 does not write");
            reset_dut();

            A0=1; A1=1; A2=1; A3=1; A4=0;
            D0=1; D1=0; D2=1; D3=0;
            WE=1;
            pulse_wclk();

            D0=0; D1=1; D2=0; D3=1;
            WE=0;
            pulse_wclk();

            #5;
            #1;

            check_outputs(1, 0, 1, 0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Successive writes to Addr 2 and 3");
            reset_dut();

            A4=0; A3=0; A2=0; A1=1; A0=0; D3=1; D2=1; D1=0; D0=0; WE=1;
            pulse_wclk();

            A4=0; A3=0; A2=0; A1=1; A0=1; D3=0; D2=0; D1=1; D0=1; WE=1;
            pulse_wclk();

            WE=0;
            #5;
            #1;

            check_outputs(1, 1, 0, 0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Overwrite value at Addr 10");
            reset_dut();

            A4=0; A3=1; A2=0; A1=1; A0=0; D3=1; D2=1; D1=1; D0=1; WE=1;
            pulse_wclk();

            D3=0; D2=0; D1=0; D0=0;
            pulse_wclk();
            WE=0;
            #5;
            #1;

            check_outputs(0, 0, 0, 0);
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
        input expected_O0;
        input expected_O1;
        input expected_O2;
        input expected_O3;
        begin
            if (expected_O0 === (expected_O0 ^ O0 ^ expected_O0) &&
                expected_O1 === (expected_O1 ^ O1 ^ expected_O1) &&
                expected_O2 === (expected_O2 ^ O2 ^ expected_O2) &&
                expected_O3 === (expected_O3 ^ O3 ^ expected_O3)) begin
                $display("PASS");
                $display("  Outputs: O0=%b, O1=%b, O2=%b, O3=%b",
                         O0, O1, O2, O3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: O0=%b, O1=%b, O2=%b, O3=%b",
                         expected_O0, expected_O1, expected_O2, expected_O3);
                $display("  Got:      O0=%b, O1=%b, O2=%b, O3=%b",
                         O0, O1, O2, O3);
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
        $dumpvars(0,A0, A1, A2, A3, A4, D0, D1, D2, D3, WCLK, WE, O0, O1, O2, O3);
    end

endmodule
