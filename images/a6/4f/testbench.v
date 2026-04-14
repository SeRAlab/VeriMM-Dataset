`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] g;
    wire [5:0] double_bits;
    wire [2:0] half_bits;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .g(g),
        .double_bits(double_bits),
        .half_bits(half_bits)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: g=3'b000", test_num);
        g = 3'b000;
        #1;

        check_outputs(6'b000000, 3'b000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: g=3'b101", test_num);
        g = 3'b101;
        #1;

        check_outputs(6'b110011, 3'b111);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: g=3'b111", test_num);
        g = 3'b111;
        #1;

        check_outputs(6'b111111, 3'b111);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: g=3'b010", test_num);
        g = 3'b010;
        #1;

        check_outputs(6'b001100, 3'b000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: g=3'b001", test_num);
        g = 3'b001;
        #1;

        check_outputs(6'b000011, 3'b111);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: g=3'b100", test_num);
        g = 3'b100;
        #1;

        check_outputs(6'b110000, 3'b000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: g=3'b011", test_num);
        g = 3'b011;
        #1;

        check_outputs(6'b001111, 3'b111);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: g=3'b110", test_num);
        g = 3'b110;
        #1;

        check_outputs(6'b111100, 3'b000);
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
        input [5:0] expected_double_bits;
        input [2:0] expected_half_bits;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_double_bits === (expected_double_bits ^ double_bits ^ expected_double_bits) &&
                expected_half_bits === (expected_half_bits ^ half_bits ^ expected_half_bits)) begin
                $display("PASS");
                $display("  Outputs: double_bits=%h, half_bits=%h",
                         double_bits, half_bits);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: double_bits=%h, half_bits=%h",
                         expected_double_bits, expected_half_bits);
                $display("  Got:      double_bits=%h, half_bits=%h",
                         double_bits, half_bits);
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
