`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [2:0] shift;
    wire carry;
    wire [7:0] res;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .shift(shift),
        .carry(carry),
        .res(res)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        a = 8'hA5; shift = 3'd0;
        $display("Test %0d: No shift - a=%h, shift=%d", test_num, a, shift);
        #1;

        check_outputs(1'b0, 8'hA5);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        a = 8'h80; shift = 3'd1;
        $display("Test %0d: Shift 1 (MSB=1) - a=%h, shift=%d", test_num, a, shift);
        #1;

        check_outputs(1'b1, 8'h00);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        a = 8'h7F; shift = 3'd1;
        $display("Test %0d: Shift 1 (MSB=0) - a=%h, shift=%d", test_num, a, shift);
        #1;

        check_outputs(1'b0, 8'hFE);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        a = 8'h40; shift = 3'd2;
        $display("Test %0d: Shift 2 (bit 6=1) - a=%h, shift=%d", test_num, a, shift);
        #1;

        check_outputs(1'b1, 8'h00);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        a = 8'h1F; shift = 3'd3;
        $display("Test %0d: Shift 3 (no carry) - a=%h, shift=%d", test_num, a, shift);
        #1;

        check_outputs(1'b0, 8'hF8);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        a = 8'h10; shift = 3'd4;
        $display("Test %0d: Shift 4 (bit 4=1) - a=%h, shift=%d", test_num, a, shift);
        #1;

        check_outputs(1'b1, 8'h00);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        a = 8'h01; shift = 3'd7;
        $display("Test %0d: Shift 7 (LSB moves to MSB) - a=%h, shift=%d", test_num, a, shift);
        #1;

        check_outputs(1'b0, 8'h80);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        a = 8'h02; shift = 3'd7;
        $display("Test %0d: Shift 7 (bit 1 shifted out) - a=%h, shift=%d", test_num, a, shift);
        #1;

        check_outputs(1'b1, 8'h00);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        a = 8'hFF; shift = 3'd1;
        $display("Test %0d: Shift 1 (All bits 1) - a=%h, shift=%d", test_num, a, shift);
        #1;

        check_outputs(1'b1, 8'hFE);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        a = 8'h00; shift = 3'd5;
        $display("Test %0d: Zero input - a=%h, shift=%d", test_num, a, shift);
        #1;

        check_outputs(1'b0, 8'h00);
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
        input expected_carry;
        input [7:0] expected_res;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_carry === (expected_carry ^ carry ^ expected_carry) &&
                expected_res === (expected_res ^ res ^ expected_res)) begin
                $display("PASS");
                $display("  Outputs: carry=%b, res=%h",
                         carry, res);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: carry=%b, res=%h",
                         expected_carry, expected_res);
                $display("  Got:      carry=%b, res=%h",
                         carry, res);
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
