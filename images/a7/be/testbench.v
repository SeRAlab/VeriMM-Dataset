`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg c0;
    reg c1;
    reg c2;
    reg c3;
    wire o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .c0(c0),
        .c1(c1),
        .c2(c2),
        .c3(c3),
        .o(o)
    );
    task testcase001;

    begin
        test_num = 1;
        c3 = 0; c2 = 0; c1 = 0; c0 = 1;
        $display("Test Case %0d: Input 0001 (Decimal 1)", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        c3 = 0; c2 = 0; c1 = 1; c0 = 1;
        $display("Test Case %0d: Input 0011 (Decimal 3)", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        c3 = 0; c2 = 1; c1 = 1; c0 = 1;
        $display("Test Case %0d: Input 0111 (Decimal 7)", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        c3 = 1; c2 = 1; c1 = 1; c0 = 1;
        $display("Test Case %0d: Input 1111 (Decimal 15)", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        c3 = 0; c2 = 0; c1 = 0; c0 = 0;
        $display("Test Case %0d: Input 0000 (Decimal 0)", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        c3 = 0; c2 = 0; c1 = 1; c0 = 0;
        $display("Test Case %0d: Input 0010 (Decimal 2)", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        c3 = 1; c2 = 0; c1 = 0; c0 = 0;
        $display("Test Case %0d: Input 1000 (Decimal 8)", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        c3 = 1; c2 = 1; c1 = 1; c0 = 0;
        $display("Test Case %0d: Input 1110 (Decimal 14)", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        c3 = 0; c2 = 1; c1 = 0; c0 = 1;
        $display("Test Case %0d: Input 0101 (Decimal 5)", test_num);
        #1;

        check_outputs(1'b0);
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
