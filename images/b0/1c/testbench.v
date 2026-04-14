`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg [2:0] ctrl;
    wire [7:0] z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .ctrl(ctrl),
        .z(z)
    );
    task testcase001;

        begin
            test_num = 1;
            a = 8'd45;
            b = 8'd25;
            ctrl = 3'b000;
            $display("Test Case %0d: Addition (45 + 25)", test_num);
            #1;

            check_outputs(8'd70);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a = 8'd100;
            b = 8'd40;
            ctrl = 3'b001;
            $display("Test Case %0d: Subtraction (100 - 40)", test_num);
            #1;

            check_outputs(8'd60);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a = 8'd20;
            b = 8'd10;
            ctrl = 3'b010;
            $display("Test Case %0d: Multiplication (20 * 10)", test_num);
            #1;

            check_outputs(8'd200);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a = 8'd144;
            b = 8'd12;
            ctrl = 3'b011;
            $display("Test Case %0d: Division (144 / 12)", test_num);
            #1;

            check_outputs(8'd12);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            a = 8'd25;
            b = 8'd7;
            ctrl = 3'b100;
            $display("Test Case %0d: Modulo (25 %% 7)", test_num);
            #1;

            check_outputs(8'd4);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            a = 8'hAA;
            b = 8'hF0;
            ctrl = 3'b101;
            $display("Test Case %0d: Bitwise AND (AA & F0)", test_num);
            #1;

            check_outputs(8'hA0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            a = 8'h55;
            b = 8'h0F;
            ctrl = 3'b110;
            $display("Test Case %0d: Bitwise OR (55 | 0F)", test_num);
            #1;

            check_outputs(8'h5F);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            a = 8'hFF;
            b = 8'hAA;
            ctrl = 3'b111;
            $display("Test Case %0d: Bitwise XOR (FF ^ AA)", test_num);
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            a = 8'd200;
            b = 8'd100;
            ctrl = 3'b000;
            $display("Test Case %0d: Overflow Addition (200 + 100)", test_num);
            #1;

            check_outputs(8'd44);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            a = 8'd10;
            b = 8'd20;
            ctrl = 3'b001;
            $display("Test Case %0d: Underflow Subtraction (10 - 20)", test_num);
            #1;

            check_outputs(8'd246);
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
        input [7:0] expected_z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_z === (expected_z ^ z ^ expected_z)) begin
                $display("PASS");
                $display("  Outputs: z=%h",
                         z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: z=%h",
                         expected_z);
                $display("  Got:      z=%h",
                         z);
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
