`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg D;
    reg RESET_B;
    reg SET_B;
    reg VGND;
    reg VPWR;
    wire Q;
    wire Q_N;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .D(D),
        .RESET_B(RESET_B),
        .SET_B(SET_B),
        .VGND(VGND),
        .VPWR(VPWR),
        .Q(Q),
        .Q_N(Q_N)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            VPWR = 1;
            VGND = 0;
            SET_B = 1;
            RESET_B = 1;
            D = 0;
            @(negedge CLK);
            RESET_B = 0;
            @(negedge CLK);
            RESET_B = 1;
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("testcase001: Asynchronous Reset Assertion");
            reset_dut();
            RESET_B = 0;
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("testcase002: Asynchronous Set Assertion");
            reset_dut();
            SET_B = 0;
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("testcase003: Conflict Check (SET_B vs RESET_B)");
            reset_dut();
            SET_B = 0;
            RESET_B = 0;
            #2;

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("testcase004: Synchronous Capture D=1");
            reset_dut();
            D = 1;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("testcase005: Synchronous Capture D=0");
            reset_dut();

            SET_B = 0; #2; SET_B = 1; #2;
            D = 0;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("testcase006: Output Stability without Clock Edge");
            reset_dut();
            D = 1;
            #20;

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            $display("testcase007: Asynchronous SET_B overriding clocked D=0");
            reset_dut();
            D = 0;
            @(posedge CLK);
            #2;
            SET_B = 0;
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase008;

        begin
            $display("testcase008: Release of Asynchronous Signals");
            reset_dut();
            SET_B = 0; #2;
            SET_B = 1; #2;

            D = 0;
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
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
        input expected_Q;
        input expected_Q_N;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_Q_N === (expected_Q_N ^ Q_N ^ expected_Q_N)) begin
                $display("PASS");
                $display("  Outputs: Q=%b, Q_N=%b",
                         Q, Q_N);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%b, Q_N=%b",
                         expected_Q, expected_Q_N);
                $display("  Got:      Q=%b, Q_N=%b",
                         Q, Q_N);
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
        $dumpvars(0,CLK, D, RESET_B, SET_B, VGND, VPWR, Q, Q_N);
    end

endmodule
