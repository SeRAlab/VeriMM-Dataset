`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] in0;
    reg [7:0] in1;
    reg [7:0] in2;
    reg [7:0] in3;
    reg [7:0] in4;
    reg [7:0] in5;
    reg [7:0] in6;
    reg [7:0] in7;
    wire [7:0] out0;
    wire [7:0] out1;
    wire [7:0] out2;
    wire [7:0] out3;
    wire [7:0] out4;
    wire [7:0] out5;
    wire [7:0] out6;
    wire [7:0] out7;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .in4(in4),
        .in5(in5),
        .in6(in6),
        .in7(in7),
        .out0(out0),
        .out1(out1),
        .out2(out2),
        .out3(out3),
        .out4(out4),
        .out5(out5),
        .out6(out6),
        .out7(out7)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random distribution", test_num);
            in0 = 8'd45; in1 = 8'd12; in2 = 8'd89; in3 = 8'd2;
            in4 = 8'd34; in5 = 8'd7;  in6 = 8'd56; in7 = 8'd23;

            #1;


            check_outputs(8'd2, 8'd7, 8'd12, 8'd23, 8'd34, 8'd45, 8'd56, 8'd89);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Already sorted ascending", test_num);
            in0 = 8'd10; in1 = 8'd20; in2 = 8'd30; in3 = 8'd40;
            in4 = 8'd50; in5 = 8'd60; in6 = 8'd70; in7 = 8'd80;

            #1;


            check_outputs(8'd10, 8'd20, 8'd30, 8'd40, 8'd50, 8'd60, 8'd70, 8'd80);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reverse sorted (descending)", test_num);
            in0 = 8'd255; in1 = 8'd200; in2 = 8'd150; in3 = 8'd100;
            in4 = 8'd50;  in5 = 8'd25;  in6 = 8'd10;  in7 = 8'd0;

            #1;


            check_outputs(8'd0, 8'd10, 8'd25, 8'd50, 8'd100, 8'd150, 8'd200, 8'd255);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All values identical", test_num);
            in0 = 8'd127; in1 = 8'd127; in2 = 8'd127; in3 = 8'd127;
            in4 = 8'd127; in5 = 8'd127; in6 = 8'd127; in7 = 8'd127;

            #1;


            check_outputs(8'd127, 8'd127, 8'd127, 8'd127, 8'd127, 8'd127, 8'd127, 8'd127);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mixed duplicates", test_num);
            in0 = 8'd5;   in1 = 8'd100; in2 = 8'd5;   in3 = 8'd100;
            in4 = 8'd255; in5 = 8'd0;   in6 = 8'd255; in7 = 8'd0;

            #1;


            check_outputs(8'd0, 8'd0, 8'd5, 8'd5, 8'd100, 8'd100, 8'd255, 8'd255);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single large value at end", test_num);
            in0 = 8'd1; in1 = 8'd2; in2 = 8'd3; in3 = 8'd4;
            in4 = 8'd5; in5 = 8'd6; in6 = 8'd7; in7 = 8'd255;

            #1;


            check_outputs(8'd1, 8'd2, 8'd3, 8'd4, 8'd5, 8'd6, 8'd7, 8'd255);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single large value at start", test_num);
            in0 = 8'd255; in1 = 8'd1; in2 = 8'd2; in3 = 8'd3;
            in4 = 8'd4;   in5 = 8'd5; in6 = 8'd6; in7 = 8'd7;

            #1;


            check_outputs(8'd1, 8'd2, 8'd3, 8'd4, 8'd5, 8'd6, 8'd7, 8'd255);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating values", test_num);
            in0 = 8'd10; in1 = 8'd1; in2 = 8'd10; in3 = 8'd1;
            in4 = 8'd10; in5 = 8'd1; in6 = 8'd10; in7 = 8'd1;

            #1;


            check_outputs(8'd1, 8'd1, 8'd1, 8'd1, 8'd10, 8'd10, 8'd10, 8'd10);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Powers of 2 unsorted", test_num);
            in0 = 8'd128; in1 = 8'd64; in2 = 8'd32; in3 = 8'd16;
            in4 = 8'd8;   in5 = 8'd4;  in6 = 8'd2;  in7 = 8'd1;

            #1;


            check_outputs(8'd1, 8'd2, 8'd4, 8'd8, 8'd16, 8'd32, 8'd64, 8'd128);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero and Max only", test_num);
            in0 = 8'hFF; in1 = 8'h00; in2 = 8'hFF; in3 = 8'h00;
            in4 = 8'hFF; in5 = 8'h00; in6 = 8'hFF; in7 = 8'h00;

            #1;


            check_outputs(8'h00, 8'h00, 8'h00, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF);
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
        input [7:0] expected_out0;
        input [7:0] expected_out1;
        input [7:0] expected_out2;
        input [7:0] expected_out3;
        input [7:0] expected_out4;
        input [7:0] expected_out5;
        input [7:0] expected_out6;
        input [7:0] expected_out7;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out0 === (expected_out0 ^ out0 ^ expected_out0) &&
                expected_out1 === (expected_out1 ^ out1 ^ expected_out1) &&
                expected_out2 === (expected_out2 ^ out2 ^ expected_out2) &&
                expected_out3 === (expected_out3 ^ out3 ^ expected_out3) &&
                expected_out4 === (expected_out4 ^ out4 ^ expected_out4) &&
                expected_out5 === (expected_out5 ^ out5 ^ expected_out5) &&
                expected_out6 === (expected_out6 ^ out6 ^ expected_out6) &&
                expected_out7 === (expected_out7 ^ out7 ^ expected_out7)) begin
                $display("PASS");
                $display("  Outputs: out0=%h, out1=%h, out2=%h, out3=%h, out4=%h, out5=%h, out6=%h, out7=%h",
                         out0, out1, out2, out3, out4, out5, out6, out7);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out0=%h, out1=%h, out2=%h, out3=%h, out4=%h, out5=%h, out6=%h, out7=%h",
                         expected_out0, expected_out1, expected_out2, expected_out3, expected_out4, expected_out5, expected_out6, expected_out7);
                $display("  Got:      out0=%h, out1=%h, out2=%h, out3=%h, out4=%h, out5=%h, out6=%h, out7=%h",
                         out0, out1, out2, out3, out4, out5, out6, out7);
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
