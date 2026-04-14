`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] encoded_in;
    reg end_flag;
    reg [7:0] prob_in;
    reg [7:0] symbol_in;
    wire [31:0] encoded_out;
    wire [7:0] symbol_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .encoded_in(encoded_in),
        .end_flag(end_flag),
        .prob_in(prob_in),
        .symbol_in(symbol_in),
        .encoded_out(encoded_out),
        .symbol_out(symbol_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Encoding - Symbol 0x05", test_num);

            symbol_in = 8'h05;
            prob_in   = 8'h40;
            end_flag  = 0;

            encoded_in = 32'h0;



            #1;




            check_outputs(32'h000000A0, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Decoding - Value 0x12345678", test_num);
            symbol_in = 8'h00;
            prob_in   = 8'h00;
            end_flag  = 0;

            encoded_in = 32'h12345678;


            #1;



            check_outputs(32'h00000000, 8'hAC);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Encoding with End Flag", test_num);
            symbol_in = 8'hFF;
            prob_in   = 8'h10;
            end_flag  = 1;
            encoded_in = 32'hFFFFFFFF;


            #1;



            check_outputs(32'hFFFF0000, 8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Low Probability Symbol", test_num);
            symbol_in = 8'h01;
            prob_in   = 8'h01;
            end_flag  = 0;
            encoded_in = 32'h00000001;


            #1;



            check_outputs(32'h00000005, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: High Probability Symbol", test_num);
            symbol_in = 8'h0A;
            prob_in   = 8'hFE;
            end_flag  = 0;
            encoded_in = 32'h80000000;


            #1;



            check_outputs(32'h0000000A, 8'h40);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum Symbol Value Decoding", test_num);
            symbol_in = 8'h00;
            prob_in   = 8'h80;
            end_flag  = 0;
            encoded_in = 32'hFFFFFFFE;


            #1;



            check_outputs(32'h00000080, 8'hFF);
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
        input [31:0] expected_encoded_out;
        input [7:0] expected_symbol_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_encoded_out === (expected_encoded_out ^ encoded_out ^ expected_encoded_out) &&
                expected_symbol_out === (expected_symbol_out ^ symbol_out ^ expected_symbol_out)) begin
                $display("PASS");
                $display("  Outputs: encoded_out=%h, symbol_out=%h",
                         encoded_out, symbol_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: encoded_out=%h, symbol_out=%h",
                         expected_encoded_out, expected_symbol_out);
                $display("  Got:      encoded_out=%h, symbol_out=%h",
                         encoded_out, symbol_out);
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
