`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg [3:0] req_vector;
    reg reset;
    wire [1:0] grant_vector;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .enable(enable),
        .req_vector(req_vector),
        .reset(reset),
        .grant_vector(grant_vector)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        enable = 0;
        req_vector = 4'b0000;
        @(posedge clk);
        #1;
        reset = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        reset_dut();
        enable = 1;
        req_vector = 4'b0001;
        @(posedge clk);
        #1;
        $display("Testcase 001: Basic Grant (Req 0)");
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        reset_dut();
        enable = 1;
        req_vector = 4'b1000;
        @(posedge clk);
        #1;
        $display("Testcase 002: Basic Grant (Req 3)");
        #1;

        check_outputs(2'b11);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        reset_dut();
        enable = 1;
        req_vector = 4'b1111;
        @(posedge clk);
        #1;
        $display("Testcase 003: Initial Priority Tie-break");
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        reset_dut();
        enable = 1;

        req_vector = 4'b0001;
        @(posedge clk);
        #1;

        req_vector = 4'b0011;
        @(posedge clk);
        #1;
        $display("Testcase 004: LRU Swap (0 used, then 0+1 requested)");
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        reset_dut();
        enable = 1;

        req_vector = 4'b0001; @(posedge clk); #1;

        req_vector = 4'b0010; @(posedge clk); #1;

        req_vector = 4'b0011;
        @(posedge clk);
        #1;
        $display("Testcase 005: LRU History (0 used, 1 used, then 0+1 requested)");
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        reset_dut();
        enable = 1;
        req_vector = 4'b0001; @(posedge clk); #1;
        req_vector = 4'b0010; @(posedge clk); #1;
        req_vector = 4'b0100; @(posedge clk); #1;
        req_vector = 4'b1000; @(posedge clk); #1;
        req_vector = 4'b1111; @(posedge clk); #1;
        $display("Testcase 006: Full Cycle LRU");
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        reset_dut();
        enable = 0;
        req_vector = 4'b1111;
        @(posedge clk);
        #1;
        $display("Testcase 007: Enable Disabled Test");

        #1;


        check_outputs(2'b00);
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
        input [1:0] expected_grant_vector;
        begin
            if (expected_grant_vector === (expected_grant_vector ^ grant_vector ^ expected_grant_vector)) begin
                $display("PASS");
                $display("  Outputs: grant_vector=%h",
                         grant_vector);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: grant_vector=%h",
                         expected_grant_vector);
                $display("  Got:      grant_vector=%h",
                         grant_vector);
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
        $dumpvars(0,clk, enable, req_vector, reset, grant_vector);
    end

endmodule
