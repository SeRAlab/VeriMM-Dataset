`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] io_ins_0_addr;
    reg io_ins_0_isWr;
    reg [15:0] io_ins_0_size;
    wire [63:0] io_out_addr;
    wire io_out_isWr;
    wire [15:0] io_out_size;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .io_ins_0_addr(io_ins_0_addr),
        .io_ins_0_isWr(io_ins_0_isWr),
        .io_ins_0_size(io_ins_0_size),
        .io_out_addr(io_out_addr),
        .io_out_isWr(io_out_isWr),
        .io_out_size(io_out_size)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Basic Read Operation");
            io_ins_0_addr = 64'h0000_0000_1234_5678;
            io_ins_0_isWr = 1'b0;
            io_ins_0_size = 16'h0008;
            #1;

            check_outputs(64'h0000_0000_1234_5678, 1'b0, 16'h0008);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Basic Write Operation");
            io_ins_0_addr = 64'hDEAD_BEEF_CAFE_BABE;
            io_ins_0_isWr = 1'b1;
            io_ins_0_size = 16'h0040;
            #1;

            check_outputs(64'hDEAD_BEEF_CAFE_BABE, 1'b1, 16'h0040);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: All Zeros");
            io_ins_0_addr = 64'h0;
            io_ins_0_isWr = 1'b0;
            io_ins_0_size = 16'h0;
            #1;

            check_outputs(64'h0, 1'b0, 16'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: All Ones (Boundary Test)");
            io_ins_0_addr = 64'hFFFF_FFFF_FFFF_FFFF;
            io_ins_0_isWr = 1'b1;
            io_ins_0_size = 16'hFFFF;
            #1;

            check_outputs(64'hFFFF_FFFF_FFFF_FFFF, 1'b1, 16'hFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Alternating Bit Pattern");
            io_ins_0_addr = 64'hAAAA_5555_AAAA_5555;
            io_ins_0_isWr = 1'b0;
            io_ins_0_size = 16'h55AA;
            #1;

            check_outputs(64'hAAAA_5555_AAAA_5555, 1'b0, 16'h55AA);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: High Address, Small Size");
            io_ins_0_addr = 64'hF000_0000_0000_0000;
            io_ins_0_isWr = 1'b1;
            io_ins_0_size = 16'h0001;
            #1;

            check_outputs(64'hF000_0000_0000_0000, 1'b1, 16'h0001);
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
        input [63:0] expected_io_out_addr;
        input expected_io_out_isWr;
        input [15:0] expected_io_out_size;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_io_out_addr === (expected_io_out_addr ^ io_out_addr ^ expected_io_out_addr) &&
                expected_io_out_isWr === (expected_io_out_isWr ^ io_out_isWr ^ expected_io_out_isWr) &&
                expected_io_out_size === (expected_io_out_size ^ io_out_size ^ expected_io_out_size)) begin
                $display("PASS");
                $display("  Outputs: io_out_addr=%h, io_out_isWr=%b, io_out_size=%h",
                         io_out_addr, io_out_isWr, io_out_size);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: io_out_addr=%h, io_out_isWr=%b, io_out_size=%h",
                         expected_io_out_addr, expected_io_out_isWr, expected_io_out_size);
                $display("  Got:      io_out_addr=%h, io_out_isWr=%b, io_out_size=%h",
                         io_out_addr, io_out_isWr, io_out_size);
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
