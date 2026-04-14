`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    wire [15:0] x;
    wire [15:0] y;
    wire [15:0] z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .x(x),
        .y(y),
        .z(z)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All Zeros (a=0, b=0)", test_num);
            a = 8'd0;
            b = 8'd0;



            #1;




            check_outputs(16'h0000, 16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Positive inputs (a=5, b=10)", test_num);
            a = 8'd5;
            b = 8'd10;



            #1;




            check_outputs(16'hFFFB, 16'h000F, 16'hFFF4);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Negative a, Positive b (a=-1, b=1)", test_num);
            a = -8'sd1;
            b = 8'sd1;



            #1;




            check_outputs(16'h0001, 16'h0000, 16'h0001);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Max positive a (a=127, b=1)", test_num);
            a = 8'sd127;
            b = 8'sd1;



            #1;




            check_outputs(16'hFF81, 16'h0080, 16'hFF01);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Min negative a (a=-128, b=-1)", test_num);
            a = -8'sd128;
            b = -8'sd1;



            #1;




            check_outputs(16'h0080, 16'hFF7F, 16'hFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Identity check (a=10, b=-20)", test_num);
            a = 8'sd10;
            b = -8'sd20;



            #1;




            check_outputs(16'hFFF6, 16'hFFF6, 16'h0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Complement check (a=-64, b=-64)", test_num);
            a = -8'sd64;
            b = -8'sd64;



            #1;




            check_outputs(16'h0040, 16'hFF80, 16'hFFC0);
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
        input [15:0] expected_x;
        input [15:0] expected_y;
        input [15:0] expected_z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_x === (expected_x ^ x ^ expected_x) &&
                expected_y === (expected_y ^ y ^ expected_y) &&
                expected_z === (expected_z ^ z ^ expected_z)) begin
                $display("PASS");
                $display("  Outputs: x=%h, y=%h, z=%h",
                         x, y, z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: x=%h, y=%h, z=%h",
                         expected_x, expected_y, expected_z);
                $display("  Got:      x=%h, y=%h, z=%h",
                         x, y, z);
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
