`timescale 1ns/1ps

module decoder_2to4_tb;

    // Testbench signals (combinational circuit)
    reg a;
    reg b;
    wire d0;
    wire d1;
    wire d2;
    wire d3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    decoder_2to4 dut (
        .a(a),
        .b(b),
        .d0(d0),
        .d1(d1),
        .d2(d2),
        .d3(d3)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Input {a,b} = 00");
            a = 0; b = 0;
            #1;

            check_outputs(1, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Input {a,b} = 01");
            a = 0; b = 1;
            #1;

            check_outputs(0, 1, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Input {a,b} = 10");
            a = 1; b = 0;
            #1;

            check_outputs(0, 0, 1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Input {a,b} = 11");
            a = 1; b = 1;
            #1;

            check_outputs(0, 0, 0, 1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("decoder_2to4 Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input expected_d0;
        input expected_d1;
        input expected_d2;
        input expected_d3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_d0 === (expected_d0 ^ d0 ^ expected_d0) &&
                expected_d1 === (expected_d1 ^ d1 ^ expected_d1) &&
                expected_d2 === (expected_d2 ^ d2 ^ expected_d2) &&
                expected_d3 === (expected_d3 ^ d3 ^ expected_d3)) begin
                $display("PASS");
                $display("  Outputs: d0=%b, d1=%b, d2=%b, d3=%b",
                         d0, d1, d2, d3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: d0=%b, d1=%b, d2=%b, d3=%b",
                         expected_d0, expected_d1, expected_d2, expected_d3);
                $display("  Got:      d0=%b, d1=%b, d2=%b, d3=%b",
                         d0, d1, d2, d3);
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
