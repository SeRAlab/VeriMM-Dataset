`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg a;
    reg b;
    reg c;
    reg d;
    reg [7:0] in;
    wire [7:0] out;
    wire [2:0] pos;
    wire w;
    wire x;
    wire y;
    wire z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .in(in),
        .out(out),
        .pos(pos),
        .w(w),
        .x(x),
        .y(y),
        .z(z)
    );
    task testcase001;

        begin
            test_num = 1;

            a = 0; b = 0; c = 0; d = 0; in = 8'h00;
            #10;

            a = 1; in = 8'b0000_1000;

            #1;


            check_outputs(8'h80, 3'd3, 1'b1, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a = 0; b = 0; c = 0; d = 0; in = 8'h00;
            #10;

            b = 1; in = 8'b0100_0000;

            #1;


            check_outputs(8'h04, 3'd2, 1'b0, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a = 0; b = 0; c = 0; d = 0; in = 8'h00;
            #10;

            a = 1; b = 1; in = 8'b1111_0001;

            #1;


            check_outputs(8'hE0, 3'd0, 1'b0, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a = 0; b = 0; c = 0; d = 0; in = 8'h00;
            #10;

            a = 1; in = 8'b0000_1100;

            #1;


            check_outputs(8'hC0, 3'd3, 1'b1, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            a = 0; b = 0; c = 0; d = 0; in = 8'h00;
            #10;

            c = 1; in = 8'b0010_0000;


            #1;



            check_outputs(8'hA8, 3'd3, 1'b1, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            a = 0; b = 0; c = 0; d = 0; in = 8'hFF;
            #10;


            #1;



            check_outputs(8'hFF, 3'd0, 1'b0, 1'b0, 1'b0, 1'b0);
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
        input [7:0] expected_out;
        input [2:0] expected_pos;
        input expected_w;
        input expected_x;
        input expected_y;
        input expected_z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out) &&
                expected_pos === (expected_pos ^ pos ^ expected_pos) &&
                expected_w === (expected_w ^ w ^ expected_w) &&
                expected_x === (expected_x ^ x ^ expected_x) &&
                expected_y === (expected_y ^ y ^ expected_y) &&
                expected_z === (expected_z ^ z ^ expected_z)) begin
                $display("PASS");
                $display("  Outputs: out=%h, pos=%h, w=%b, x=%b, y=%b, z=%b",
                         out, pos, w, x, y, z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h, pos=%h, w=%b, x=%b, y=%b, z=%b",
                         expected_out, expected_pos, expected_w, expected_x, expected_y, expected_z);
                $display("  Got:      out=%h, pos=%h, w=%b, x=%b, y=%b, z=%b",
                         out, pos, w, x, y, z);
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
