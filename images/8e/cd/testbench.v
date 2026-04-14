`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] from_alu_data;
    reg [31:0] from_mem_data;
    reg memtoreg;
    reg [4:0] regfile_addr_in;
    reg regwrite_in;
    wire [4:0] regfile_addr_out;
    wire [31:0] regfile_data;
    wire regwrite_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .from_alu_data(from_alu_data),
        .from_mem_data(from_mem_data),
        .memtoreg(memtoreg),
        .regfile_addr_in(regfile_addr_in),
        .regwrite_in(regwrite_in),
        .regfile_addr_out(regfile_addr_out),
        .regfile_data(regfile_data),
        .regwrite_out(regwrite_out)
    );
    task testcase001;

        begin
            $display("Test Case 001: memtoreg=0 (ALU path), regwrite_in=1");
            from_mem_data = 32'hAAAA_BBBB;
            from_alu_data = 32'h1234_5678;
            regfile_addr_in = 5'd10;
            regwrite_in = 1'b1;
            memtoreg = 1'b0;
            #1;

            check_outputs(5'd10, 32'h1234_5678, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: memtoreg=0 (ALU path), regwrite_in=0");
            from_mem_data = 32'h0000_0000;
            from_alu_data = 32'hDEAD_BEEF;
            regfile_addr_in = 5'd5;
            regwrite_in = 1'b0;
            memtoreg = 1'b0;
            #1;

            check_outputs(5'd5, 32'hDEAD_BEEF, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: memtoreg=1 (Memory path), regwrite_in=1");
            from_mem_data = 32'hCAFE_BABE;
            from_alu_data = 32'h1111_2222;
            regfile_addr_in = 5'd15;
            regwrite_in = 1'b1;
            memtoreg = 1'b1;

            #1;


            check_outputs(5'b11111, 32'hCAFE_BABE, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: memtoreg=1 (Memory path), regwrite_in=0");
            from_mem_data = 32'h5555_AAAA;
            from_alu_data = 32'hFFFF_FFFF;
            regfile_addr_in = 5'd20;
            regwrite_in = 1'b0;
            memtoreg = 1'b1;

            #1;


            check_outputs(5'b11111, 32'h5555_AAAA, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Edge case - Address input 31 with memtoreg=0");
            from_mem_data = 32'h8888_8888;
            from_alu_data = 32'h7777_7777;
            regfile_addr_in = 5'b11111;
            regwrite_in = 1'b1;
            memtoreg = 1'b0;
            #1;

            check_outputs(5'b11111, 32'h7777_7777, 1'b1);
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
        input [4:0] expected_regfile_addr_out;
        input [31:0] expected_regfile_data;
        input expected_regwrite_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_regfile_addr_out === (expected_regfile_addr_out ^ regfile_addr_out ^ expected_regfile_addr_out) &&
                expected_regfile_data === (expected_regfile_data ^ regfile_data ^ expected_regfile_data) &&
                expected_regwrite_out === (expected_regwrite_out ^ regwrite_out ^ expected_regwrite_out)) begin
                $display("PASS");
                $display("  Outputs: regfile_addr_out=%h, regfile_data=%h, regwrite_out=%b",
                         regfile_addr_out, regfile_data, regwrite_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: regfile_addr_out=%h, regfile_data=%h, regwrite_out=%b",
                         expected_regfile_addr_out, expected_regfile_data, expected_regwrite_out);
                $display("  Got:      regfile_addr_out=%h, regfile_data=%h, regwrite_out=%b",
                         regfile_addr_out, regfile_data, regwrite_out);
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
