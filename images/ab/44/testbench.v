`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] in;
    reg [2:0] select;
    wire [7:0] final_output;
    wire o0;
    wire o1;
    wire o2;
    wire [7:0] out_hi;
    wire [7:0] out_lo;
    wire [2:0] outv;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .select(select),
        .final_output(final_output),
        .o0(o0),
        .o1(o1),
        .o2(o2),
        .out_hi(out_hi),
        .out_lo(out_lo),
        .outv(outv)
    );
    task testcase001;

        begin
            $display("Testcase 001: Split check and Shift 0");
            in = 16'h1234;
            select = 3'b000;

            #1;


            check_outputs(8'h12, 1'b0, 1'b0, 1'b0, 8'h12, 8'h34, 3'b000);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Alternating bits, Shift 1");
            in = 16'hABCD;
            select = 3'b001;

            #1;


            check_outputs(8'h55, 1'b1, 1'b0, 1'b0, 8'hAB, 8'hCD, 3'b001);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: High nibble to low nibble, Shift 4");
            in = 16'hF00F;
            select = 3'b100;

            #1;


            check_outputs(8'h0F, 1'b0, 1'b0, 1'b1, 8'hF0, 8'h0F, 3'b100);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Maximum shift (7 bits)");
            in = 16'h89AB;
            select = 3'b111;

            #1;


            check_outputs(8'h01, 1'b1, 1'b1, 1'b1, 8'h89, 8'hAB, 3'b111);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Zero data check");
            in = 16'h0000;
            select = 3'b101;

            #1;


            check_outputs(8'h00, 1'b1, 1'b0, 1'b1, 8'h00, 8'h00, 3'b101);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: All ones shifted");
            in = 16'hFFFF;
            select = 3'b010;

            #1;


            check_outputs(8'h3F, 1'b0, 1'b1, 1'b0, 8'hFF, 8'hFF, 3'b010);
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
        input [7:0] expected_final_output;
        input expected_o0;
        input expected_o1;
        input expected_o2;
        input [7:0] expected_out_hi;
        input [7:0] expected_out_lo;
        input [2:0] expected_outv;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_final_output === (expected_final_output ^ final_output ^ expected_final_output) &&
                expected_o0 === (expected_o0 ^ o0 ^ expected_o0) &&
                expected_o1 === (expected_o1 ^ o1 ^ expected_o1) &&
                expected_o2 === (expected_o2 ^ o2 ^ expected_o2) &&
                expected_out_hi === (expected_out_hi ^ out_hi ^ expected_out_hi) &&
                expected_out_lo === (expected_out_lo ^ out_lo ^ expected_out_lo) &&
                expected_outv === (expected_outv ^ outv ^ expected_outv)) begin
                $display("PASS");
                $display("  Outputs: final_output=%h, o0=%b, o1=%b, o2=%b, out_hi=%h, out_lo=%h, outv=%h",
                         final_output, o0, o1, o2, out_hi, out_lo, outv);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: final_output=%h, o0=%b, o1=%b, o2=%b, out_hi=%h, out_lo=%h, outv=%h",
                         expected_final_output, expected_o0, expected_o1, expected_o2, expected_out_hi, expected_out_lo, expected_outv);
                $display("  Got:      final_output=%h, o0=%b, o1=%b, o2=%b, out_hi=%h, out_lo=%h, outv=%h",
                         final_output, o0, o1, o2, out_hi, out_lo, outv);
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
