`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] a;
    reg [2:0] b;
    wire [3:0] xs;
    wire [3:0] xu;
    wire [3:0] ys;
    wire [3:0] yu;
    wire zs;
    wire zu;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .xs(xs),
        .xu(xu),
        .ys(ys),
        .yu(yu),
        .zs(zs),
        .zu(zu)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: a=0, b=0 (Zero Sums)", test_num);
            a = 2'b00;
            b = 3'b000;

            #1;


            check_outputs(4'h0, 4'h0, 4'h0, 4'h0, 1'b0, 1'b1);




        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: a=1, b=2 (Positive Sums)", test_num);
            a = 2'b01;
            b = 3'b010;


            #1;



            check_outputs(4'h3, 4'h3, 4'h3, 4'h3, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: a=2'b11, b=3'b111 (Mixed result)", test_num);
            a = 2'b11;
            b = 3'b111;


            #1;



            check_outputs(4'hE, 4'hA, 4'hE, 4'hA, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: a=-1, b=1 (Signed zero result)", test_num);
            a = 2'b11;
            b = 3'b001;


            #1;



            check_outputs(4'h0, 4'h4, 4'h0, 4'h4, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: a=-2, b=-4 (Minimum signed values)", test_num);
            a = 2'b10;
            b = 3'b100;


            #1;



            check_outputs(4'hA, 4'h6, 4'hA, 4'h6, 1'b1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: a=1, b=-3", test_num);
            a = 2'b01;
            b = 3'b101;


            #1;



            check_outputs(4'hE, 4'h6, 4'hE, 4'h6, 1'b1, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: a=1, b=3 (Max positives)", test_num);
            a = 2'b01;
            b = 3'b011;


            #1;



            check_outputs(4'h4, 4'h4, 4'h4, 4'h4, 1'b1, 1'b1);
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
        input [3:0] expected_xs;
        input [3:0] expected_xu;
        input [3:0] expected_ys;
        input [3:0] expected_yu;
        input expected_zs;
        input expected_zu;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_xs === (expected_xs ^ xs ^ expected_xs) &&
                expected_xu === (expected_xu ^ xu ^ expected_xu) &&
                expected_ys === (expected_ys ^ ys ^ expected_ys) &&
                expected_yu === (expected_yu ^ yu ^ expected_yu) &&
                expected_zs === (expected_zs ^ zs ^ expected_zs) &&
                expected_zu === (expected_zu ^ zu ^ expected_zu)) begin
                $display("PASS");
                $display("  Outputs: xs=%h, xu=%h, ys=%h, yu=%h, zs=%b, zu=%b",
                         xs, xu, ys, yu, zs, zu);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: xs=%h, xu=%h, ys=%h, yu=%h, zs=%b, zu=%b",
                         expected_xs, expected_xu, expected_ys, expected_yu, expected_zs, expected_zu);
                $display("  Got:      xs=%h, xu=%h, ys=%h, yu=%h, zs=%b, zu=%b",
                         xs, xu, ys, yu, zs, zu);
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
