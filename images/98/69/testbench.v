`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    wire [3:0] s0;
    wire [3:0] s1;
    wire [3:0] s2;
    wire [3:0] s3;
    wire [3:0] s4;
    wire [3:0] s5;
    wire [3:0] s6;
    wire [21:0] s7;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .s0(s0),
        .s1(s1),
        .s2(s2),
        .s3(s3),
        .s4(s4),
        .s5(s5),
        .s6(s6),
        .s7(s7)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            a = 4'b0000;
            b = 4'b0000;


            $display("\nTest Case %0d: a=%b, b=%b", test_num, a, b);
            #1;

            check_outputs(4'hF, 4'h0, 4'hF, 4'h0, 4'hF, 4'h0, 4'hF, 22'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            a = 4'b1111;
            b = 4'b1111;


            $display("\nTest Case %0d: a=%b, b=%b", test_num, a, b);
            #1;

            check_outputs(4'h0, 4'hF, 4'h0, 4'hF, 4'h0, 4'h0, 4'hF, 22'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            a = 4'b1010;
            b = 4'b0101;


            $display("\nTest Case %0d: a=%b, b=%b", test_num, a, b);
            #1;

            check_outputs(4'h5, 4'hF, 4'h0, 4'h0, 4'hF, 4'hF, 4'h0, 22'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            a = 4'b1100;
            b = 4'b1000;


            $display("\nTest Case %0d: a=%b, b=%b (Expect s7 logical 1)", test_num, a, b);
            #1;

            check_outputs(4'h3, 4'hC, 4'h3, 4'h8, 4'h7, 4'h4, 4'hB, 22'h1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            a = 4'b0110;
            b = 4'b0011;


            $display("\nTest Case %0d: a=%b, b=%b (Expect s7 logical 1)", test_num, a, b);
            #1;

            check_outputs(4'h9, 4'h7, 4'h8, 4'h2, 4'hD, 4'h5, 4'hA, 22'h1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            a = 4'b1110;
            b = 4'b0111;


            $display("\nTest Case %0d: a=%b, b=%b", test_num, a, b);
            #1;

            check_outputs(4'h1, 4'hF, 4'h0, 4'h6, 4'h9, 4'h9, 4'h6, 22'h0);
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
        input [3:0] expected_s0;
        input [3:0] expected_s1;
        input [3:0] expected_s2;
        input [3:0] expected_s3;
        input [3:0] expected_s4;
        input [3:0] expected_s5;
        input [3:0] expected_s6;
        input [21:0] expected_s7;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_s0 === (expected_s0 ^ s0 ^ expected_s0) &&
                expected_s1 === (expected_s1 ^ s1 ^ expected_s1) &&
                expected_s2 === (expected_s2 ^ s2 ^ expected_s2) &&
                expected_s3 === (expected_s3 ^ s3 ^ expected_s3) &&
                expected_s4 === (expected_s4 ^ s4 ^ expected_s4) &&
                expected_s5 === (expected_s5 ^ s5 ^ expected_s5) &&
                expected_s6 === (expected_s6 ^ s6 ^ expected_s6) &&
                expected_s7 === (expected_s7 ^ s7 ^ expected_s7)) begin
                $display("PASS");
                $display("  Outputs: s0=%h, s1=%h, s2=%h, s3=%h, s4=%h, s5=%h, s6=%h, s7=%h",
                         s0, s1, s2, s3, s4, s5, s6, s7);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: s0=%h, s1=%h, s2=%h, s3=%h, s4=%h, s5=%h, s6=%h, s7=%h",
                         expected_s0, expected_s1, expected_s2, expected_s3, expected_s4, expected_s5, expected_s6, expected_s7);
                $display("  Got:      s0=%h, s1=%h, s2=%h, s3=%h, s4=%h, s5=%h, s6=%h, s7=%h",
                         s0, s1, s2, s3, s4, s5, s6, s7);
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
