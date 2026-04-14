`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] in;
    wire [8:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .out(out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All zeros (8'h00) -> Parity bit should be 1", test_num);
        in = 8'h00;
        #1;

        check_outputs(9'h001);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All ones (8'hFF) -> Parity bit should be 1", test_num);
        in = 8'hFF;
        #1;

        check_outputs(9'h1FF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Single bit set (8'h01) -> Parity bit should be 0", test_num);
        in = 8'h01;
        #1;

        check_outputs(9'h002);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Two bits set (8'h03) -> Parity bit should be 1", test_num);
        in = 8'h03;
        #1;

        check_outputs(9'h007);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Alternating bits (8'hAA) -> Parity bit should be 1", test_num);
        in = 8'hAA;
        #1;

        check_outputs(9'h155);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Alternating bits (8'h55) -> Parity bit should be 1", test_num);
        in = 8'h55;
        #1;

        check_outputs(9'h0AB);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Seven bits set (8'h7F) -> Parity bit should be 0", test_num);
        in = 8'h7F;
        #1;

        check_outputs(9'h0FE);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: MSB bit set (8'h80) -> Parity bit should be 0", test_num);
        in = 8'h80;
        #1;

        check_outputs(9'h100);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Random pattern (8'hC3) -> Parity bit should be 1", test_num);
        in = 8'hC3;
        #1;

        check_outputs(9'h187);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Random pattern (8'hE1) -> Parity bit should be 1", test_num);
        in = 8'hE1;
        #1;

        check_outputs(9'h1C3);
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
        testcase009();
        testcase010();
        
        
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
        input [8:0] expected_out;
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
