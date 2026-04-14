`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg [127:0] key;
    reg [127:0] state;
    wire [127:0] m1__DOT__aes_128_i__DOT__out_reg;
    wire [127:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .key(key),
        .state(state),
        .m1__DOT__aes_128_i__DOT__out_reg(m1__DOT__aes_128_i__DOT__out_reg),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;

            state = 128'h00112233445566778899aabbccddeeff;
            key   = 128'h000102030405060708090a0b0c0d0e0f;


            repeat(20) @(posedge clk);



            #1;




            check_outputs(128'h69c4e0d86a7b0430d8cdb78070b4c55a, ~128'h69c4e0d86a7b0430d8cdb78070b4c55a);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            state = 128'h6bc1bee22e409f96e93d7e117393172a;
            key   = 128'h2b7e151628aed2a6abf7158809cf4f3c;

            repeat(20) @(posedge clk);


            #1;



            check_outputs(128'h3ad77bb40d7a3660a89ecaf32466ef97, ~128'h3ad77bb40d7a3660a89ecaf32466ef97);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            state = 128'h00000000000000000000000000000000;
            key   = 128'h00000000000000000000000000000000;

            repeat(20) @(posedge clk);


            #1;



            check_outputs(128'h66e94bd4ef8a2c3b884cfa59ca342b2e, ~128'h66e94bd4ef8a2c3b884cfa59ca342b2e);
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
        input [127:0] expected_m1__DOT__aes_128_i__DOT__out_reg;
        input [127:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_m1__DOT__aes_128_i__DOT__out_reg === (expected_m1__DOT__aes_128_i__DOT__out_reg ^ m1__DOT__aes_128_i__DOT__out_reg ^ expected_m1__DOT__aes_128_i__DOT__out_reg) &&
                expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: m1__DOT__aes_128_i__DOT__out_reg=%h, out=%h",
                         m1__DOT__aes_128_i__DOT__out_reg, out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: m1__DOT__aes_128_i__DOT__out_reg=%h, out=%h",
                         expected_m1__DOT__aes_128_i__DOT__out_reg, expected_out);
                $display("  Got:      m1__DOT__aes_128_i__DOT__out_reg=%h, out=%h",
                         m1__DOT__aes_128_i__DOT__out_reg, out);
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
