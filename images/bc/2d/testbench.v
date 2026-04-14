`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg a;
    reg b;
    reg c;
    reg d;
    reg e;
    reg f;
    reg g;
    wire [3:0] number;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .e(e),
        .f(f),
        .g(g),
        .number(number),
        .valid(valid)
    );
    task testcase001;

    begin
        test_num = 1;
        {a, b, c, d, e, f, g} = 7'b1111110;
        #1;

        check_outputs(4'd0, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        {a, b, c, d, e, f, g} = 7'b0110000;
        #1;

        check_outputs(4'd1, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        {a, b, c, d, e, f, g} = 7'b1101101;
        #1;

        check_outputs(4'd2, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        {a, b, c, d, e, f, g} = 7'b1111001;
        #1;

        check_outputs(4'd3, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        {a, b, c, d, e, f, g} = 7'b0110011;
        #1;

        check_outputs(4'd4, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        {a, b, c, d, e, f, g} = 7'b1011011;
        #1;

        check_outputs(4'd5, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        {a, b, c, d, e, f, g} = 7'b1011111;
        #1;

        check_outputs(4'd6, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        {a, b, c, d, e, f, g} = 7'b1110000;
        #1;

        check_outputs(4'd7, 1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        {a, b, c, d, e, f, g} = 7'b1111111;
        #1;

        check_outputs(4'd8, 1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        {a, b, c, d, e, f, g} = 7'b1111011;
        #1;

        check_outputs(4'd9, 1'b1);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        {a, b, c, d, e, f, g} = 7'b0000000;
        #1;

        check_outputs(number, 1'b0);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        {a, b, c, d, e, f, g} = 7'b0000001;
        #1;

        check_outputs(number, 1'b0);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        {a, b, c, d, e, f, g} = 7'b1001000;
        #1;

        check_outputs(number, 1'b0);
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
        input [3:0] expected_number;
        input expected_valid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_number === (expected_number ^ number ^ expected_number) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: number=%h, valid=%b",
                         number, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: number=%h, valid=%b",
                         expected_number, expected_valid);
                $display("  Got:      number=%h, valid=%b",
                         number, valid);
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
