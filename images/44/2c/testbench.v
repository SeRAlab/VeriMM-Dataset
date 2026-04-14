`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    wire [63:0] urn;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rst(rst),
        .urn(urn)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            rst = 1;
            @(posedge clk);
            rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning Testcase 001: Initial Reset State Check...");
            reset_dut();



            #1;




            check_outputs(urn);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Testcase 002: Single Cycle Transition...");
            reset_dut();
            @(posedge clk);

            #1;


            check_outputs(urn);
        end
        endtask

    task testcase003;

        integer i;
        begin
            $display("\nRunning Testcase 003: 20-Cycle State Check...");
            reset_dut();
            repeat(20) @(posedge clk);
            #1;

            check_outputs(urn);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Testcase 004: Determinism/Repeatability Test...");
            reset_dut();
            repeat(5) @(posedge clk);
            captured_value = urn;

            reset_dut();
            repeat(5) @(posedge clk);

            #1;


            check_outputs(captured_value);
        end
        endtask

    task testcase005;

        reg [63:0] reset_val;
        begin
            $display("\nRunning Testcase 005: Non-Stuck State Check...");
            reset_dut();
            reset_val = urn;
            repeat(2) @(posedge clk);

            test_num = test_num + 1;
            if (urn !== reset_val && urn !== 64'b0) begin
                $display("Test Case %0d: PASS (Value changed from reset)", test_num);
                pass_count = pass_count + 1;
            end else begin
                $display("Test Case %0d: FAIL (Value stuck or zero)", test_num);
                fail_count = fail_count + 1;
            end
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
        input [63:0] expected_urn;
        begin
            if (expected_urn === (expected_urn ^ urn ^ expected_urn)) begin
                $display("PASS");
                $display("  Outputs: urn=%h",
                         urn);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: urn=%h",
                         expected_urn);
                $display("  Got:      urn=%h",
                         urn);
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
        $dumpvars(0,clk, rst, urn);
    end

endmodule
