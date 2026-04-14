`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CE;
    reg CLK;
    reg D;
    reg RESET;
    reg SET;
    wire Q;
    wire Q_N;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CE(CE),
        .CLK(CLK),
        .D(D),
        .RESET(RESET),
        .SET(SET),
        .Q(Q),
        .Q_N(Q_N)
    );

    // Clock generation (10ns period)
    initial begin
        CE = 0;
        forever #5 CE = ~CE;
    end

        task reset_dut;

        begin
            SET = 0;
            RESET = 1;
            D = 0;
            CE = 0;
            #10;
            RESET = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Asynchronous Reset");
            reset_dut();

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Asynchronous Set");
            reset_dut();
            SET = 1;
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
            SET = 0;
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Synchronous Load High (CE=1, D=1)");
            reset_dut();
            D = 1;
            CE = 1;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Synchronous Load Low (CE=1, D=0)");
            reset_dut();

            D = 1; CE = 1;
            @(posedge CLK);
            #2;

            D = 0;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Clock Enable Inactive (CE=0)");
            reset_dut();

            D = 1; CE = 1;
            @(posedge CLK);
            #2;

            CE = 0;
            D = 0;
            @(posedge CLK);
            #2;

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase 006: Async Reset Priority over Clock");
            reset_dut();
            CE = 1; D = 1;
            @(posedge CLK);
            #2;

            RESET = 1;
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
            RESET = 0;
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase 007: Async Set Priority over Clock");
            reset_dut();
            CE = 1; D = 0;
            @(posedge CLK);
            #2;

            SET = 1;
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
            SET = 0;
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
        $dumpvars(0,CE, CLK, D, RESET, SET, Q, Q_N);
    end

endmodule
