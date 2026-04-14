`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    wire [7:0] add_out;
    wire [7:0] div_out;
    wire [7:0] mul_out;
    wire [7:0] sub_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .add_out(add_out),
        .div_out(div_out),
        .mul_out(mul_out),
        .sub_out(sub_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: a=10, b=5", test_num);
            a = 8'd10;
            b = 8'd5;

            #1;


            check_outputs(8'd15, 8'd2, 8'd50, 8'd5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: a=255, b=1", test_num);
            a = 8'd255;
            b = 8'd1;





            #1;






            check_outputs(8'd0, 8'd255, 8'd255, 8'd254);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: a=5, b=10", test_num);
            a = 8'd5;
            b = 8'd10;





            #1;






            check_outputs(8'd15, 8'd0, 8'd50, 8'd251);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: a=20, b=20", test_num);
            a = 8'd20;
            b = 8'd20;





            #1;






            check_outputs(8'd40, 8'd1, 8'd144, 8'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: a=0, b=100", test_num);
            a = 8'd0;
            b = 8'd100;





            #1;






            check_outputs(8'd100, 8'd0, 8'd0, 8'd156);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: a=7, b=3", test_num);
            a = 8'd7;
            b = 8'd3;





            #1;






            check_outputs(8'd10, 8'd2, 8'd21, 8'd4);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: a=255, b=255", test_num);
            a = 8'd255;
            b = 8'd255;





            #1;






            check_outputs(8'd254, 8'd1, 8'd1, 8'd0);
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
        input [7:0] expected_add_out;
        input [7:0] expected_div_out;
        input [7:0] expected_mul_out;
        input [7:0] expected_sub_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_add_out === (expected_add_out ^ add_out ^ expected_add_out) &&
                expected_div_out === (expected_div_out ^ div_out ^ expected_div_out) &&
                expected_mul_out === (expected_mul_out ^ mul_out ^ expected_mul_out) &&
                expected_sub_out === (expected_sub_out ^ sub_out ^ expected_sub_out)) begin
                $display("PASS");
                $display("  Outputs: add_out=%h, div_out=%h, mul_out=%h, sub_out=%h",
                         add_out, div_out, mul_out, sub_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: add_out=%h, div_out=%h, mul_out=%h, sub_out=%h",
                         expected_add_out, expected_div_out, expected_mul_out, expected_sub_out);
                $display("  Got:      add_out=%h, div_out=%h, mul_out=%h, sub_out=%h",
                         add_out, div_out, mul_out, sub_out);
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
