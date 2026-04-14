`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a;
    reg [15:0] b;
    wire [15:0] y_add;
    wire [15:0] y_div;
    wire [15:0] y_mul;
    wire [15:0] y_sub;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .y_add(y_add),
        .y_div(y_div),
        .y_mul(y_mul),
        .y_sub(y_sub)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Simple small values", test_num);
            a = 16'd10;
            b = 16'd2;

            #1;


            check_outputs(16'd12, 16'd5, 16'd20, 16'd8);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Addition overflow (16-bit truncation)", test_num);
            a = 16'hFFFF;
            b = 16'h0001;

            #1;


            check_outputs(16'h0000, 16'hFFFF, 16'hFFFF, 16'hFFFE);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Negative subtraction result (2's complement)", test_num);
            a = 16'd5;
            b = 16'd10;

            #1;


            check_outputs(16'd15, 16'd0, 16'd50, 16'hFFFB);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Multiplication overflow (16-bit truncation)", test_num);
            a = 16'd1000;
            b = 16'd100;


            #1;



            check_outputs(16'd1100, 16'd10, 16'h86A0, 16'd900);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Integer division floor and bitwise pattern", test_num);
            a = 16'hAAAA;
            b = 16'h5555;




            #1;





            check_outputs(16'hFFFF, 16'h0002, 16'h1C72, 16'h5555);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Operations with zero", test_num);
            a = 16'h1234;
            b = 16'h0000;



            #1;




            check_outputs(16'h1234, 16'hx, 16'h0000, 16'h1234);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Prime-ish division", test_num);
            a = 16'd123;
            b = 16'd7;

            #1;


            check_outputs(16'd130, 16'd17, 16'd861, 16'd116);
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
        input [15:0] expected_y_add;
        input [15:0] expected_y_div;
        input [15:0] expected_y_mul;
        input [15:0] expected_y_sub;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y_add === (expected_y_add ^ y_add ^ expected_y_add) &&
                expected_y_div === (expected_y_div ^ y_div ^ expected_y_div) &&
                expected_y_mul === (expected_y_mul ^ y_mul ^ expected_y_mul) &&
                expected_y_sub === (expected_y_sub ^ y_sub ^ expected_y_sub)) begin
                $display("PASS");
                $display("  Outputs: y_add=%h, y_div=%h, y_mul=%h, y_sub=%h",
                         y_add, y_div, y_mul, y_sub);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y_add=%h, y_div=%h, y_mul=%h, y_sub=%h",
                         expected_y_add, expected_y_div, expected_y_mul, expected_y_sub);
                $display("  Got:      y_add=%h, y_div=%h, y_mul=%h, y_sub=%h",
                         y_add, y_div, y_mul, y_sub);
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
