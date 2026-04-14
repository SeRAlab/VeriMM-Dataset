`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg a;
    reg b;
    reg c;
    wire g;
    wire p;
    wire s;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .g(g),
        .p(p),
        .s(s)
    );
    task testcase001;

    begin
        test_num = 1;
        a = 1'b0; b = 1'b0; c = 1'b0;

        #1;


        check_outputs(1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        a = 1'b0; b = 1'b0; c = 1'b1;

        #1;


        check_outputs(1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        a = 1'b0; b = 1'b1; c = 1'b0;

        #1;


        check_outputs(1'b0, 1'b1, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        a = 1'b0; b = 1'b1; c = 1'b1;

        #1;


        check_outputs(1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        a = 1'b1; b = 1'b0; c = 1'b0;

        #1;


        check_outputs(1'b0, 1'b1, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        a = 1'b1; b = 1'b0; c = 1'b1;

        #1;


        check_outputs(1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        a = 1'b1; b = 1'b1; c = 1'b0;

        #1;


        check_outputs(1'b1, 1'b1, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        a = 1'b1; b = 1'b1; c = 1'b1;

        #1;


        check_outputs(1'b1, 1'b1, 1'b1);
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
        input expected_g;
        input expected_p;
        input expected_s;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_g === (expected_g ^ g ^ expected_g) &&
                expected_p === (expected_p ^ p ^ expected_p) &&
                expected_s === (expected_s ^ s ^ expected_s)) begin
                $display("PASS");
                $display("  Outputs: g=%b, p=%b, s=%b",
                         g, p, s);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: g=%b, p=%b, s=%b",
                         expected_g, expected_p, expected_s);
                $display("  Got:      g=%b, p=%b, s=%b",
                         g, p, s);
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
