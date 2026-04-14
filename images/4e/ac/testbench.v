`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] in;
    reg [31:0] sel;
    wire [1:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .sel(sel),
        .out(out)
    );
    task testcase001;

    begin
        $display("Test Case 001: Select first 2 bits (index 0)");
        test_num = 1;
        in = 16'h0003;
        sel = 32'd0;
        #1;

        check_outputs(2'b11);
    end
        endtask

    task testcase002;

    begin
        $display("Test Case 002: Select second 2 bits (index 1)");
        test_num = 2;
        in = 16'h000C;
        sel = 32'd1;
        #1;

        check_outputs(2'b11);
    end
        endtask

    task testcase003;

    begin
        $display("Test Case 003: Select last 2 bits (index 7)");
        test_num = 3;
        in = 16'hC000;
        sel = 32'd7;
        #1;

        check_outputs(2'b11);
    end
        endtask

    task testcase004;

    begin
        $display("Test Case 004: Alternating pattern (AAAA) index 2");
        test_num = 4;
        in = 16'hAAAA;
        sel = 32'd2;
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase005;

    begin
        $display("Test Case 005: Alternating pattern (5555) index 3");
        test_num = 5;
        in = 16'h5555;
        sel = 32'd3;
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase006;

    begin
        $display("Test Case 006: All ones, index 4");
        test_num = 6;
        in = 16'hFFFF;
        sel = 32'd4;
        #1;

        check_outputs(2'b11);
    end
        endtask

    task testcase007;

    begin
        $display("Test Case 007: All zeros, index 5");
        test_num = 7;
        in = 16'h0000;
        sel = 32'd5;
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase008;

    begin
        $display("Test Case 008: Complex pattern, index 6");
        test_num = 8;
        in = 16'h2D00;
        sel = 32'd6;
        #1;

        check_outputs(2'b10);
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
        input [1:0] expected_out;
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
