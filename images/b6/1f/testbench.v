`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg op;
    wire c;
    wire n;
    wire [31:0] o;
    wire w;
    wire z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .op(op),
        .c(c),
        .n(n),
        .o(o),
        .w(w),
        .z(z)
    );
    task testcase001;

        begin
            test_num = 1;
            a = 32'd15;
            b = 32'd25;
            op = 1'b0;

            #1;


            check_outputs(1'b0, 1'b0, 32'd40, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a = 32'd50;
            b = 32'd20;
            op = 1'b1;

            #1;


            check_outputs(1'b0, 1'b0, 32'd30, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a = 32'd0;
            b = 32'd0;
            op = 1'b0;

            #1;


            check_outputs(1'b0, 1'b0, 32'h0, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a = 32'd100;
            b = 32'd100;
            op = 1'b1;

            #1;


            check_outputs(1'b0, 1'b0, 32'h0, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            a = 32'd10;
            b = 32'd20;
            op = 1'b1;

            #1;


            check_outputs(1'b0, 1'b1, 32'hFFFFFFF6, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            a = 32'hFFFFFFFF;
            b = 32'd1;
            op = 1'b0;

            #1;


            check_outputs(1'b0, 1'b0, 32'h0, 1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            a = 32'h40000000;
            b = 32'h40000000;
            op = 1'b0;

            #1;


            check_outputs(1'b0, 1'b1, 32'h80000000, 1'b0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            a = 32'h0;
            b = 32'h1;
            op = 1'b1;

            #1;


            check_outputs(1'b0, 1'b1, 32'hFFFFFFFF, 1'b0, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            a = 32'h80000000;
            b = 32'h0;
            op = 1'b0;

            #1;


            check_outputs(1'b0, 1'b1, 32'h80000000, 1'b0, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            a = 32'h7FFFFFFF;
            b = 32'hFFFFFFFF;
            op = 1'b1;

            #1;


            check_outputs(1'b0, 1'b1, 32'h80000000, 1'b0, 1'b0);
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
        input expected_c;
        input expected_n;
        input [31:0] expected_o;
        input expected_w;
        input expected_z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_c === (expected_c ^ c ^ expected_c) &&
                expected_n === (expected_n ^ n ^ expected_n) &&
                expected_o === (expected_o ^ o ^ expected_o) &&
                expected_w === (expected_w ^ w ^ expected_w) &&
                expected_z === (expected_z ^ z ^ expected_z)) begin
                $display("PASS");
                $display("  Outputs: c=%b, n=%b, o=%h, w=%b, z=%b",
                         c, n, o, w, z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: c=%b, n=%b, o=%h, w=%b, z=%b",
                         expected_c, expected_n, expected_o, expected_w, expected_z);
                $display("  Got:      c=%b, n=%b, o=%h, w=%b, z=%b",
                         c, n, o, w, z);
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
