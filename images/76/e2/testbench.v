`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg CTRL;
    reg D;
    reg RESET_B;
    reg SET_B;
    wire Q;
    wire Q_N;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .CTRL(CTRL),
        .D(D),
        .RESET_B(RESET_B),
        .SET_B(SET_B),
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
            CLK = 0;
            CTRL = 0;
            D = 0;
            RESET_B = 0;
            SET_B = 1;
            #15;
            RESET_B = 1;
            #5;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Asynchronous Reset");
            reset_dut();


            #1;



            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Asynchronous Set");
            reset_dut();
            SET_B = 0;
            #10;
            #1;

            check_outputs(1'b1, 1'b0);
            SET_B = 1;
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: CLK Edge Capture D=1 (CTRL=1)");
            reset_dut();
            D = 1;
            CTRL = 1;
            #5;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: CLK Edge Capture D=0 (CTRL=1)");
            reset_dut();

            SET_B = 0; #5; SET_B = 1; #5;
            D = 0;
            CTRL = 1;
            #5;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: No Capture on CLK Edge when CTRL=0");
            reset_dut();

            SET_B = 0; #5; SET_B = 1; #5;
            D = 0;
            CTRL = 0;
            #5;
            @(posedge CLK);
            #2;

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Falling Edge of CTRL Capture D=1");
            reset_dut();
            D = 1;
            CTRL = 1;
            #10;
            CTRL = 0;
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Falling Edge of CTRL Capture D=0");
            reset_dut();

            SET_B = 0; #5; SET_B = 1; #5;
            D = 0;
            CTRL = 1;
            #10;
            CTRL = 0;
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Reset Priority over Set");
            reset_dut();
            SET_B = 0;
            RESET_B = 0;
            #10;
            #1;

            check_outputs(1'b0, 1'b1);
            RESET_B = 1;
            SET_B = 1;
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: Async Reset Priority over CLK");
            reset_dut();
            D = 1;
            CTRL = 1;
            RESET_B = 0;
            #5;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
            RESET_B = 1;
        end
        endtask

    task testcase010;

        begin
            $display("Testcase 010: Consecutive Transfers");
            reset_dut();
            CTRL = 1;

            D = 1; @(posedge CLK); #2;
            D = 0; @(posedge CLK); #2;
            D = 1; @(posedge CLK); #2;

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
        $dumpvars(0,CLK, CTRL, D, RESET_B, SET_B, Q, Q_N);
    end

endmodule
