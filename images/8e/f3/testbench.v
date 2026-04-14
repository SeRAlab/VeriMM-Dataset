`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] address;
    reg clock;
    reg reset;
    wire [79:0] readData;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .clock(clock),
        .reset(reset),
        .readData(readData)
    );
    task init_test;

        begin
            reset = 1;
            address = 0;
            @(posedge clock);
            #2 reset = 0;
        end
        endtask

    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Running testcase001: Address 0x0");
        init_test();
        address = 64'h0;
        @(posedge clock);
        #2;
        #1;

        check_outputs(80'h09080706050403020100);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Running testcase002: Address 0xA");
        init_test();
        address = 64'hA;
        @(posedge clock);
        #2;
        #1;

        check_outputs(80'h131211100F0E0D0C0B0A);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Running testcase003: Address 0x20");
        init_test();
        address = 64'h20;
        @(posedge clock);
        #2;
        #1;

        check_outputs(80'h29282726252423222120);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Running testcase004: Address 0x64");
        init_test();
        address = 64'h64;
        @(posedge clock);
        #2;
        #1;

        check_outputs(80'h6D6C6B6A696867666564);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Running testcase005: Address 0xC8");
        init_test();
        address = 64'hC8;
        @(posedge clock);
        #2;
        #1;

        check_outputs(80'hD1D0CFCECDCCCBCAC9C8);
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
        input [79:0] expected_readData;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_readData === (expected_readData ^ readData ^ expected_readData)) begin
                $display("PASS");
                $display("  Outputs: readData=%h",
                         readData);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: readData=%h",
                         expected_readData);
                $display("  Got:      readData=%h",
                         readData);
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

endmodule
