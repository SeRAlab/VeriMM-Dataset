`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] ctrl;
    reg [7:0] op_A;
    reg [7:0] op_B;
    wire [7:0] alu_res;
    wire ov;
    wire zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ctrl(ctrl),
        .op_A(op_A),
        .op_B(op_B),
        .alu_res(alu_res),
        .ov(ov),
        .zero(zero)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition (10 + 20)", test_num);
        ctrl = 3'b000; op_A = 8'd10; op_B = 8'd20;
        #1;

        check_outputs(8'd30, 1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Subtraction (50 - 20)", test_num);
        ctrl = 3'b001; op_A = 8'd50; op_B = 8'd20;
        #1;

        check_outputs(8'd30, 1'b0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Subtraction Zero Flag (15 - 15)", test_num);
        ctrl = 3'b001; op_A = 8'd15; op_B = 8'd15;
        #1;

        check_outputs(8'd0, 1'b0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Increment (127 + 1)", test_num);
        ctrl = 3'b010; op_A = 8'd127; op_B = 8'hFF;
        #1;

        check_outputs(8'd128, 1'b0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Increment Wrap (255 + 1)", test_num);
        ctrl = 3'b010; op_A = 8'hFF; op_B = 8'h00;
        #1;

        check_outputs(8'h00, 1'b0, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Pass Operand A", test_num);
        ctrl = 3'b011; op_A = 8'hA5; op_B = 8'h5A;
        #1;

        check_outputs(8'hA5, 1'b0, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bitwise AND (0xCC & 0xAA)", test_num);
        ctrl = 3'b100; op_A = 8'hCC; op_B = 8'hAA;

        #1;


        check_outputs(8'h88, 1'b0, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bitwise OR (0xCC | 0xAA)", test_num);
        ctrl = 3'b101; op_A = 8'hCC; op_B = 8'hAA;

        #1;


        check_outputs(8'hEE, 1'b0, 1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bitwise XOR (0xCC ^ 0xAA)", test_num);
        ctrl = 3'b110; op_A = 8'hCC; op_B = 8'hAA;

        #1;


        check_outputs(8'h66, 1'b0, 1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bitwise NOT (~0x0F)", test_num);
        ctrl = 3'b111; op_A = 8'h0F; op_B = 8'hFF;
        #1;

        check_outputs(8'hF0, 1'b0, 1'b0);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bitwise NOT Zero Flag (~0xFF)", test_num);
        ctrl = 3'b111; op_A = 8'hFF; op_B = 8'h00;
        #1;

        check_outputs(8'h00, 1'b0, 1'b1);
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
        input [7:0] expected_alu_res;
        input expected_ov;
        input expected_zero;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_alu_res === (expected_alu_res ^ alu_res ^ expected_alu_res) &&
                expected_ov === (expected_ov ^ ov ^ expected_ov) &&
                expected_zero === (expected_zero ^ zero ^ expected_zero)) begin
                $display("PASS");
                $display("  Outputs: alu_res=%h, ov=%b, zero=%b",
                         alu_res, ov, zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: alu_res=%h, ov=%b, zero=%b",
                         expected_alu_res, expected_ov, expected_zero);
                $display("  Got:      alu_res=%h, ov=%b, zero=%b",
                         alu_res, ov, zero);
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
