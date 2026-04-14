`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg [3:0] in;
    reg [1:0] select;
    wire [1:0] pos;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .in(in),
        .select(select),
        .pos(pos),
        .result(result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple division (Quotient)", test_num);
            a = 32'd50;
            b = 32'd5;
            select = 2'b00;
            in = 4'b1000;
            #1;

            check_outputs(2'd3, 32'd10);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple division (Remainder)", test_num);
            a = 32'd50;
            b = 32'd5;
            select = 2'b01;
            in = 4'b0100;
            #1;

            check_outputs(2'd2, 32'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Division with remainder (Quotient)", test_num);
            a = 32'd13;
            b = 32'd4;
            select = 2'b00;
            in = 4'b0010;
            #1;

            check_outputs(2'd1, 32'd3);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Division with remainder (Remainder)", test_num);
            a = 32'd13;
            b = 32'd4;
            select = 2'b01;
            in = 4'b0001;
            #1;

            check_outputs(2'd0, 32'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large number division (Quotient)", test_num);
            a = 32'hFFFFFFFF;
            b = 32'd1;
            select = 2'b00;
            in = 4'b1111;
            #1;

            check_outputs(2'd3, 32'hFFFFFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Small divided by large (Quotient)", test_num);
            a = 32'd10;
            b = 32'd20;
            select = 2'b00;
            in = 4'b0101;
            #1;

            check_outputs(2'd2, 32'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Small divided by large (Remainder)", test_num);
            a = 32'd10;
            b = 32'd20;
            select = 2'b01;
            in = 4'b0011;
            #1;

            check_outputs(2'd1, 32'd10);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero dividend", test_num);
            a = 32'd0;
            b = 32'd100;
            select = 2'b00;
            in = 4'b1001;
            #1;

            check_outputs(2'd3, 32'd0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Highest bit position (No bits active)", test_num);
            a = 32'd100;
            b = 32'd10;
            select = 2'b01;
            in = 4'b0000;
            #1;

            check_outputs(2'd0, 32'd0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large remainder scenario", test_num);
            a = 32'd1000000;
            b = 32'd3;
            select = 2'b01;
            in = 4'b0111;
            #1;

            check_outputs(2'd2, 32'd1);
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
        input [1:0] expected_pos;
        input [31:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_pos === (expected_pos ^ pos ^ expected_pos) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: pos=%h, result=%h",
                         pos, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pos=%h, result=%h",
                         expected_pos, expected_result);
                $display("  Got:      pos=%h, result=%h",
                         pos, result);
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
