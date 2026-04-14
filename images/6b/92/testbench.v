`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a_i;
    reg [15:0] a_r;
    reg [15:0] b_i;
    reg [15:0] b_r;
    reg [15:0] w_i;
    reg [15:0] w_r;
    wire [32:0] temp_i;
    wire [32:0] temp_r;
    wire [15:0] x_i;
    wire [15:0] x_r;
    wire [15:0] y_i;
    wire [15:0] y_r;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a_i(a_i),
        .a_r(a_r),
        .b_i(b_i),
        .b_r(b_r),
        .w_i(w_i),
        .w_r(w_r),
        .temp_i(temp_i),
        .temp_r(temp_r),
        .x_i(x_i),
        .x_r(x_r),
        .y_i(y_i),
        .y_r(y_r)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            a_r = 16'h0000; a_i = 16'h0000;
            b_r = 16'h0000; b_i = 16'h0000;
            w_r = 16'h0000; w_i = 16'h0000;

            #1;


            check_outputs(33'h0, 33'h0, 16'h0, 16'h0, 16'h0, 16'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Positive Real Parts Only", test_num);
            a_r = 16'h2000; a_i = 16'h0000;
            b_r = 16'h2000; b_i = 16'h0000;
            w_r = 16'h4000; w_i = 16'h0000;




            #1;





            check_outputs(33'h0, 33'h010000000, 16'h0000, 16'h4000, 16'h0000, 16'h1000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large Imaginary Sum with Weight", test_num);
            a_r = 16'h0000; a_i = 16'h4000;
            b_r = 16'h0000; b_i = 16'h4000;
            w_r = 16'h0000; w_i = 16'h4000;




            #1;





            check_outputs(33'h0, 33'h020000000, 16'h8000, 16'h0000, 16'h0000, 16'h2000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Signed Arithmetic Check", test_num);
            a_r = 16'hFFFF; a_i = 16'h0000;
            b_r = 16'h0000; b_i = 16'h0000;
            w_r = 16'h1000; w_i = 16'h0000;




            #1;





            check_outputs(33'h0, 33'h1FFFFF000, 16'h0000, 16'hFFFF, 16'h0000, 16'hFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Full Complex Operation", test_num);
            a_r = 16'h1000; a_i = 16'h1000;
            b_r = 16'h1000; b_i = 16'h0000;
            w_r = 16'h2000; w_i = 16'h1000;





            #1;






            check_outputs(33'h004000000, 33'h003000000, 16'h1000, 16'h2000, 16'h0400, 16'h0300);
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
        input [32:0] expected_temp_i;
        input [32:0] expected_temp_r;
        input [15:0] expected_x_i;
        input [15:0] expected_x_r;
        input [15:0] expected_y_i;
        input [15:0] expected_y_r;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_temp_i === (expected_temp_i ^ temp_i ^ expected_temp_i) &&
                expected_temp_r === (expected_temp_r ^ temp_r ^ expected_temp_r) &&
                expected_x_i === (expected_x_i ^ x_i ^ expected_x_i) &&
                expected_x_r === (expected_x_r ^ x_r ^ expected_x_r) &&
                expected_y_i === (expected_y_i ^ y_i ^ expected_y_i) &&
                expected_y_r === (expected_y_r ^ y_r ^ expected_y_r)) begin
                $display("PASS");
                $display("  Outputs: temp_i=%h, temp_r=%h, x_i=%h, x_r=%h, y_i=%h, y_r=%h",
                         temp_i, temp_r, x_i, x_r, y_i, y_r);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: temp_i=%h, temp_r=%h, x_i=%h, x_r=%h, y_i=%h, y_r=%h",
                         expected_temp_i, expected_temp_r, expected_x_i, expected_x_r, expected_y_i, expected_y_r);
                $display("  Got:      temp_i=%h, temp_r=%h, x_i=%h, x_r=%h, y_i=%h, y_r=%h",
                         temp_i, temp_r, x_i, x_r, y_i, y_r);
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
