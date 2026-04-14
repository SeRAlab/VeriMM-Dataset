`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] a;
    reg [5:0] b;
    wire is_equal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .is_equal(is_equal)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        a = 6'b000000; b = 6'b000000;
        $display("Test %0d: All zeros equality check", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        a = 6'b111111; b = 6'b111111;
        $display("Test %0d: All ones equality check", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        a = 6'b000001; b = 6'b000000;
        $display("Test %0d: LSB mismatch check", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        a = 6'b100000; b = 6'b000000;
        $display("Test %0d: MSB mismatch check", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        a = 6'b101010; b = 6'b101010;
        $display("Test %0d: Alternating bits equality check", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        a = 6'b101010; b = 6'b010101;
        $display("Test %0d: Bitwise inverse mismatch check", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        a = 6'b001100; b = 6'b001000;
        $display("Test %0d: Single bit internal mismatch check", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        a = 6'b110011; b = 6'b001100;
        $display("Test %0d: Multiple bits mismatch check", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        a = 6'b111111; b = 6'b111110;
        $display("Test %0d: Max value vs Max-1 mismatch check", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        a = 6'd42; b = 6'd42;
        $display("Test %0d: Random pattern matching (42)", test_num);
        #1;

        check_outputs(1'b1);
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
        input expected_is_equal;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_is_equal === (expected_is_equal ^ is_equal ^ expected_is_equal)) begin
                $display("PASS");
                $display("  Outputs: is_equal=%b",
                         is_equal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: is_equal=%b",
                         expected_is_equal);
                $display("  Got:      is_equal=%b",
                         is_equal);
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
