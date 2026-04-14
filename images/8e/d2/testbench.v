`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg a;
    reg b;
    reg c;
    reg d;
    reg e;
    wire [24:0] out;

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
        .out(out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        {a, b, c, d, e} = 5'b00000;
        #1;

        check_outputs(25'h0000000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        {a, b, c, d, e} = 5'b11111;
        #1;

        check_outputs(25'h0000000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        {a, b, c, d, e} = 5'b10000;
        #1;

        check_outputs(25'h0F84210);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        {a, b, c, d, e} = 5'b01000;
        #1;

        check_outputs(25'h08BA108);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        {a, b, c, d, e} = 5'b00100;
        #1;

        check_outputs(25'h0426C84);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        {a, b, c, d, e} = 5'b00010;
        #1;

        check_outputs(25'h0210BA2);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        {a, b, c, d, e} = 5'b00001;
        #1;

        check_outputs(25'h010843E);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        {a, b, c, d, e} = 5'b10101;
        #1;

        check_outputs(25'h0AAAAAA);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        {a, b, c, d, e} = 5'b11001;
        #1;

        check_outputs(25'h0636726);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        {a, b, c, d, e} = 5'b11100;
        #1;

        check_outputs(25'h0318F9C);
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
        input [24:0] expected_out;
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
