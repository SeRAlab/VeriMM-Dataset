`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] hexadecimal;
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
        .hexadecimal(hexadecimal),
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .e(e),
        .f(f),
        .g(g)
    );
    task testcase001;

    begin
        test_num = 1;
        hexadecimal = 4'h0;
        $display("Testcase %0d: Input Hex 0", test_num);
        #1;

        check_outputs(1, 1, 1, 1, 1, 1, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        hexadecimal = 4'h1;
        $display("Testcase %0d: Input Hex 1", test_num);
        #1;

        check_outputs(0, 1, 1, 0, 0, 0, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        hexadecimal = 4'h2;
        $display("Testcase %0d: Input Hex 2", test_num);
        #1;

        check_outputs(1, 1, 0, 1, 1, 0, 1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        hexadecimal = 4'h3;
        $display("Testcase %0d: Input Hex 3", test_num);
        #1;

        check_outputs(1, 1, 1, 1, 0, 0, 1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        hexadecimal = 4'h4;
        $display("Testcase %0d: Input Hex 4", test_num);
        #1;

        check_outputs(0, 1, 1, 0, 0, 1, 1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        hexadecimal = 4'h5;
        $display("Testcase %0d: Input Hex 5", test_num);
        #1;

        check_outputs(1, 0, 1, 1, 0, 1, 1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        hexadecimal = 4'h6;
        $display("Testcase %0d: Input Hex 6", test_num);
        #1;

        check_outputs(1, 0, 1, 1, 1, 1, 1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        hexadecimal = 4'h7;
        $display("Testcase %0d: Input Hex 7", test_num);
        #1;

        check_outputs(1, 1, 1, 0, 0, 0, 0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        hexadecimal = 4'h8;
        $display("Testcase %0d: Input Hex 8", test_num);
        #1;

        check_outputs(1, 1, 1, 1, 1, 1, 1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        hexadecimal = 4'h9;
        $display("Testcase %0d: Input Hex 9", test_num);
        #1;

        check_outputs(1, 1, 1, 1, 0, 1, 1);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        hexadecimal = 4'hA;
        $display("Testcase %0d: Input Hex A", test_num);
        #1;

        check_outputs(1, 1, 1, 0, 1, 1, 1);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        hexadecimal = 4'hB;
        $display("Testcase %0d: Input Hex B", test_num);
        #1;

        check_outputs(0, 0, 1, 1, 1, 1, 1);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        hexadecimal = 4'hC;
        $display("Testcase %0d: Input Hex C", test_num);
        #1;

        check_outputs(1, 0, 0, 1, 1, 1, 0);
    end
        endtask

    task testcase014;

    begin
        test_num = 14;
        hexadecimal = 4'hD;
        $display("Testcase %0d: Input Hex D", test_num);
        #1;

        check_outputs(0, 1, 1, 1, 1, 0, 1);
    end
        endtask

    task testcase015;

    begin
        test_num = 15;
        hexadecimal = 4'hE;
        $display("Testcase %0d: Input Hex E", test_num);
        #1;

        check_outputs(1, 0, 0, 1, 1, 1, 1);
    end
        endtask

    task testcase016;

    begin
        test_num = 16;
        hexadecimal = 4'hF;
        $display("Testcase %0d: Input Hex F", test_num);
        #1;

        check_outputs(1, 0, 0, 0, 1, 1, 1);
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
        testcase011();
        testcase012();
        testcase013();
        testcase014();
        testcase015();
        testcase016();
        
        
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
