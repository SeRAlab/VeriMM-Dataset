`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] a;
    reg [2:0] b;
    wire out_and;
    wire out_nor;
    wire [5:0] out_not;
    wire [2:0] out_or_bitwise;
    wire out_or_logical;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .out_and(out_and),
        .out_nor(out_nor),
        .out_not(out_not),
        .out_or_bitwise(out_or_bitwise),
        .out_or_logical(out_or_logical)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: All Zeros (a=000, b=000)", test_num);
        a = 3'b000;
        b = 3'b000;





        #1;






        check_outputs(1'b0, 1'b1, 6'b111111, 3'b000, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: All Ones (a=111, b=111)", test_num);
        a = 3'b111;
        b = 3'b111;





        #1;






        check_outputs(1'b0, 1'b0, 6'b000000, 3'b111, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Alternating Bits (a=101, b=010)", test_num);
        a = 3'b101;
        b = 3'b010;





        #1;






        check_outputs(1'b0, 1'b0, 6'b101010, 3'b111, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Only Input A has bits (a=001, b=000)", test_num);
        a = 3'b001;
        b = 3'b000;





        #1;






        check_outputs(1'b0, 1'b0, 6'b111110, 3'b001, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Only Input B has bits (a=000, b=100)", test_num);
        a = 3'b000;
        b = 3'b100;





        #1;






        check_outputs(1'b0, 1'b0, 6'b011111, 3'b100, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Overlapping Bits (a=110, b=011)", test_num);
        a = 3'b110;
        b = 3'b011;





        #1;






        check_outputs(1'b0, 1'b0, 6'b100001, 3'b111, 1'b1);
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
        input expected_out_and;
        input expected_out_nor;
        input [5:0] expected_out_not;
        input [2:0] expected_out_or_bitwise;
        input expected_out_or_logical;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_and === (expected_out_and ^ out_and ^ expected_out_and) &&
                expected_out_nor === (expected_out_nor ^ out_nor ^ expected_out_nor) &&
                expected_out_not === (expected_out_not ^ out_not ^ expected_out_not) &&
                expected_out_or_bitwise === (expected_out_or_bitwise ^ out_or_bitwise ^ expected_out_or_bitwise) &&
                expected_out_or_logical === (expected_out_or_logical ^ out_or_logical ^ expected_out_or_logical)) begin
                $display("PASS");
                $display("  Outputs: out_and=%b, out_nor=%b, out_not=%h, out_or_bitwise=%h, out_or_logical=%b",
                         out_and, out_nor, out_not, out_or_bitwise, out_or_logical);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_and=%b, out_nor=%b, out_not=%h, out_or_bitwise=%h, out_or_logical=%b",
                         expected_out_and, expected_out_nor, expected_out_not, expected_out_or_bitwise, expected_out_or_logical);
                $display("  Got:      out_and=%b, out_nor=%b, out_not=%h, out_or_bitwise=%h, out_or_logical=%b",
                         out_and, out_nor, out_not, out_or_bitwise, out_or_logical);
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
