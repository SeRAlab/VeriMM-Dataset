`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg a;
    reg b;
    reg ein;
    reg gin;
    reg lin;
    wire eout;
    wire gout;
    wire lout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .ein(ein),
        .gin(gin),
        .lin(lin),
        .eout(eout),
        .gout(gout),
        .lout(lout)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: a > b (a=1, b=0), inputs irrelevant", test_num);
        a = 1; b = 0; lin = 0; ein = 1; gin = 0;
        #1;

        check_outputs(0, 1, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: a < b (a=0, b=1), inputs irrelevant", test_num);
        a = 0; b = 1; lin = 0; ein = 1; gin = 0;
        #1;

        check_outputs(0, 0, 1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: a == b (0,0), ein=1 carries through", test_num);
        a = 0; b = 0; lin = 0; ein = 1; gin = 0;
        #1;

        check_outputs(1, 0, 0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: a == b (1,1), ein=1 carries through", test_num);
        a = 1; b = 1; lin = 0; ein = 1; gin = 0;
        #1;

        check_outputs(1, 0, 0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: a == b (0,0), gin=1 carries through", test_num);
        a = 0; b = 0; lin = 0; ein = 0; gin = 1;
        #1;

        check_outputs(0, 1, 0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: a == b (1,1), lin=1 carries through", test_num);
        a = 1; b = 1; lin = 1; ein = 0; gin = 0;
        #1;

        check_outputs(0, 0, 1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: a > b (1,0) overrides lin cascade input", test_num);
        a = 1; b = 0; lin = 1; ein = 0; gin = 0;
        #1;

        check_outputs(0, 1, 0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: a < b (0,1) overrides gin cascade input", test_num);
        a = 0; b = 1; lin = 0; ein = 0; gin = 1;
        #1;

        check_outputs(0, 0, 1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case %0d: a == b (0,0), no cascade inputs active", test_num);
        a = 0; b = 0; lin = 0; ein = 0; gin = 0;
        #1;

        check_outputs(0, 0, 0);
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
        input expected_eout;
        input expected_gout;
        input expected_lout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_eout === (expected_eout ^ eout ^ expected_eout) &&
                expected_gout === (expected_gout ^ gout ^ expected_gout) &&
                expected_lout === (expected_lout ^ lout ^ expected_lout)) begin
                $display("PASS");
                $display("  Outputs: eout=%b, gout=%b, lout=%b",
                         eout, gout, lout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: eout=%b, gout=%b, lout=%b",
                         expected_eout, expected_gout, expected_lout);
                $display("  Got:      eout=%b, gout=%b, lout=%b",
                         eout, gout, lout);
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
