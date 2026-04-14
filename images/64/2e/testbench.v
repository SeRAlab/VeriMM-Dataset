`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] ex_mem_data;
    reg [31:0] mem_wb_data;
    reg [31:0] reg_data;
    reg [1:0] sel;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ex_mem_data(ex_mem_data),
        .mem_wb_data(mem_wb_data),
        .reg_data(reg_data),
        .sel(sel),
        .out(out)
    );
    task testcase001;

        begin
            $display("Test Case 001: Selection sel=00 (reg_data)");
            reg_data    = 32'hAAAA_BBBB;
            ex_mem_data = 32'h1111_2222;
            mem_wb_data = 32'h3333_4444;
            sel         = 2'b00;
            #1;

            check_outputs(32'hAAAA_BBBB);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Selection sel=01 (mem_wb_data)");
            reg_data    = 32'hDEAD_BEEF;
            ex_mem_data = 32'hFEED_FACE;
            mem_wb_data = 32'hCAFE_BABE;
            sel         = 2'b01;
            #1;

            check_outputs(32'hCAFE_BABE);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Selection sel=10 (ex_mem_data)");
            reg_data    = 32'h0000_0001;
            ex_mem_data = 32'h0000_0002;
            mem_wb_data = 32'h0000_0003;
            sel         = 2'b10;
            #1;

            check_outputs(32'h0000_0002);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Selection sel=11 (default to reg_data)");
            reg_data    = 32'h8765_4321;
            ex_mem_data = 32'hFFFF_FFFF;
            mem_wb_data = 32'h0000_0000;
            sel         = 2'b11;
            #1;

            check_outputs(32'h8765_4321);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: All Inputs Zeros, sel=01");
            reg_data    = 32'h0000_0000;
            ex_mem_data = 32'h0000_0000;
            mem_wb_data = 32'h0000_0000;
            sel         = 2'b01;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: All Inputs Ones, sel=10");
            reg_data    = 32'hFFFF_FFFF;
            ex_mem_data = 32'hFFFF_FFFF;
            mem_wb_data = 32'hFFFF_FFFF;
            sel         = 2'b10;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase007;

        begin
            $display("Test Case 007: Alternating bits, sel=00");
            reg_data    = 32'h5555_AAAA;
            ex_mem_data = 32'hAAAA_5555;
            mem_wb_data = 32'hFFFF_0000;
            sel         = 2'b00;
            #1;

            check_outputs(32'h5555_AAAA);
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
        input [31:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
