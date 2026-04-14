`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg a;
    reg b;
    reg [7:0] in_hi;
    reg [7:0] in_lo;
    wire out;
    wire [15:0] out_concat;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .in_hi(in_hi),
        .in_lo(in_lo),
        .out(out),
        .out_concat(out_concat)
    );
    task testcase001;

        begin
            test_num = 1;
            a = 1; b = 1;
            in_hi = 8'h00;
            in_lo = 8'h40;
            #10;
            #1;

            check_outputs(1'b0, 16'h0040);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a = 0; b = 0;
            in_hi = 8'h00;
            in_lo = 8'h41;
            #10;
            #1;

            check_outputs(1'b1, 16'h0041);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a = 0; b = 1;
            in_hi = 8'h00;
            in_lo = 8'h80;
            #10;
            #1;

            check_outputs(1'b1, 16'h0080);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a = 1; b = 1;
            in_hi = 8'h01;
            in_lo = 8'h00;
            #10;
            #1;

            check_outputs(1'b0, 16'h0100);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            a = 1; b = 0;
            in_hi = 8'hFF;
            in_lo = 8'hFF;
            #10;
            #1;

            check_outputs(1'b1, 16'hFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            a = 1; b = 1;
            in_hi = 8'h00;
            in_lo = 8'h7F;
            #10;
            #1;

            check_outputs(1'b1, 16'h007F);
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
        input expected_out;
        input [15:0] expected_out_concat;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out) &&
                expected_out_concat === (expected_out_concat ^ out_concat ^ expected_out_concat)) begin
                $display("PASS");
                $display("  Outputs: out=%b, out_concat=%h",
                         out, out_concat);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b, out_concat=%h",
                         expected_out, expected_out_concat);
                $display("  Got:      out=%b, out_concat=%h",
                         out, out_concat);
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
