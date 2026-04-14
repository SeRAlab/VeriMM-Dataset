`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg a;
    reg b;
    reg ci;
    wire c;
    wire s;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .ci(ci),
        .c(c),
        .s(s)
    );
    task testcase001;

    begin
        test_num = 1;
        a = 0; b = 0; ci = 0;
        #1;

        check_outputs(0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        a = 0; b = 0; ci = 1;
        #1;

        check_outputs(0, 1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        a = 0; b = 1; ci = 0;
        #1;

        check_outputs(0, 1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        a = 0; b = 1; ci = 1;
        #1;

        check_outputs(1, 0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        a = 1; b = 0; ci = 0;
        #1;

        check_outputs(0, 1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        a = 1; b = 0; ci = 1;
        #1;

        check_outputs(1, 0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        a = 1; b = 1; ci = 0;
        #1;

        check_outputs(1, 0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        a = 1; b = 1; ci = 1;
        #1;

        check_outputs(1, 1);
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
        input expected_c;
        input expected_s;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_c === (expected_c ^ c ^ expected_c) &&
                expected_s === (expected_s ^ s ^ expected_s)) begin
                $display("PASS");
                $display("  Outputs: c=%b, s=%b",
                         c, s);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: c=%b, s=%b",
                         expected_c, expected_s);
                $display("  Got:      c=%b, s=%b",
                         c, s);
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
