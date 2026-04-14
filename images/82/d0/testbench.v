`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] bcd;
    wire a;
    wire b;
    wire c;
    wire d;
    wire e;
    wire f;
    wire g;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bcd(bcd),
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .e(e),
        .f(f),
        .g(g)
    );
    task testcase000;

        begin
            test_num = 0;
            bcd = 4'd0;
            $display("\nTest %0d: BCD = 0", test_num);
            #1;

            check_outputs(0, 0, 0, 0, 0, 0, 1);
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            bcd = 4'd1;
            $display("\nTest %0d: BCD = 1", test_num);
            #1;

            check_outputs(1, 0, 0, 1, 1, 1, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            bcd = 4'd2;
            $display("\nTest %0d: BCD = 2", test_num);
            #1;

            check_outputs(0, 0, 1, 0, 0, 1, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            bcd = 4'd3;
            $display("\nTest %0d: BCD = 3", test_num);
            #1;

            check_outputs(0, 0, 0, 0, 1, 1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            bcd = 4'd4;
            $display("\nTest %0d: BCD = 4", test_num);
            #1;

            check_outputs(1, 0, 0, 1, 1, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            bcd = 4'd5;
            $display("\nTest %0d: BCD = 5", test_num);
            #1;

            check_outputs(0, 1, 0, 0, 1, 0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            bcd = 4'd6;
            $display("\nTest %0d: BCD = 6", test_num);
            #1;

            check_outputs(0, 1, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            bcd = 4'd7;
            $display("\nTest %0d: BCD = 7", test_num);
            #1;

            check_outputs(0, 0, 0, 1, 1, 1, 1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            bcd = 4'd8;
            $display("\nTest %0d: BCD = 8", test_num);
            #1;

            check_outputs(0, 0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            bcd = 4'd9;
            $display("\nTest %0d: BCD = 9", test_num);
            #1;

            check_outputs(0, 0, 0, 0, 1, 0, 0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            bcd = 4'd10;
            $display("\nTest %0d: BCD = 10 (Invalid)", test_num);
            #1;

            check_outputs(1, 1, 1, 1, 1, 1, 1);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            bcd = 4'd15;
            $display("\nTest %0d: BCD = 15 (Invalid)", test_num);
            #1;

            check_outputs(1, 1, 1, 1, 1, 1, 1);
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


        testcase000();
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
        testcase011();
        
        
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
        input expected_a;
        input expected_b;
        input expected_c;
        input expected_d;
        input expected_e;
        input expected_f;
        input expected_g;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_a === (expected_a ^ a ^ expected_a) &&
                expected_b === (expected_b ^ b ^ expected_b) &&
                expected_c === (expected_c ^ c ^ expected_c) &&
                expected_d === (expected_d ^ d ^ expected_d) &&
                expected_e === (expected_e ^ e ^ expected_e) &&
                expected_f === (expected_f ^ f ^ expected_f) &&
                expected_g === (expected_g ^ g ^ expected_g)) begin
                $display("PASS");
                $display("  Outputs: a=%b, b=%b, c=%b, d=%b, e=%b, f=%b, g=%b",
                         a, b, c, d, e, f, g);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: a=%b, b=%b, c=%b, d=%b, e=%b, f=%b, g=%b",
                         expected_a, expected_b, expected_c, expected_d, expected_e, expected_f, expected_g);
                $display("  Got:      a=%b, b=%b, c=%b, d=%b, e=%b, f=%b, g=%b",
                         a, b, c, d, e, f, g);
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
