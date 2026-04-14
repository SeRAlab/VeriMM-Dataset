`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] Alu_in1;
    reg [7:0] Alu_in2;
    reg [2:0] Alu_sel;
    wire [7:0] Alu_out;
    wire Alu_zero_flg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Alu_in1(Alu_in1),
        .Alu_in2(Alu_in2),
        .Alu_sel(Alu_sel),
        .Alu_out(Alu_out),
        .Alu_zero_flg(Alu_zero_flg)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Addition (10 + 20)", test_num);
        Alu_in1 = 8'd10; Alu_in2 = 8'd20; Alu_sel = 3'b000;
        #1;

        check_outputs(8'd30, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Addition with wrap-around to zero (255 + 1)", test_num);
        Alu_in1 = 8'd255; Alu_in2 = 8'd1; Alu_sel = 3'b000;
        #1;

        check_outputs(8'd0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Subtraction (50 - 20)", test_num);
        Alu_in1 = 8'd50; Alu_in2 = 8'd20; Alu_sel = 3'b001;
        #1;

        check_outputs(8'd30, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Subtraction resulting in zero (15 - 15)", test_num);
        Alu_in1 = 8'd15; Alu_in2 = 8'd15; Alu_sel = 3'b001;
        #1;

        check_outputs(8'd0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Bitwise AND (0xAA & 0x0F)", test_num);
        Alu_in1 = 8'hAA; Alu_in2 = 8'h0F; Alu_sel = 3'b010;
        #1;

        check_outputs(8'h0A, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Bitwise AND resulting in zero (0xAA & 0x55)", test_num);
        Alu_in1 = 8'hAA; Alu_in2 = 8'h55; Alu_sel = 3'b010;
        #1;

        check_outputs(8'h00, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Bitwise OR (0xF0 | 0x0F)", test_num);
        Alu_in1 = 8'hF0; Alu_in2 = 8'h0F; Alu_sel = 3'b011;
        #1;

        check_outputs(8'hFF, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Bitwise NOT (~0x0F)", test_num);
        Alu_in1 = 8'h0F; Alu_in2 = 8'h00; Alu_sel = 3'b100;
        #1;

        check_outputs(8'hF0, 1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: Bitwise NOT resulting in zero (~0xFF)", test_num);
        Alu_in1 = 8'hFF; Alu_in2 = 8'h00; Alu_sel = 3'b100;
        #1;

        check_outputs(8'h00, 1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test %0d: SLT (True: 5 < 10)", test_num);
        Alu_in1 = 8'd5; Alu_in2 = 8'd10; Alu_sel = 3'b101;
        #1;

        check_outputs(8'd1, 1'b0);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        $display("Test %0d: SLT (False: 10 < 5)", test_num);
        Alu_in1 = 8'd10; Alu_in2 = 8'd5; Alu_sel = 3'b101;
        #1;

        check_outputs(8'd0, 1'b1);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        $display("Test %0d: Logical Left Shift (1 << 3)", test_num);
        Alu_in1 = 8'd1; Alu_in2 = 8'd3; Alu_sel = 3'b110;
        #1;

        check_outputs(8'd8, 1'b0);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        $display("Test %0d: Logical Right Shift (128 >> 2)", test_num);
        Alu_in1 = 8'd128; Alu_in2 = 8'd2; Alu_sel = 3'b111;
        #1;

        check_outputs(8'd32, 1'b0);
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
        testcase013();
        
        
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
        input [7:0] expected_Alu_out;
        input expected_Alu_zero_flg;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Alu_out === (expected_Alu_out ^ Alu_out ^ expected_Alu_out) &&
                expected_Alu_zero_flg === (expected_Alu_zero_flg ^ Alu_zero_flg ^ expected_Alu_zero_flg)) begin
                $display("PASS");
                $display("  Outputs: Alu_out=%h, Alu_zero_flg=%b",
                         Alu_out, Alu_zero_flg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Alu_out=%h, Alu_zero_flg=%b",
                         expected_Alu_out, expected_Alu_zero_flg);
                $display("  Got:      Alu_out=%h, Alu_zero_flg=%b",
                         Alu_out, Alu_zero_flg);
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
