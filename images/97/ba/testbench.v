`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg c;
    reg clk;
    wire final_output;
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
        .clk(clk),
        .final_output(final_output),
        .w(w),
        .x(x),
        .y(y),
        .z(z)
    );
    task testcase001;

    begin
        test_num = 1;
        a = 4'b1010; b = 4'b1010; c = 1'b0;
        clk = 0; #5; clk = 1; #5;

        #1;


        check_outputs(1, 0, 0, 0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        a = 4'b1010; b = 4'b0101; c = 1'b0;
        clk = 0; #5; clk = 1; #5;

        #1;


        check_outputs(0, 0, 0, 0, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        a = 4'b0011; b = 4'b1111; c = 1'b1;
        clk = 0; #5; clk = 1; #5;

        #1;


        check_outputs(1, 1, 0, 0, 0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        a = 4'b0100; b = 4'b0000; c = 1'b1;
        clk = 0; #5; clk = 1; #5;

        #1;


        check_outputs(1, 0, 1, 0, 0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        a = 4'b1000; b = 4'b0000; c = 1'b1;
        clk = 0; #5; clk = 1; #5;

        #1;


        check_outputs(1, 0, 0, 1, 0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        a = 4'b1100; b = 4'b0000; c = 1'b1;
        clk = 0; #5; clk = 1; #5;

        #1;


        check_outputs(1, 0, 0, 0, 1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        a = 4'b1111; b = 4'b1111; c = 1'b1;
        clk = 0; #5; clk = 1; #5;

        #1;


        check_outputs(1, 0, 0, 0, 1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        a = 4'b1101; b = 4'b0000; c = 1'b0;
        clk = 0; #5; clk = 1; #5;

        #1;


        check_outputs(0, 0, 0, 0, 0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        a = 4'b0000; b = 4'b0000; c = 1'b1;
        clk = 0; #5; clk = 1; #5;

        #1;


        check_outputs(1, 1, 0, 0, 0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        a = 4'b0101; b = 4'b0101; c = 1'b1;
        clk = 0; #5; clk = 1; #5;

        #1;


        check_outputs(1, 0, 1, 0, 0);
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
        input expected_final_output;
        input expected_w;
        input expected_x;
        input expected_y;
        input expected_z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_final_output === (expected_final_output ^ final_output ^ expected_final_output) &&
                expected_w === (expected_w ^ w ^ expected_w) &&
                expected_x === (expected_x ^ x ^ expected_x) &&
                expected_y === (expected_y ^ y ^ expected_y) &&
                expected_z === (expected_z ^ z ^ expected_z)) begin
                $display("PASS");
                $display("  Outputs: final_output=%b, w=%b, x=%b, y=%b, z=%b",
                         final_output, w, x, y, z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: final_output=%b, w=%b, x=%b, y=%b, z=%b",
                         expected_final_output, expected_w, expected_x, expected_y, expected_z);
                $display("  Got:      final_output=%b, w=%b, x=%b, y=%b, z=%b",
                         final_output, w, x, y, z);
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
