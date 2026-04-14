`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg [3:0] ctl;
    wire [31:0] out;
    wire zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .ctl(ctl),
        .out(out),
        .zero(zero)
    );
    task testcase001;

        begin
            test_num = 1;
            ctl = 4'b0010;
            a = 32'd100;
            b = 32'd250;
            $display("Test %0d: Addition (100 + 250)", test_num);
            #1;

            check_outputs(32'd350, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            ctl = 4'b0010;
            a = 32'hFFFFFFFF;
            b = 32'h00000001;
            $display("Test %0d: Addition Wrap-around (0xFFFFFFFF + 1)", test_num);
            #1;

            check_outputs(32'h00000000, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            ctl = 4'b0110;
            a = 32'd500;
            b = 32'd150;
            $display("Test %0d: Subtraction (500 - 150)", test_num);
            #1;

            check_outputs(32'd350, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            ctl = 4'b0110;
            a = 32'hABCDE;
            b = 32'hABCDE;
            $display("Test %0d: Subtraction Zero Result", test_num);
            #1;

            check_outputs(32'd0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            ctl = 4'b0000;
            a = 32'hF0F0AAAA;
            b = 32'h0F0F5555;
            $display("Test %0d: Bitwise AND", test_num);
            #1;

            check_outputs(32'h00000000, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            ctl = 4'b0001;
            a = 32'hF0F0AAAA;
            b = 32'h0F0F5555;
            $display("Test %0d: Bitwise OR", test_num);
            #1;

            check_outputs(32'hFFFFFFFF, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            ctl = 4'b0011;
            a = 32'hAAAAAAAA;
            b = 32'h55555555;
            $display("Test %0d: Bitwise XOR", test_num);
            #1;

            check_outputs(32'hFFFFFFFF, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            ctl = 4'b1100;
            a = 32'h0000FFFF;
            b = 32'h0000FFFF;
            $display("Test %0d: Bitwise NAND", test_num);
            #1;

            check_outputs(32'hFFFF0000, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            ctl = 4'b0111;
            a = 32'd10;
            b = 32'd20;
            $display("Test %0d: SLT (10 < 20)", test_num);
            #1;

            check_outputs(32'h00000001, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            ctl = 4'b0111;
            a = 32'd100;
            b = 32'd50;
            $display("Test %0d: SLT (100 < 50)", test_num);
            #1;

            check_outputs(32'h00000000, 1'b1);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            ctl = 4'b0111;
            a = 32'hFFFFFFFF;
            b = 32'h00000001;
            $display("Test %0d: SLT Signed (-1 < 1)", test_num);
            #1;

            check_outputs(32'h00000001, 1'b0);
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
        input [31:0] expected_out;
        input expected_zero;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out) &&
                expected_zero === (expected_zero ^ zero ^ expected_zero)) begin
                $display("PASS");
                $display("  Outputs: out=%h, zero=%b",
                         out, zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h, zero=%b",
                         expected_out, expected_zero);
                $display("  Got:      out=%h, zero=%b",
                         out, zero);
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
