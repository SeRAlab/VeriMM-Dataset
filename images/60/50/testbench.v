`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] a;
    reg [4:0] b;
    reg [4:0] c;
    reg [4:0] d;
    reg [4:0] e;
    reg [4:0] f;
    wire [7:0] w;
    wire [7:0] x;
    wire [7:0] y;
    wire [7:0] z;

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
        .e(e),
        .f(f),
        .w(w),
        .x(x),
        .y(y),
        .z(z)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            a = 5'b00000; b = 5'b00000; c = 5'b00000;
            d = 5'b00000; e = 5'b00000; f = 5'b00000;




            #1;





            check_outputs(8'h00, 8'h00, 8'h00, 8'h03);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones", test_num);
            a = 5'h1F; b = 5'h1F; c = 5'h1F;
            d = 5'h1F; e = 5'h1F; f = 5'h1F;




            #1;





            check_outputs(8'hFF, 8'hFF, 8'hFF, 8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits (AA/AB pattern)", test_num);
            a = 5'b10101; b = 5'b01010; c = 5'b10101;
            d = 5'b01010; e = 5'b10101; f = 5'b01010;




            #1;





            check_outputs(8'hAA, 8'hAA, 8'hAA, 8'hAB);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary bit check", test_num);

            a = 5'b11001;
            b = 5'b11100;
            c = 5'b01111;
            d = 5'b10001;
            e = 5'b11110;
            f = 5'b00001;




            #1;





            check_outputs(8'hCF, 8'h1F, 8'h1F, 8'h07);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Walking Bits Pattern", test_num);
            a = 5'h01; b = 5'h02; c = 5'h04;
            d = 5'h08; e = 5'h10; f = 5'h1F;




            #1;





            check_outputs(8'h08, 8'h88, 8'h88, 8'h7F);
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
        input [7:0] expected_w;
        input [7:0] expected_x;
        input [7:0] expected_y;
        input [7:0] expected_z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_w === (expected_w ^ w ^ expected_w) &&
                expected_x === (expected_x ^ x ^ expected_x) &&
                expected_y === (expected_y ^ y ^ expected_y) &&
                expected_z === (expected_z ^ z ^ expected_z)) begin
                $display("PASS");
                $display("  Outputs: w=%h, x=%h, y=%h, z=%h",
                         w, x, y, z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: w=%h, x=%h, y=%h, z=%h",
                         expected_w, expected_x, expected_y, expected_z);
                $display("  Got:      w=%h, x=%h, y=%h, z=%h",
                         w, x, y, z);
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
