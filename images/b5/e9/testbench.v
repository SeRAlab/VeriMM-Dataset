`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] inp;
    wire [7:0] out_shl_s;
    wire [7:0] out_shl_u;
    wire [7:0] out_shr_s;
    wire [7:0] out_shr_u;
    wire [7:0] out_sla;
    wire [7:0] out_sll;
    wire [7:0] out_sra;
    wire [7:0] out_srl;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .inp(inp),
        .out_shl_s(out_shl_s),
        .out_shl_u(out_shl_u),
        .out_shr_s(out_shr_s),
        .out_shr_u(out_shr_u),
        .out_sla(out_sla),
        .out_sll(out_sll),
        .out_sra(out_sra),
        .out_srl(out_srl)
    );
    task testcase001;

        begin
            $display("Test Case 001: All zeros");
            inp = 8'h00;

            #1;


            check_outputs(8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: LSB only");
            inp = 8'h01;

            #1;


            check_outputs(8'h02, 8'h02, 8'h00, 8'h00, 8'h02, 8'h02, 8'h00, 8'h00);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Negative MSB boundary");
            inp = 8'h80;

            #1;


            check_outputs(8'h00, 8'h00, 8'hC0, 8'h40, 8'h00, 8'h00, 8'hC0, 8'h40);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: All ones");
            inp = 8'hFF;

            #1;


            check_outputs(8'hFE, 8'hFE, 8'hFF, 8'h7F, 8'hFE, 8'hFE, 8'hFF, 8'h7F);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Positive boundary");
            inp = 8'h7F;

            #1;


            check_outputs(8'hFE, 8'hFE, 8'h3F, 8'h3F, 8'hFE, 8'hFE, 8'h3F, 8'h3F);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: Alternating bits 01010101");
            inp = 8'h55;

            #1;


            check_outputs(8'hAA, 8'hAA, 8'h2A, 8'h2A, 8'hAA, 8'hAA, 8'h2A, 8'h2A);
        end
        endtask

    task testcase007;

        begin
            $display("Test Case 007: Alternating bits 10101010");
            inp = 8'hAA;

            #1;


            check_outputs(8'h54, 8'h54, 8'hD5, 8'h55, 8'h54, 8'h54, 8'hD5, 8'h55);
        end
        endtask

    task testcase008;

        begin
            $display("Test Case 008: Negative small value -2");
            inp = 8'hFE;

            #1;


            check_outputs(8'hFC, 8'hFC, 8'hFF, 8'h7F, 8'hFC, 8'hFC, 8'hFF, 8'h7F);
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
        input [7:0] expected_out_shl_s;
        input [7:0] expected_out_shl_u;
        input [7:0] expected_out_shr_s;
        input [7:0] expected_out_shr_u;
        input [7:0] expected_out_sla;
        input [7:0] expected_out_sll;
        input [7:0] expected_out_sra;
        input [7:0] expected_out_srl;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_shl_s === (expected_out_shl_s ^ out_shl_s ^ expected_out_shl_s) &&
                expected_out_shl_u === (expected_out_shl_u ^ out_shl_u ^ expected_out_shl_u) &&
                expected_out_shr_s === (expected_out_shr_s ^ out_shr_s ^ expected_out_shr_s) &&
                expected_out_shr_u === (expected_out_shr_u ^ out_shr_u ^ expected_out_shr_u) &&
                expected_out_sla === (expected_out_sla ^ out_sla ^ expected_out_sla) &&
                expected_out_sll === (expected_out_sll ^ out_sll ^ expected_out_sll) &&
                expected_out_sra === (expected_out_sra ^ out_sra ^ expected_out_sra) &&
                expected_out_srl === (expected_out_srl ^ out_srl ^ expected_out_srl)) begin
                $display("PASS");
                $display("  Outputs: out_shl_s=%h, out_shl_u=%h, out_shr_s=%h, out_shr_u=%h, out_sla=%h, out_sll=%h, out_sra=%h, out_srl=%h",
                         out_shl_s, out_shl_u, out_shr_s, out_shr_u, out_sla, out_sll, out_sra, out_srl);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_shl_s=%h, out_shl_u=%h, out_shr_s=%h, out_shr_u=%h, out_sla=%h, out_sll=%h, out_sra=%h, out_srl=%h",
                         expected_out_shl_s, expected_out_shl_u, expected_out_shr_s, expected_out_shr_u, expected_out_sla, expected_out_sll, expected_out_sra, expected_out_srl);
                $display("  Got:      out_shl_s=%h, out_shl_u=%h, out_shr_s=%h, out_shr_u=%h, out_sla=%h, out_sll=%h, out_sra=%h, out_srl=%h",
                         out_shl_s, out_shl_u, out_shr_s, out_shr_u, out_sla, out_sll, out_sra, out_srl);
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
