`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg [31:0] io_addr;
    wire [31:0] io_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .io_addr(io_addr),
        .io_out(io_out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Running Testcase 001: Read Index 0");

        io_addr = 32'h0;
        @(posedge clk);
        #1;

        check_outputs(32'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Running Testcase 002: Read Index 1");
        io_addr = 32'h1;
        @(posedge clk);
        #1;

        check_outputs(32'h1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Running Testcase 003: Read Index 7");
        io_addr = 32'h7;
        @(posedge clk);
        #1;

        check_outputs(32'h7);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Running Testcase 004: Read Address 8 (Wraps to Index 0)");
        io_addr = 32'h8;
        @(posedge clk);
        #1;

        check_outputs(32'h0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Running Testcase 005: Read Address 0x12345673 (Index 3)");
        io_addr = 32'h12345673;
        @(posedge clk);
        #1;

        check_outputs(32'h3);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Running Testcase 006: Read Address 0xFFFFFFFF (Index 7)");
        io_addr = 32'hFFFFFFFF;
        @(posedge clk);
        #1;

        check_outputs(32'h7);
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
        input [31:0] expected_io_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_io_out === (expected_io_out ^ io_out ^ expected_io_out)) begin
                $display("PASS");
                $display("  Outputs: io_out=%h",
                         io_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: io_out=%h",
                         expected_io_out);
                $display("  Got:      io_out=%h",
                         io_out);
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
