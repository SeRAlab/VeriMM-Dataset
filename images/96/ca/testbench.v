`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clear;
    reg clk;
    reg load;
    reg [47:0] mantise;
    wire [47:0] saved_mants;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clear(clear),
        .clk(clk),
        .load(load),
        .mantise(mantise),
        .saved_mants(saved_mants)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        clear = 1;
        load = 0;
        mantise = 0;
        @(posedge clk);
        #1;
        clear = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case 001: Load a standard 48-bit value");
        mantise = 48'hA1B2C3D4E5F6;
        load = 1;
        @(posedge clk);
        #1;
        load = 0;
        #1;

        check_outputs(48'hA1B2C3D4E5F6);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case 002: Hold value when load is disabled");

        mantise = 48'h5555AAAA5555;
        load = 1;
        @(posedge clk);
        #1;

        mantise = 48'hFFFFFFFFFFFF;
        load = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(48'h5555AAAA5555);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case 003: Clear functionality while data is stored");

        mantise = 48'h123456789ABC;
        load = 1;
        @(posedge clk);
        #1;
        load = 0;

        clear = 1;
        @(posedge clk);
        #1;
        clear = 0;
        #1;

        check_outputs(48'h000000000000);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case 004: Priority of clear over load");
        mantise = 48'hCAFEBABEDEAD;
        load = 1;
        clear = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(48'h000000000000);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case 005: Loading all ones");
        mantise = 48'hFFFFFFFFFFFF;
        load = 1;
        @(posedge clk);
        #1;
        load = 0;
        #1;

        check_outputs(48'hFFFFFFFFFFFF);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case 006: Multiple consecutive loads");
        mantise = 48'h111111111111;
        load = 1;
        @(posedge clk);
        #1;
        mantise = 48'h222222222222;
        @(posedge clk);
        #1;
        mantise = 48'h333333333333;
        @(posedge clk);
        #1;
        load = 0;
        #1;

        check_outputs(48'h333333333333);
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
        input [47:0] expected_saved_mants;
        begin
            if (expected_saved_mants === (expected_saved_mants ^ saved_mants ^ expected_saved_mants)) begin
                $display("PASS");
                $display("  Outputs: saved_mants=%h",
                         saved_mants);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: saved_mants=%h",
                         expected_saved_mants);
                $display("  Got:      saved_mants=%h",
                         saved_mants);
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
        $dumpvars(0,clear, clk, load, mantise, saved_mants);
    end

endmodule
