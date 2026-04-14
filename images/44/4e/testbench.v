`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg [3:0] op;
    reg [4:0] shamt;
    wire [31:0] hi;
    wire [31:0] lo;
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
        .op(op),
        .shamt(shamt),
        .hi(hi),
        .lo(lo),
        .y(y),
        .zero(zero)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise AND (Zero Result)", test_num);
            op = 4'b0000; a = 32'hAAAAAAAA; b = 32'h55555555; shamt = 5'd0;
            #1;

            check_outputs(32'h0, 32'h0, 32'h0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise OR", test_num);
            op = 4'b0001; a = 32'hF0F0F0F0; b = 32'h0F0F0F0F; shamt = 5'd0;
            #1;

            check_outputs(32'h0, 32'h0, 32'hFFFFFFFF, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition", test_num);
            op = 4'b0010; a = 32'd100; b = 32'd250; shamt = 5'd0;
            #1;

            check_outputs(32'h0, 32'h0, 32'd350, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction (Positive)", test_num);
            op = 4'b0110; a = 32'd1000; b = 32'd400; shamt = 5'd0;
            #1;

            check_outputs(32'h0, 32'h0, 32'd600, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction (Zero Result)", test_num);
            op = 4'b0110; a = 32'h12345678; b = 32'h12345678; shamt = 5'd0;
            #1;

            check_outputs(32'h0, 32'h0, 32'h0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Shift Left Logical", test_num);
            op = 4'b0011; a = 32'h0; b = 32'h00000001; shamt = 5'd8;
            #1;

            check_outputs(32'h0, 32'h0, 32'h00000100, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Shift Right Logical", test_num);
            op = 4'b0100; a = 32'h0; b = 32'h80000000; shamt = 5'd4;
            #1;

            check_outputs(32'h0, 32'h0, 32'h08000000, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Comparison SLT (True)", test_num);
            op = 4'b0111; a = 32'd10; b = 32'd20; shamt = 5'd0;
            #1;

            check_outputs(32'h0, 32'h0, 32'd1, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Comparison SLT (False)", test_num);
            op = 4'b0111; a = 32'd50; b = 32'd20; shamt = 5'd0;
            #1;

            check_outputs(32'h0, 32'h0, 32'd0, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiplication", test_num);

            op = 4'b1000; a = 32'hFFFFFFFF; b = 32'h00000002; shamt = 5'd0;
            #1;

            check_outputs(32'h00000001, 32'hFFFFFFFE, 32'hFFFFFFFE, 1'b0);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition (Wrap-around)", test_num);
            op = 4'b0010; a = 32'hFFFFFFFF; b = 32'h00000001; shamt = 5'd0;
            #1;

            check_outputs(32'h0, 32'h0, 32'h00000000, 1'b1);
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
        input [31:0] expected_hi;
        input [31:0] expected_lo;
        input [31:0] expected_y;
        input expected_zero;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_hi === (expected_hi ^ hi ^ expected_hi) &&
                expected_lo === (expected_lo ^ lo ^ expected_lo) &&
                expected_y === (expected_y ^ y ^ expected_y) &&
                expected_zero === (expected_zero ^ zero ^ expected_zero)) begin
                $display("PASS");
                $display("  Outputs: hi=%h, lo=%h, y=%h, zero=%b",
                         hi, lo, y, zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hi=%h, lo=%h, y=%h, zero=%b",
                         expected_hi, expected_lo, expected_y, expected_zero);
                $display("  Got:      hi=%h, lo=%h, y=%h, zero=%b",
                         hi, lo, y, zero);
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
