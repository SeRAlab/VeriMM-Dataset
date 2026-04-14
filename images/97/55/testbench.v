`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] a;
    reg [2:0] b;
    wire [2:0] out_and_bitwise;
    wire out_and_logical;
    wire [5:0] out_not;
    wire [2:0] out_xor;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .out_and_bitwise(out_and_bitwise),
        .out_and_logical(out_and_logical),
        .out_not(out_not),
        .out_xor(out_xor)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: a=000, b=000", test_num);
            a = 3'b000;
            b = 3'b000;

            #1;


            check_outputs(3'b000, 1'b0, 6'b111111, 3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: a=111, b=111", test_num);
            a = 3'b111;
            b = 3'b111;

            #1;


            check_outputs(3'b111, 1'b1, 6'b000000, 3'b000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: a=101, b=010", test_num);
            a = 3'b101;
            b = 3'b010;

            #1;


            check_outputs(3'b000, 1'b1, 6'b010101, 3'b111);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: a=110, b=000", test_num);
            a = 3'b110;
            b = 3'b000;

            #1;


            check_outputs(3'b000, 1'b0, 6'b001111, 3'b110);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: a=011, b=110", test_num);
            a = 3'b011;
            b = 3'b110;

            #1;


            check_outputs(3'b010, 1'b1, 6'b100001, 3'b101);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: a=001, b=100", test_num);
            a = 3'b001;
            b = 3'b100;

            #1;


            check_outputs(3'b000, 1'b1, 6'b110011, 3'b101);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: a=111, b=000", test_num);
            a = 3'b111;
            b = 3'b000;

            #1;


            check_outputs(3'b000, 1'b0, 6'b000111, 3'b111);
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
        input [2:0] expected_out_and_bitwise;
        input expected_out_and_logical;
        input [5:0] expected_out_not;
        input [2:0] expected_out_xor;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_and_bitwise === (expected_out_and_bitwise ^ out_and_bitwise ^ expected_out_and_bitwise) &&
                expected_out_and_logical === (expected_out_and_logical ^ out_and_logical ^ expected_out_and_logical) &&
                expected_out_not === (expected_out_not ^ out_not ^ expected_out_not) &&
                expected_out_xor === (expected_out_xor ^ out_xor ^ expected_out_xor)) begin
                $display("PASS");
                $display("  Outputs: out_and_bitwise=%h, out_and_logical=%b, out_not=%h, out_xor=%h",
                         out_and_bitwise, out_and_logical, out_not, out_xor);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_and_bitwise=%h, out_and_logical=%b, out_not=%h, out_xor=%h",
                         expected_out_and_bitwise, expected_out_and_logical, expected_out_not, expected_out_xor);
                $display("  Got:      out_and_bitwise=%h, out_and_logical=%b, out_not=%h, out_xor=%h",
                         out_and_bitwise, out_and_logical, out_not, out_xor);
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
