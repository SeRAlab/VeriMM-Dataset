`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg g;
    reg g_prec;
    reg p;
    reg p_prec;
    wire g_out;
    wire p_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .g(g),
        .g_prec(g_prec),
        .p(p),
        .p_prec(p_prec),
        .g_out(g_out),
        .p_out(p_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All inputs zero", test_num);
        g = 0; p = 0; g_prec = 0; p_prec = 0;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: g_prec=1, others=0", test_num);
        g = 0; p = 0; g_prec = 1; p_prec = 0;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: g_prec=1, p_prec=1", test_num);
        g = 0; p = 0; g_prec = 1; p_prec = 1;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: p=1, others=0", test_num);
        g = 0; p = 1; g_prec = 0; p_prec = 0;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: p=1, p_prec=1", test_num);
        g = 0; p = 1; g_prec = 0; p_prec = 1;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: g=1, others=0", test_num);
        g = 1; p = 0; g_prec = 0; p_prec = 0;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All inputs high", test_num);
        g = 1; p = 1; g_prec = 1; p_prec = 1;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: p_prec=1, others=0", test_num);
        g = 0; p = 0; g_prec = 0; p_prec = 1;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: p=1, g_prec=1, p_prec=0", test_num);
        g = 0; p = 1; g_prec = 1; p_prec = 0;
        #1;

        check_outputs(1'b0, 1'b0);
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
        input expected_g_out;
        input expected_p_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_g_out === (expected_g_out ^ g_out ^ expected_g_out) &&
                expected_p_out === (expected_p_out ^ p_out ^ expected_p_out)) begin
                $display("PASS");
                $display("  Outputs: g_out=%b, p_out=%b",
                         g_out, p_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: g_out=%b, p_out=%b",
                         expected_g_out, expected_p_out);
                $display("  Got:      g_out=%b, p_out=%b",
                         g_out, p_out);
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
