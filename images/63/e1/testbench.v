`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clock;
    reg [3:0] Columns;
    reg Reset;
    reg [3:0] Rows;
    wire Found;
    wire [3:0] OnesDigit;
    wire [3:0] TensDigit;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clock(Clock),
        .Columns(Columns),
        .Reset(Reset),
        .Rows(Rows),
        .Found(Found),
        .OnesDigit(OnesDigit),
        .TensDigit(TensDigit)
    );

    // Clock generation (10ns period)
    initial begin
        Clock = 0;
        forever #5 Clock = ~Clock;
    end

        task reset_dut;

        begin
            Reset = 1;
            Columns = 4'b0;
            Rows = 4'b0;
            @(posedge Clock);
            #1 Reset = 0;
            @(posedge Clock);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Initial state after Reset");
            reset_dut();
            test_num = test_num + 1;
            Columns = 4'b0000;
            Rows = 4'b0000;
            @(posedge Clock);
            #1;
            #1;

            check_outputs(1'b0, 4'h0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Pressing Key '1' (R0, C0)");
            reset_dut();
            test_num = test_num + 1;
            Rows = 4'b0001;
            Columns = 4'b0001;
            @(posedge Clock);
            #1;
            #1;

            check_outputs(1'b1, 4'h1, 4'h0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Pressing Key '5' (R1, C1)");
            reset_dut();
            test_num = test_num + 1;
            Rows = 4'b0010;
            Columns = 4'b0010;
            @(posedge Clock);
            #1;
            #1;

            check_outputs(1'b1, 4'h5, 4'h0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Pressing Key '9' (R2, C2)");
            reset_dut();
            test_num = test_num + 1;
            Rows = 4'b0100;
            Columns = 4'b0100;
            @(posedge Clock);
            #1;
            #1;

            check_outputs(1'b1, 4'h9, 4'h0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Pressing Key '0' (R3, C1)");
            reset_dut();
            test_num = test_num + 1;
            Rows = 4'b1000;
            Columns = 4'b0010;
            @(posedge Clock);
            #1;
            #1;

            check_outputs(1'b1, 4'h0, 4'h0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Pressing Boundary Key (R3, C3)");
            reset_dut();
            test_num = test_num + 1;
            Rows = 4'b1000;
            Columns = 4'b1000;
            @(posedge Clock);
            #1;


            #1;



            check_outputs(1'b1, 4'h3, 4'h1);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Multiple rows active (Invalid Input)");
            reset_dut();
            test_num = test_num + 1;
            Rows = 4'b1100;
            Columns = 4'b0001;
            @(posedge Clock);
            #1;

            #1;


            check_outputs(1'b0, 4'h0, 4'h0);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Row active but no Column (Incomplete Input)");
            reset_dut();
            test_num = test_num + 1;
            Rows = 4'b0001;
            Columns = 4'b0000;
            @(posedge Clock);
            #1;
            #1;

            check_outputs(1'b0, 4'h0, 4'h0);
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
        input expected_Found;
        input [3:0] expected_OnesDigit;
        input [3:0] expected_TensDigit;
        begin
            if (expected_Found === (expected_Found ^ Found ^ expected_Found) &&
                expected_OnesDigit === (expected_OnesDigit ^ OnesDigit ^ expected_OnesDigit) &&
                expected_TensDigit === (expected_TensDigit ^ TensDigit ^ expected_TensDigit)) begin
                $display("PASS");
                $display("  Outputs: Found=%b, OnesDigit=%h, TensDigit=%h",
                         Found, OnesDigit, TensDigit);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Found=%b, OnesDigit=%h, TensDigit=%h",
                         expected_Found, expected_OnesDigit, expected_TensDigit);
                $display("  Got:      Found=%b, OnesDigit=%h, TensDigit=%h",
                         Found, OnesDigit, TensDigit);
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
        $dumpvars(0,Clock, Columns, Reset, Rows, Found, OnesDigit, TensDigit);
    end

endmodule
