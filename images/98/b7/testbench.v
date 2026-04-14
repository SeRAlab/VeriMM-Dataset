`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] i_a;
    reg [3:0] i_alucontrol;
    reg [31:0] i_b;
    reg [4:0] i_sa;
    wire [31:0] o_result;
    wire o_zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_a(i_a),
        .i_alucontrol(i_alucontrol),
        .i_b(i_b),
        .i_sa(i_sa),
        .o_result(o_result),
        .o_zero(o_zero)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Bitwise AND (Result Zero)", test_num);
        i_a = 32'hAAAA_AAAA;
        i_b = 32'h5555_5555;
        i_alucontrol = 4'b0000;
        i_sa = 5'd0;
        #1;

        check_outputs(32'h0000_0000, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Bitwise AND (Result Non-Zero)", test_num);
        i_a = 32'hFFFF_FFFF;
        i_b = 32'h1234_5678;
        i_alucontrol = 4'b0000;
        i_sa = 5'd0;
        #1;

        check_outputs(32'h1234_5678, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Bitwise OR", test_num);
        i_a = 32'hF0F0_F0F0;
        i_b = 32'h0F0F_0F0F;
        i_alucontrol = 4'b0001;
        i_sa = 5'd0;
        #1;

        check_outputs(32'hFFFF_FFFF, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Addition (Positive)", test_num);
        i_a = 32'd100;
        i_b = 32'd250;
        i_alucontrol = 4'b0010;
        i_sa = 5'd0;
        #1;

        check_outputs(32'd350, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Addition (Wrap to Zero)", test_num);
        i_a = 32'hFFFF_FFFF;
        i_b = 32'h0000_0001;
        i_alucontrol = 4'b0010;
        i_sa = 5'd0;
        #1;

        check_outputs(32'h0000_0000, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Subtraction (Positive Result)", test_num);
        i_a = 32'd500;
        i_b = 32'd200;
        i_alucontrol = 4'b0110;
        i_sa = 5'd0;
        #1;

        check_outputs(32'd300, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Subtraction (Zero Result)", test_num);
        i_a = 32'hABC1_2345;
        i_b = 32'hABC1_2345;
        i_alucontrol = 4'b0110;
        i_sa = 5'd0;
        #1;

        check_outputs(32'h0000_0000, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Logical Shift Left", test_num);
        i_a = 32'h0000_0001;
        i_b = 32'h0000_0000;
        i_alucontrol = 4'b0011;
        i_sa = 5'd8;
        #1;

        check_outputs(32'h0000_0100, 1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: Logical Shift Right", test_num);
        i_a = 32'h8000_0000;
        i_b = 32'h0000_0000;
        i_alucontrol = 4'b0100;
        i_sa = 5'd4;
        #1;

        check_outputs(32'h0800_0000, 1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test %0d: SLT (True)", test_num);
        i_a = 32'd10;
        i_b = 32'd20;
        i_alucontrol = 4'b0111;
        i_sa = 5'd0;
        #1;

        check_outputs(32'h0000_0001, 1'b0);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        $display("Test %0d: SLT (False)", test_num);
        i_a = 32'd50;
        i_b = 32'd20;
        i_alucontrol = 4'b0111;
        i_sa = 5'd0;
        #1;

        check_outputs(32'h0000_0000, 1'b1);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        $display("Test %0d: SRL (Shift all out)", test_num);
        i_a = 32'hFFFF_FFFF;
        i_alucontrol = 4'b0100;
        i_sa = 5'd31;
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
        input [31:0] expected_o_result;
        input expected_o_zero;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o_result === (expected_o_result ^ o_result ^ expected_o_result) &&
                expected_o_zero === (expected_o_zero ^ o_zero ^ expected_o_zero)) begin
                $display("PASS");
                $display("  Outputs: o_result=%h, o_zero=%b",
                         o_result, o_zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_result=%h, o_zero=%b",
                         expected_o_result, expected_o_zero);
                $display("  Got:      o_result=%h, o_zero=%b",
                         o_result, o_zero);
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
