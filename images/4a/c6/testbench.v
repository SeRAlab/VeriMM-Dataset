`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    wire [7:0] and_out;
    wire [7:0] not_out;
    wire [7:0] or_out;
    wire [7:0] xor_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .and_out(and_out),
        .not_out(not_out),
        .or_out(or_out),
        .xor_out(xor_out)
    );
    task testcase001;

    begin
        $display("Test Case 001: All Zeros");
        test_num = test_num + 1;
        a = 8'h00;
        b = 8'h00;




        #1;





        check_outputs(8'h00, 8'hff, 8'h00, 8'h00);
    end
        endtask

    task testcase002;

    begin
        $display("Test Case 002: All Ones");
        test_num = test_num + 1;
        a = 8'hff;
        b = 8'hff;




        #1;





        check_outputs(8'hff, 8'h00, 8'hff, 8'h00);
    end
        endtask

    task testcase003;

    begin
        $display("Test Case 003: Alternating Bits");
        test_num = test_num + 1;
        a = 8'h55;
        b = 8'haa;




        #1;





        check_outputs(8'h00, 8'haa, 8'hff, 8'hff);
    end
        endtask

    task testcase004;

    begin
        $display("Test Case 004: Half-and-Half Patterns");
        test_num = test_num + 1;
        a = 8'hf0;
        b = 8'h0f;




        #1;





        check_outputs(8'h00, 8'h0f, 8'hff, 8'hff);
    end
        endtask

    task testcase005;

    begin
        $display("Test Case 005: Identical Inputs");
        test_num = test_num + 1;
        a = 8'h3c;
        b = 8'h3c;




        #1;





        check_outputs(8'h3c, 8'hc3, 8'h3c, 8'h00);
    end
        endtask

    task testcase006;

    begin
        $display("Test Case 006: Bitmasking Pattern");
        test_num = test_num + 1;
        a = 8'he1;
        b = 8'hf0;




        #1;





        check_outputs(8'he0, 8'h1e, 8'hf1, 8'h11);
    end
        endtask

    task testcase007;

    begin
        $display("Test Case 007: Single Bit Checks");
        test_num = test_num + 1;
        a = 8'h01;
        b = 8'h80;




        #1;





        check_outputs(8'h00, 8'hfe, 8'h81, 8'h81);
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
        input [7:0] expected_and_out;
        input [7:0] expected_not_out;
        input [7:0] expected_or_out;
        input [7:0] expected_xor_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_and_out === (expected_and_out ^ and_out ^ expected_and_out) &&
                expected_not_out === (expected_not_out ^ not_out ^ expected_not_out) &&
                expected_or_out === (expected_or_out ^ or_out ^ expected_or_out) &&
                expected_xor_out === (expected_xor_out ^ xor_out ^ expected_xor_out)) begin
                $display("PASS");
                $display("  Outputs: and_out=%h, not_out=%h, or_out=%h, xor_out=%h",
                         and_out, not_out, or_out, xor_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: and_out=%h, not_out=%h, or_out=%h, xor_out=%h",
                         expected_and_out, expected_not_out, expected_or_out, expected_xor_out);
                $display("  Got:      and_out=%h, not_out=%h, or_out=%h, xor_out=%h",
                         and_out, not_out, or_out, xor_out);
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
