`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a;
    reg [15:0] b;
    reg [3:0] op;
    wire ovfl;
    wire [15:0] r;
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
        .ovfl(ovfl),
        .r(r),
        .zero(zero)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition (5 + 10)", test_num);
            op = 4'd0; a = 16'd5; b = 16'd10;
            #1;

            check_outputs(1'b0, 16'd15, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition Overflow (7FFF + 1)", test_num);
            op = 4'd0; a = 16'h7FFF; b = 16'h0001;
            #1;

            check_outputs(1'b1, 16'h8000, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction (20 - 20)", test_num);
            op = 4'd1; a = 16'd20; b = 16'd20;
            #1;

            check_outputs(1'b0, 16'd0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction Overflow (8000 - 1)", test_num);
            op = 4'd1; a = 16'h8000; b = 16'h0001;
            #1;

            check_outputs(1'b1, 16'h7FFF, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise AND", test_num);
            op = 4'd2; a = 16'hAAAA; b = 16'hF0F0;
            #1;

            check_outputs(1'b0, 16'hA0A0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise OR", test_num);
            op = 4'd3; a = 16'h1234; b = 16'h8765;
            #1;

            check_outputs(1'b0, 16'h9775, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise XOR", test_num);
            op = 4'd4; a = 16'hFFFF; b = 16'hAAAA;
            #1;

            check_outputs(1'b0, 16'h5555, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise NOT (A)", test_num);
            op = 4'd5; a = 16'h00FF; b = 16'h0000;
            #1;

            check_outputs(1'b0, 16'hFF00, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: SLL (1 << 4)", test_num);
            op = 4'd6; a = 16'h0001; b = 16'h0004;
            #1;

            check_outputs(1'b0, 16'h0010, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: SRL (8000 >> 4)", test_num);
            op = 4'd7; a = 16'h8000; b = 16'h0004;
            #1;

            check_outputs(1'b0, 16'h0800, 1'b0);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Comparison SLT (5 < 10)", test_num);
            op = 4'd8; a = 16'd5; b = 16'd10;
            #1;

            check_outputs(1'b0, 16'h0001, 1'b0);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Comparison SLT (10 < 5)", test_num);
            op = 4'd8; a = 16'd10; b = 16'd5;
            #1;

            check_outputs(1'b0, 16'h0000, 1'b1);
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
        input expected_ovfl;
        input [15:0] expected_r;
        input expected_zero;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ovfl === (expected_ovfl ^ ovfl ^ expected_ovfl) &&
                expected_r === (expected_r ^ r ^ expected_r) &&
                expected_zero === (expected_zero ^ zero ^ expected_zero)) begin
                $display("PASS");
                $display("  Outputs: ovfl=%b, r=%h, zero=%b",
                         ovfl, r, zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ovfl=%b, r=%h, zero=%b",
                         expected_ovfl, expected_r, expected_zero);
                $display("  Got:      ovfl=%b, r=%h, zero=%b",
                         ovfl, r, zero);
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
