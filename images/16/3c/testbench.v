`timescale 1ns/1ps

module JK_flip_flop_tb;

    // Testbench signals (sequential circuit)
    reg J;
    reg K;
    reg clk;
    reg preset;
    reg rst_n;
    wire Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    JK_flip_flop dut (
        .J(J),
        .K(K),
        .clk(clk),
        .preset(preset),
        .rst_n(rst_n),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst_n = 0;
        preset = 0;
        J = 0;
        K = 0;
        #12;
        rst_n = 1;
        #2;
    end
        endtask
    task testcase001;

    begin
        $display("Testcase 001: Asynchronous Reset");
        test_num = 1;
        reset_dut();

        rst_n = 0;
        #5;
        rst_n = 1;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: Asynchronous Preset");
        test_num = 2;
        reset_dut();
        preset = 1;
        #5;
        preset = 0;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: Synchronous Set (J=1, K=0)");
        test_num = 3;
        reset_dut();
        @(negedge clk);
        J = 1;
        K = 0;
        @(posedge clk);
        #2;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Synchronous Reset (J=0, K=1)");
        test_num = 4;
        reset_dut();

        preset = 1; #2; preset = 0;
        @(negedge clk);
        J = 0;
        K = 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Hold State (J=0, K=0)");
        test_num = 5;
        reset_dut();

        preset = 1; #2; preset = 0;
        @(negedge clk);
        J = 0;
        K = 0;
        @(posedge clk);
        #2;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: Toggle State (J=1, K=1)");
        test_num = 6;
        reset_dut();
        @(negedge clk);
        J = 1;
        K = 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase007;

    begin
        $display("Testcase 007: Multiple Toggles");
        test_num = 7;
        reset_dut();
        @(negedge clk);
        J = 1;
        K = 1;
        @(posedge clk);
        @(negedge clk);
        @(posedge clk);
        #2;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase008;

    begin
        $display("Testcase 008: Asynchronous Reset Priority over J/K");
        test_num = 8;
        reset_dut();
        @(negedge clk);
        J = 1;
        K = 0;
        rst_n = 0;
        @(posedge clk);
        #2;
        #1;

        check_outputs(0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("JK_flip_flop Testbench");
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
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%b",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%b",
                         expected_Q);
                $display("  Got:      Q=%b",
                         Q);
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
        $dumpvars(0,J, K, clk, preset, rst_n, Q);
    end

endmodule
