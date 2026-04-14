`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] in;
    reg [7:0] select;
    wire [31:0] out0;
    wire [31:0] out1;
    wire [31:0] out2;
    wire [31:0] out3;
    wire [31:0] out4;
    wire [31:0] out5;
    wire [31:0] out6;
    wire [31:0] out7;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .select(select),
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
            $display("Test Case %0d: Select index 0", test_num);
            in = 32'hABCD_EF01;
            select = 8'd0;
            #1;

            check_outputs(in, 0, 0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select index 1", test_num);
            in = 32'h1234_5678;
            select = 8'd1;
            #1;

            check_outputs(0, in, 0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select index 2", test_num);
            in = 32'hCAFE_BABE;
            select = 8'd2;
            #1;

            check_outputs(0, 0, in, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select index 3", test_num);
            in = 32'hDEAD_BEEF;
            select = 8'd3;
            #1;

            check_outputs(0, 0, 0, in, 0, 0, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select index 4", test_num);
            in = 32'h5555_AAAA;
            select = 8'd4;
            #1;

            check_outputs(0, 0, 0, 0, in, 0, 0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select index 5", test_num);
            in = 32'hFFFF_FFFF;
            select = 8'd5;
            #1;

            check_outputs(0, 0, 0, 0, 0, in, 0, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select index 6", test_num);
            in = 32'h0000_0001;
            select = 8'd6;
            #1;

            check_outputs(0, 0, 0, 0, 0, 0, in, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select index 7", test_num);
            in = 32'h8000_0000;
            select = 8'd7;
            #1;

            check_outputs(0, 0, 0, 0, 0, 0, 0, in);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select index 8 (Out of Range - Boundary)", test_num);
            in = 32'hA5A5_A5A5;
            select = 8'd8;
            #1;

            check_outputs(0, 0, 0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select index 255 (Out of Range - Max)", test_num);
            in = 32'h1122_3344;
            select = 8'd255;
            #1;

            check_outputs(0, 0, 0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Valid selection with zero input", test_num);
            in = 32'h0;
            select = 8'd4;
            #1;

            check_outputs(0, 0, 0, 0, 0, 0, 0, 0);
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
        testcase011();
        
        
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
        input [31:0] expected_out0;
        input [31:0] expected_out1;
        input [31:0] expected_out2;
        input [31:0] expected_out3;
        input [31:0] expected_out4;
        input [31:0] expected_out5;
        input [31:0] expected_out6;
        input [31:0] expected_out7;
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
