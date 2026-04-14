`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] addr;
    wire r;
    wire s;
    wire t;
    wire x;
    wire y;
    wire z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .r(r),
        .s(s),
        .t(t),
        .x(x),
        .y(y),
        .z(z)
    );
    task testcase001;

    begin
        test_num = 1;
        addr = 4'd0;
        $display("Test Case 001: addr = 0");

        #1;


        check_outputs(1, 1, 1, 1, 1, 1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        addr = 4'd7;
        $display("Test Case 002: addr = 7");

        #1;


        check_outputs(1, 1, 1, 1, 1, 1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        addr = 4'd8;
        $display("Test Case 003: addr = 8");

        #1;


        check_outputs(1, 1, 1, 0, 1, 1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        addr = 4'd10;
        $display("Test Case 004: addr = 10");

        #1;


        check_outputs(1, 1, 0, 0, 1, 1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        addr = 4'd11;
        $display("Test Case 005: addr = 11");

        #1;


        check_outputs(1, 0, 1, 0, 1, 1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        addr = 4'd12;
        $display("Test Case 006: addr = 12");

        #1;


        check_outputs(0, 1, 1, 0, 1, 1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        addr = 4'd13;
        $display("Test Case 007: addr = 13");

        #1;


        check_outputs(1, 1, 1, 0, 1, 0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        addr = 4'd14;
        $display("Test Case 008: addr = 14");

        #1;


        check_outputs(1, 1, 1, 0, 0, 1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        addr = 4'd15;
        $display("Test Case 009: addr = 15");

        #1;


        check_outputs(1, 1, 1, 0, 0, 1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        addr = 4'd9;
        $display("Test Case 010: addr = 9");

        #1;


        check_outputs(1, 1, 1, 0, 1, 1);
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
        input expected_r;
        input expected_s;
        input expected_t;
        input expected_x;
        input expected_y;
        input expected_z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_r === (expected_r ^ r ^ expected_r) &&
                expected_s === (expected_s ^ s ^ expected_s) &&
                expected_t === (expected_t ^ t ^ expected_t) &&
                expected_x === (expected_x ^ x ^ expected_x) &&
                expected_y === (expected_y ^ y ^ expected_y) &&
                expected_z === (expected_z ^ z ^ expected_z)) begin
                $display("PASS");
                $display("  Outputs: r=%b, s=%b, t=%b, x=%b, y=%b, z=%b",
                         r, s, t, x, y, z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: r=%b, s=%b, t=%b, x=%b, y=%b, z=%b",
                         expected_r, expected_s, expected_t, expected_x, expected_y, expected_z);
                $display("  Got:      r=%b, s=%b, t=%b, x=%b, y=%b, z=%b",
                         r, s, t, x, y, z);
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
