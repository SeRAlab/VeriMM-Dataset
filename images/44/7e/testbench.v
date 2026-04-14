`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    wire [3:0] and_res;
    wire [3:0] not_res;
    wire [3:0] or_res;
    wire [3:0] xor_res;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .and_res(and_res),
        .not_res(not_res),
        .or_res(or_res),
        .xor_res(xor_res)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: All Zeros", test_num);
            A = 4'b0000;
            B = 4'b0000;

            #1;


            check_outputs(4'b0000, 4'b1111, 4'b0000, 4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: All Ones", test_num);
            A = 4'b1111;
            B = 4'b1111;

            #1;


            check_outputs(4'b1111, 4'b0000, 4'b1111, 4'b0000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Complementary Bit Patterns", test_num);
            A = 4'b1010;
            B = 4'b0101;

            #1;


            check_outputs(4'b0000, 4'b0101, 4'b1111, 4'b1111);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Partial Overlap", test_num);
            A = 4'b1100;
            B = 4'b1010;

            #1;


            check_outputs(4'b1000, 4'b0011, 4'b1110, 4'b0110);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Identity with B=0", test_num);
            A = 4'b1001;
            B = 4'b0000;

            #1;


            check_outputs(4'b0000, 4'b0110, 4'b1001, 4'b1001);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Bitwise Toggle via XOR (B=1111)", test_num);
            A = 4'b0110;
            B = 4'b1111;

            #1;


            check_outputs(4'b0110, 4'b1001, 4'b1111, 4'b1001);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Edge Case - Single Bit High", test_num);
            A = 4'b0001;
            B = 4'b1000;

            #1;


            check_outputs(4'b0000, 4'b1110, 4'b1001, 4'b1001);
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
        input [3:0] expected_and_res;
        input [3:0] expected_not_res;
        input [3:0] expected_or_res;
        input [3:0] expected_xor_res;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_and_res === (expected_and_res ^ and_res ^ expected_and_res) &&
                expected_not_res === (expected_not_res ^ not_res ^ expected_not_res) &&
                expected_or_res === (expected_or_res ^ or_res ^ expected_or_res) &&
                expected_xor_res === (expected_xor_res ^ xor_res ^ expected_xor_res)) begin
                $display("PASS");
                $display("  Outputs: and_res=%h, not_res=%h, or_res=%h, xor_res=%h",
                         and_res, not_res, or_res, xor_res);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: and_res=%h, not_res=%h, or_res=%h, xor_res=%h",
                         expected_and_res, expected_not_res, expected_or_res, expected_xor_res);
                $display("  Got:      and_res=%h, not_res=%h, or_res=%h, xor_res=%h",
                         and_res, not_res, or_res, xor_res);
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
