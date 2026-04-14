`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg and_en;
    reg [3:0] b;
    reg inv_en;
    reg not_en;
    reg or_en;
    reg xor_en;
    wire [3:0] and_out;
    wire [3:0] not_out;
    wire [3:0] or_out;
    wire [3:0] xor_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .and_en(and_en),
        .b(b),
        .inv_en(inv_en),
        .not_en(not_en),
        .or_en(or_en),
        .xor_en(xor_en),
        .and_out(and_out),
        .not_out(not_out),
        .or_out(or_out),
        .xor_out(xor_out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: All Enable Signals Low", test_num);
            a = 4'hF; b = 4'hA;
            and_en = 0; or_en = 0; xor_en = 0; not_en = 0; inv_en = 0;
            #1;

            check_outputs(4'h0, 4'h0, 4'h0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Bitwise AND Enable", test_num);
            a = 4'b1010; b = 4'b1100;
            and_en = 1; or_en = 0; xor_en = 0; not_en = 0; inv_en = 0;
            #1;

            check_outputs(4'b1000, 4'h0, 4'h0, 4'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Bitwise OR Enable", test_num);
            a = 4'b1010; b = 4'b0101;
            and_en = 0; or_en = 1; xor_en = 0; not_en = 0; inv_en = 0;
            #1;

            check_outputs(4'h0, 4'h0, 4'b1111, 4'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Bitwise XOR Enable", test_num);
            a = 4'b1100; b = 4'b1010;
            and_en = 0; or_en = 0; xor_en = 1; not_en = 0; inv_en = 0;
            #1;

            check_outputs(4'h0, 4'h0, 4'h0, 4'b0110);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Bitwise NOT (inv_en=1)", test_num);
            a = 4'b1010;
            and_en = 0; or_en = 0; xor_en = 0; not_en = 1; inv_en = 1;
            #1;

            check_outputs(4'h0, 4'b0101, 4'h0, 4'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Logical NOT (inv_en=0) non-zero", test_num);
            a = 4'b1010;
            and_en = 0; or_en = 0; xor_en = 0; not_en = 1; inv_en = 0;

            #1;


            check_outputs(4'h0, 4'h0, 4'h0, 4'h0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Logical NOT (inv_en=0) zero input", test_num);
            a = 4'b0000;
            and_en = 0; or_en = 0; xor_en = 0; not_en = 1; inv_en = 0;

            #1;


            check_outputs(4'h0, 4'h1, 4'h0, 4'h0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Parallel Operations", test_num);
            a = 4'b0101; b = 4'b0011;
            and_en = 1; or_en = 1; xor_en = 1; not_en = 1; inv_en = 1;




            #1;





            check_outputs(4'h1, 4'hA, 4'h7, 4'h6);
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
        input [3:0] expected_and_out;
        input [3:0] expected_not_out;
        input [3:0] expected_or_out;
        input [3:0] expected_xor_out;
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
