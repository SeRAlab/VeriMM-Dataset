`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    wire [3:0] y;
    wire [3:0] y1;
    wire [3:0] y2;
    wire [3:0] y3;
    wire [3:0] y4;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .y(y),
        .y1(y1),
        .y2(y2),
        .y3(y3),
        .y4(y4)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros (a=0000, b=0000)", test_num);
            a = 4'b0000;
            b = 4'b0000;





            #1;






            check_outputs(4'h0, 4'h0, 4'hf, 4'h0, 4'hf);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones (a=1111, b=1111)", test_num);
            a = 4'b1111;
            b = 4'b1111;





            #1;






            check_outputs(4'hf, 4'hf, 4'h0, 4'h0, 4'hf);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Patterns (a=1010, b=0101)", test_num);
            a = 4'b1010;
            b = 4'b0101;





            #1;






            check_outputs(4'hf, 4'h0, 4'ha, 4'hf, 4'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input Masking (a=1111, b=0000)", test_num);
            a = 4'b1111;
            b = 4'b0000;





            #1;






            check_outputs(4'hf, 4'h0, 4'hf, 4'hf, 4'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Common Values (a=1100, b=0011)", test_num);
            a = 4'b1100;
            b = 4'b0011;





            #1;






            check_outputs(4'hf, 4'h0, 4'hc, 4'hf, 4'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Partial Overlap (a=0111, b=1110)", test_num);
            a = 4'b0111;
            b = 4'b1110;





            #1;






            check_outputs(4'hf, 4'h6, 4'h1, 4'h9, 4'h6);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Identical Inputs (a=1001, b=1001)", test_num);
            a = 4'b1001;
            b = 4'b1001;





            #1;






            check_outputs(4'h9, 4'h9, 4'h6, 4'h0, 4'hf);
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
        input [3:0] expected_y;
        input [3:0] expected_y1;
        input [3:0] expected_y2;
        input [3:0] expected_y3;
        input [3:0] expected_y4;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y) &&
                expected_y1 === (expected_y1 ^ y1 ^ expected_y1) &&
                expected_y2 === (expected_y2 ^ y2 ^ expected_y2) &&
                expected_y3 === (expected_y3 ^ y3 ^ expected_y3) &&
                expected_y4 === (expected_y4 ^ y4 ^ expected_y4)) begin
                $display("PASS");
                $display("  Outputs: y=%h, y1=%h, y2=%h, y3=%h, y4=%h",
                         y, y1, y2, y3, y4);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h, y1=%h, y2=%h, y3=%h, y4=%h",
                         expected_y, expected_y1, expected_y2, expected_y3, expected_y4);
                $display("  Got:      y=%h, y1=%h, y2=%h, y3=%h, y4=%h",
                         y, y1, y2, y3, y4);
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
