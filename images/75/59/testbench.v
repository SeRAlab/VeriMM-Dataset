`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg [3:0] c;
    reg [3:0] d;
    reg [3:0] e;
    reg [3:0] f;
    reg [3:0] g;
    reg [3:0] h;
    reg [3:0] i;
    wire ovf;
    wire [2:0] x;
    wire [2:0] y;
    wire [2:0] z;

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
        .g(g),
        .h(h),
        .i(i),
        .ovf(ovf),
        .x(x),
        .y(y),
        .z(z)
    );
    task testcase001;

        begin
            test_num = 1;
            a=0; b=0; c=0; d=0; e=0; f=0; g=0; h=0; i=0;
            #1;

            check_outputs(1'b0, 3'd0, 3'd0, 3'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a=4'b0001; b=4'b0001; c=4'b0001; d=4'b0001;
            e=4'b0001; f=4'b0001; g=4'b0001; h=4'b0001;
            i=4'b0000;
            #1;

            check_outputs(1'b1, 3'd0, 3'd0, 3'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a=0; b=0; c=0; d=0; e=0; f=0; g=0; h=0;
            i=4'b1111;
            #1;

            check_outputs(1'b1, 3'd1, 3'd1, 3'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a=15; b=15; c=15; d=15; e=15; f=15; g=15; h=15;
            i=15;
            #1;

            check_outputs(1'b0, 3'd1, 3'd1, 3'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            a=4'b0111; b=4'b0111; c=4'b0111; d=4'b0110;
            e=4'b0110; f=4'b0100; g=4'b0100; h=4'b0000;
            i=4'b0000;
            #1;

            check_outputs(1'b0, 3'd3, 3'd5, 3'd7);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            a=4'b1000; b=4'b1000; c=4'b1000; d=4'b1000;
            e=4'b1000; f=4'b1000; g=4'b1000; h=4'b1000;
            i=4'b0000;
            #1;

            check_outputs(1'b1, 3'd0, 3'd0, 3'd0);
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
        input expected_ovf;
        input [2:0] expected_x;
        input [2:0] expected_y;
        input [2:0] expected_z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ovf === (expected_ovf ^ ovf ^ expected_ovf) &&
                expected_x === (expected_x ^ x ^ expected_x) &&
                expected_y === (expected_y ^ y ^ expected_y) &&
                expected_z === (expected_z ^ z ^ expected_z)) begin
                $display("PASS");
                $display("  Outputs: ovf=%b, x=%h, y=%h, z=%h",
                         ovf, x, y, z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ovf=%b, x=%h, y=%h, z=%h",
                         expected_ovf, expected_x, expected_y, expected_z);
                $display("  Got:      ovf=%b, x=%h, y=%h, z=%h",
                         ovf, x, y, z);
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
