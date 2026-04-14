`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg a;
    reg b;
    reg c;
    reg d;
    reg e;
    reg f;
    wire o;

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
        .o(o)
    );
    task testcase001;

    begin
        test_num = 1;
        {a, b, c, d, e, f} = 6'd0;
        $display("Testcase %0d: All inputs 0 (Index 0)", test_num);
        #1;

        check_outputs(expected_lut[0]);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        {a, b, c, d, e, f} = 6'd63;
        $display("Testcase %0d: All inputs 1 (Index 63)", test_num);
        #1;

        check_outputs(expected_lut[63]);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        {a, b, c, d, e, f} = 6'b000001;
        $display("Testcase %0d: Input f=1 (Index 1)", test_num);
        #1;

        check_outputs(expected_lut[1]);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        {a, b, c, d, e, f} = 6'b000010;
        $display("Testcase %0d: Input e=1 (Index 2)", test_num);
        #1;

        check_outputs(expected_lut[2]);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        {a, b, c, d, e, f} = 6'b000100;
        $display("Testcase %0d: Input d=1 (Index 4)", test_num);
        #1;

        check_outputs(expected_lut[4]);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        {a, b, c, d, e, f} = 6'b100000;
        $display("Testcase %0d: Input a=1 (Index 32)", test_num);
        #1;

        check_outputs(expected_lut[32]);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        {a, b, c, d, e, f} = 6'b101010;
        $display("Testcase %0d: Checkerboard 101010 (Index 42)", test_num);
        #1;

        check_outputs(expected_lut[42]);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        {a, b, c, d, e, f} = 6'b010101;
        $display("Testcase %0d: Checkerboard 010101 (Index 21)", test_num);
        #1;

        check_outputs(expected_lut[21]);
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
        input expected_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o === (expected_o ^ o ^ expected_o)) begin
                $display("PASS");
                $display("  Outputs: o=%b",
                         o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o=%b",
                         expected_o);
                $display("  Got:      o=%b",
                         o);
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
