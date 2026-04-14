`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg [2:0] f;
    reg sign;
    wire [31:0] y;
    wire zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .f(f),
        .sign(sign),
        .y(y),
        .zero(zero)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Logical AND", test_num);
            a = 32'hAAAA_AAAA;
            b = 32'h5555_5555;
            f = 3'b000;
            sign = 0;
            #1;

            check_outputs(32'h0000_0000, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Logical OR", test_num);
            a = 32'hF0F0_F0F0;
            b = 32'h0F0F_0F0F;
            f = 3'b001;
            sign = 0;
            #1;

            check_outputs(32'hFFFF_FFFF, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Addition (Unsigned)", test_num);
            a = 32'd100;
            b = 32'd250;
            f = 3'b010;
            sign = 0;
            #1;

            check_outputs(32'd350, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Addition (Unsigned Wrap)", test_num);
            a = 32'hFFFF_FFFF;
            b = 32'h0000_0001;
            f = 3'b010;
            sign = 0;
            #1;

            check_outputs(32'h0000_0000, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Logical XOR", test_num);
            a = 32'h1234_5678;
            b = 32'h1234_5678;
            f = 3'b011;
            sign = 0;
            #1;

            check_outputs(32'h0000_0000, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Subtraction (Positive Result)", test_num);
            a = 32'd500;
            b = 32'd200;
            f = 3'b100;
            sign = 0;
            #1;

            check_outputs(32'd300, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Subtraction (Zero Result)", test_num);
            a = 32'd1024;
            b = 32'd1024;
            f = 3'b100;
            sign = 0;
            #1;

            check_outputs(32'h0000_0000, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Comparison SLT (Unsigned - True)", test_num);
            a = 32'd10;
            b = 32'd20;
            f = 3'b101;
            sign = 0;
            #1;

            check_outputs(32'h0000_0001, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Comparison SLT (Unsigned - False)", test_num);
            a = 32'd20;
            b = 32'd10;
            f = 3'b101;
            sign = 0;
            #1;

            check_outputs(32'h0000_0000, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: Comparison SLT (Signed - Negative vs Positive)", test_num);
            a = 32'hFFFF_FFFB;
            b = 32'h0000_0002;
            f = 3'b101;
            sign = 1;

            #1;


            check_outputs(32'h0000_0001, 1'b0);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            $display("Testcase %0d: Comparison SLT (Signed - Large Unsigned but Negative)", test_num);
            a = 32'h0000_0002;
            b = 32'hFFFF_FFFB;
            f = 3'b101;
            sign = 1;

            #1;


            check_outputs(32'h0000_0000, 1'b1);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            $display("Testcase %0d: Comparison SLT (Unsigned - Interpreting Negative as Large)", test_num);
            a = 32'h0000_0002;
            b = 32'hFFFF_FFFB;
            f = 3'b101;
            sign = 0;

            #1;


            check_outputs(32'h0000_0001, 1'b0);
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
        testcase012();
        
        
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
        input [31:0] expected_y;
        input expected_zero;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y) &&
                expected_zero === (expected_zero ^ zero ^ expected_zero)) begin
                $display("PASS");
                $display("  Outputs: y=%h, zero=%b",
                         y, zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h, zero=%b",
                         expected_y, expected_zero);
                $display("  Got:      y=%h, zero=%b",
                         y, zero);
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
