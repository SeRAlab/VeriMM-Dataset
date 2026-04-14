`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] in_a;
    reg [31:0] in_b;
    reg [31:0] in_c;
    reg [1:0] sel;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in_a(in_a),
        .in_b(in_b),
        .in_c(in_c),
        .sel(sel),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Select in_a (sel = 00)");
            in_a = 32'hAAAA_AAAA;
            in_b = 32'hBBBB_BBBB;
            in_c = 32'hCCCC_CCCC;
            sel  = 2'b00;
            #1;

            check_outputs(32'hAAAA_AAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Select in_b (sel = 01)");
            in_a = 32'h1234_5678;
            in_b = 32'h8765_4321;
            in_c = 32'h0000_0000;
            sel  = 2'b01;
            #1;

            check_outputs(32'h8765_4321);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Select in_c (sel = 10)");
            in_a = 32'hFFFF_FFFF;
            in_b = 32'h0000_0000;
            in_c = 32'h5555_5555;
            sel  = 2'b10;
            #1;

            check_outputs(32'h5555_5555);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Select in_a with DEAD_BEEF");
            in_a = 32'hDEAD_BEEF;
            in_b = 32'hFEED_FACE;
            in_c = 32'hCAFE_BABE;
            sel  = 2'b00;
            #1;

            check_outputs(32'hDEAD_BEEF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Select in_b (all bits 1)");
            in_a = 32'h0000_0000;
            in_b = 32'hFFFF_FFFF;
            in_c = 32'h0000_0000;
            sel  = 2'b01;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Select in_c (zero input)");
            in_a = 32'hFFFF_FFFF;
            in_b = 32'hFFFF_FFFF;
            in_c = 32'h0000_0000;
            sel  = 2'b10;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case 007: Switch from in_a to in_c");
            in_a = 32'h1111_1111;
            in_b = 32'h2222_2222;
            in_c = 32'h3333_3333;
            sel  = 2'b00;
            #5;
            sel  = 2'b10;
            #1;

            check_outputs(32'h3333_3333);
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
