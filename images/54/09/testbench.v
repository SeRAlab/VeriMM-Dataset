`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ASYNC;
    reg CLK;
    reg D;
    reg EN;
    reg R;
    reg S;
    wire [3:0] Q;
    wire [3:0] Q_N;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ASYNC(ASYNC),
        .CLK(CLK),
        .D(D),
        .EN(EN),
        .R(R),
        .S(S),
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
            R = 1;
            S = 0;
            D = 0;
            EN = 0;
            ASYNC = 1;
            #15;
            R = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Asynchronous Reset");
            reset_dut();

            #1;


            check_outputs(4'b0000, 4'b1111);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Asynchronous Set");
            reset_dut();
            S = 1;
            #10;
            S = 0;
            #1;

            check_outputs(4'b1111, 4'b0000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Basic Shifting");
            reset_dut();
            EN = 1;

            @(posedge CLK); D = 1;
            @(posedge CLK); D = 0;
            @(posedge CLK); D = 1;
            @(posedge CLK); D = 1;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(4'b1011, 4'b0100);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Enable Control (Holding Value)");
            reset_dut();
            EN = 1;
            @(posedge CLK); D = 1;
            @(posedge CLK); D = 1;
            #2;
            EN = 0;
            @(posedge CLK); D = 0;
            @(posedge CLK); D = 0;
            #2;

            #1;


            check_outputs(4'b0011, 4'b1100);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Async Reset Mid-operation");
            reset_dut();
            EN = 1;
            @(posedge CLK); D = 1;
            @(posedge CLK); D = 1;
            #2;
            R = 1;
            #5;
            R = 0;
            #1;

            check_outputs(4'b0000, 4'b1111);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase 006: Fill and Clear via Shift");
            reset_dut();
            EN = 1;

            repeat(4) @(posedge CLK) D = 1;
            #2;

            @(posedge CLK) D = 0;
            #2;
            #1;

            check_outputs(4'b1110, 4'b0001);
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
        input [3:0] expected_Q;
        input [3:0] expected_Q_N;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_Q_N === (expected_Q_N ^ Q_N ^ expected_Q_N)) begin
                $display("PASS");
                $display("  Outputs: Q=%h, Q_N=%h",
                         Q, Q_N);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h, Q_N=%h",
                         expected_Q, expected_Q_N);
                $display("  Got:      Q=%h, Q_N=%h",
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
        $dumpvars(0,ASYNC, CLK, D, EN, R, S, Q, Q_N);
    end

endmodule
