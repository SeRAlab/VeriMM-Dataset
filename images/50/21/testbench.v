`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg a;
    reg b;
    reg c;
    reg d;
    reg e;
    reg f;
    wire [1:0] pos;
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
        .e(e),
        .f(f),
        .pos(pos),
        .x(x),
        .y(y),
        .z(z)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: MUX1 active (select a), MUX2 inactive", test_num);
        a = 1; b = 0; c = 0;
        d = 0; e = 1; f = 1;

        #1;


        check_outputs(2'b01, 1'b1, 1'b1, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: MUX1 active (select b), MUX2 active (select d). MUX1 Priority", test_num);
        a = 0; b = 1; c = 1;
        d = 1; e = 0; f = 0;

        #1;


        check_outputs(2'b01, 1'b1, 1'b0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: MUX1 inactive, MUX2 active (select d)", test_num);
        a = 1; b = 0; c = 1;
        d = 1; e = 0; f = 0;

        #1;


        check_outputs(2'b10, 1'b1, 1'b1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: MUX1 inactive, MUX2 active (select e)", test_num);
        a = 0; b = 1; c = 0;
        d = 0; e = 1; f = 1;

        #1;


        check_outputs(2'b10, 1'b1, 1'b0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Both MUX outputs inactive", test_num);
        a = 0; b = 1; c = 0;
        d = 1; e = 0; f = 1;

        #1;


        check_outputs(2'b00, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: MUX1 active (a), MUX2 active (e). MUX1 Priority", test_num);
        a = 1; b = 1; c = 0;
        d = 0; e = 1; f = 1;

        #1;


        check_outputs(2'b01, 1'b1, 1'b1, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: MUX selects inactive inputs", test_num);
        a = 0; b = 1; c = 0;
        d = 0; e = 1; f = 0;

        #1;


        check_outputs(2'b00, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: MUX1 inactive (b=0), MUX2 active (e=1)", test_num);
        a = 1; b = 0; c = 1;
        d = 1; e = 1; f = 1;

        #1;


        check_outputs(2'b10, 1'b1, 1'b1, 1'b1);
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
        input expected_x;
        input expected_y;
        input expected_z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_pos === (expected_pos ^ pos ^ expected_pos) &&
                expected_x === (expected_x ^ x ^ expected_x) &&
                expected_y === (expected_y ^ y ^ expected_y) &&
                expected_z === (expected_z ^ z ^ expected_z)) begin
                $display("PASS");
                $display("  Outputs: pos=%h, x=%b, y=%b, z=%b",
                         pos, x, y, z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pos=%h, x=%b, y=%b, z=%b",
                         expected_pos, expected_x, expected_y, expected_z);
                $display("  Got:      pos=%h, x=%b, y=%b, z=%b",
                         pos, x, y, z);
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
