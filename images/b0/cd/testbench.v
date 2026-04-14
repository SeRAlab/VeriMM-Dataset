`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg D;
    reg EN;
    reg RESET;
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
        .EN(EN),
        .RESET(RESET),
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
            RESET = 0;
            D = 0;
            EN = 0;
            #15;
            RESET = 1;
            #10;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Asynchronous Reset Check");
            test_num = 1;
            reset_dut();


            #1;



            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Load D=1 with EN=1");
            test_num = 2;
            reset_dut();
            @(negedge CLK);
            EN = 1;
            D = 1;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Load D=0 with EN=1");
            test_num = 3;
            reset_dut();

            @(negedge CLK);
            EN = 1;
            D = 1;
            @(posedge CLK);

            @(negedge CLK);
            D = 0;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: EN=0 Retention Check (Hold 1)");
            test_num = 4;
            reset_dut();

            @(negedge CLK);
            EN = 1;
            D = 1;
            @(posedge CLK);

            @(negedge CLK);
            EN = 0;
            D = 0;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: EN=0 Retention Check (Hold 0)");
            test_num = 5;
            reset_dut();

            @(negedge CLK);
            EN = 1;
            D = 0;
            @(posedge CLK);

            @(negedge CLK);
            EN = 0;
            D = 1;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Asynchronous Reset Priority Over EN");
            test_num = 6;
            reset_dut();

            @(negedge CLK);
            EN = 1;
            D = 1;
            @(posedge CLK);
            #2;

            #3;
            RESET = 0;
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: D toggling while EN is low");
            test_num = 7;
            reset_dut();

            @(negedge CLK);
            EN = 1;
            D = 1;
            @(posedge CLK);

            @(negedge CLK);
            EN = 0;
            D = 0; @(posedge CLK);
            D = 1; @(posedge CLK);
            D = 0; @(posedge CLK);
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
        $dumpvars(0,CLK, D, EN, RESET, Q, Q_N);
    end

endmodule
