`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    wire clk1;
    wire clk22;
    wire clk24;
    wire clk26;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .clk1(clk1),
        .clk22(clk22),
        .clk24(clk24),
        .clk26(clk26)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            force dut.q = 27'h0;
            @(posedge clk);
            #1;
            release dut.q;
        end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        $display("Testcase 001: Checking initial state (q=0)");
        #1;

        check_outputs(1'b0, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        @(posedge clk);
        #1;
        $display("Testcase 002: Checking clk1 (q[0]) after 1 cycle");
        #1;

        check_outputs(1'b1, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        repeat(2) @(posedge clk);
        #1;
        $display("Testcase 003: Checking clk1 (q[0]) after 2 cycles");
        #1;

        check_outputs(1'b0, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        force dut.q = 27'h1FFFFF;
        @(posedge clk);
        #1;
        $display("Testcase 004: Checking clk22 transition to high (bit 21)");
        #1;

        check_outputs(1'b0, 1'b1, 1'b0, 1'b0);
        release dut.q;
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        force dut.q = 27'h3FFFFF;
        @(posedge clk);
        #1;
        $display("Testcase 005: Checking clk22 transition to low (bit 21)");
        #1;

        check_outputs(1'b0, 1'b0, 1'b0, 1'b0);
        release dut.q;
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();
        force dut.q = 27'h7FFFFF;
        @(posedge clk);
        #1;
        $display("Testcase 006: Checking clk24 transition to high (bit 23)");
        #1;

        check_outputs(1'b0, 1'b0, 1'b1, 1'b0);
        release dut.q;
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        reset_dut();
        force dut.q = 27'hFFFFFF;
        @(posedge clk);
        #1;
        $display("Testcase 007: Checking clk24 transition to low (bit 23)");
        #1;

        check_outputs(1'b0, 1'b0, 1'b0, 1'b0);
        release dut.q;
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        reset_dut();
        force dut.q = 27'h1FFFFFF;
        @(posedge clk);
        #1;
        $display("Testcase 008: Checking clk26 transition to high (bit 25)");
        #1;

        check_outputs(1'b0, 1'b0, 1'b0, 1'b1);
        release dut.q;
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        reset_dut();
        force dut.q = 27'h3FFFFFF;
        @(posedge clk);
        #1;
        $display("Testcase 009: Checking clk26 transition to low (bit 25)");
        #1;

        check_outputs(1'b0, 1'b0, 1'b0, 1'b0);
        release dut.q;
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
        input expected_clk1;
        input expected_clk22;
        input expected_clk24;
        input expected_clk26;
        begin
            if (expected_clk1 === (expected_clk1 ^ clk1 ^ expected_clk1) &&
                expected_clk22 === (expected_clk22 ^ clk22 ^ expected_clk22) &&
                expected_clk24 === (expected_clk24 ^ clk24 ^ expected_clk24) &&
                expected_clk26 === (expected_clk26 ^ clk26 ^ expected_clk26)) begin
                $display("PASS");
                $display("  Outputs: clk1=%b, clk22=%b, clk24=%b, clk26=%b",
                         clk1, clk22, clk24, clk26);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk1=%b, clk22=%b, clk24=%b, clk26=%b",
                         expected_clk1, expected_clk22, expected_clk24, expected_clk26);
                $display("  Got:      clk1=%b, clk22=%b, clk24=%b, clk26=%b",
                         clk1, clk22, clk24, clk26);
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
        $dumpvars(0,clk, clk1, clk22, clk24, clk26);
    end

endmodule
