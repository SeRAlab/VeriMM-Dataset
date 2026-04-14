`timescale 1ns/1ps

module polynomial_evaluator_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg [3:0] c;
    reg [3:0] d;
    reg [3:0] x;
    wire [11:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    polynomial_evaluator dut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .x(x),
        .result(result)
    );
    task testcase001;

    begin
        test_num = 1;
        a = 4'd0; b = 4'd0; c = 4'd0; d = 4'd0; x = 4'd0;
        $display("Test %0d: All inputs zero -> P(0) = 0", test_num);
        #1;

        check_outputs(12'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        a = 4'd0; b = 4'd0; c = 4'd0; d = 4'd15; x = 4'd0;
        $display("Test %0d: x=0, d=15 -> P(0) = d = 15", test_num);
        #1;

        check_outputs(12'd15);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        a = 4'd0; b = 4'd0; c = 4'd0; d = 4'd10; x = 4'd15;
        $display("Test %0d: Constant polynomial P(x) = 10", test_num);
        #1;

        check_outputs(12'd10);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        a = 4'd0; b = 4'd0; c = 4'd2; d = 4'd5; x = 4'd10;
        $display("Test %0d: Linear P(x) = 2x + 5 for x=10 -> 25", test_num);
        #1;

        check_outputs(12'd25);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        a = 4'd0; b = 4'd1; c = 4'd0; d = 4'd0; x = 4'd12;
        $display("Test %0d: Quadratic P(x) = x^2 for x=12 -> 144", test_num);
        #1;

        check_outputs(12'd144);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        a = 4'd1; b = 4'd0; c = 4'd0; d = 4'd0; x = 4'd10;
        $display("Test %0d: Cubic P(x) = x^3 for x=10 -> 1000", test_num);
        #1;

        check_outputs(12'd1000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        a = 4'd1; b = 4'd2; c = 4'd3; d = 4'd4; x = 4'd5;

        $display("Test %0d: Mixed P(x) = x^3 + 2x^2 + 3x + 4 for x=5 -> 194", test_num);
        #1;

        check_outputs(12'd194);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        a = 4'd2; b = 4'd1; c = 4'd0; d = 4'd5; x = 4'd8;

        $display("Test %0d: Mixed P(x) = 2x^3 + x^2 + 5 for x=8 -> 1093", test_num);
        #1;

        check_outputs(12'd1093);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        a = 4'd1; b = 4'd1; c = 4'd1; d = 4'd1; x = 4'd15;

        $display("Test %0d: Large x, P(x) = x^3 + x^2 + x + 1 for x=15 -> 3616", test_num);
        #1;

        check_outputs(12'd3616);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        a = 4'd3; b = 4'd0; c = 4'd0; d = 4'd1; x = 4'd11;

        $display("Test %0d: Near 12-bit max, P(x) = 3x^3 + 1 for x=11 -> 3994", test_num);
        #1;

        check_outputs(12'd3994);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("polynomial_evaluator Testbench");
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
        input [11:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
