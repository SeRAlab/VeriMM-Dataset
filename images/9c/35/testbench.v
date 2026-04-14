`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] ALUOP;
    reg [31:0] ALU_A;
    reg [31:0] ALU_B;
    reg sltiu;
    wire [31:0] ALU_C;
    wire ALU_ZERO;
    wire G;
    wire G_E;
    wire L;
    wire L_E;
    wire NE;
    wire less;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUOP(ALUOP),
        .ALU_A(ALU_A),
        .ALU_B(ALU_B),
        .sltiu(sltiu),
        .ALU_C(ALU_C),
        .ALU_ZERO(ALU_ZERO),
        .G(G),
        .G_E(G_E),
        .L(L),
        .L_E(L_E),
        .NE(NE),
        .less(less)
    );
    task testcase001;

    begin
        test_num = 1;
        ALU_A = 32'd100;
        ALU_B = 32'd200;
        ALUOP = 2'b00;
        sltiu = 1'b0;

        #1;


        check_outputs(32'd300, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        ALU_A = 32'd500;
        ALU_B = 32'd200;
        ALUOP = 2'b01;
        sltiu = 1'b0;

        #1;


        check_outputs(32'd300, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        ALU_A = 32'd20;
        ALU_B = 32'd50;
        ALUOP = 2'b01;
        sltiu = 1'b0;

        #1;


        check_outputs(32'hFFFFFFE2, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        ALU_A = 32'h0F0F0F0F;
        ALU_B = 32'hF0F0F0F0;
        ALUOP = 2'b10;
        sltiu = 1'b0;

        #1;


        check_outputs(32'hFFFFFFFF, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        ALU_A = 32'h12345678;
        ALU_B = 32'h12345678;
        ALUOP = 2'b01;
        sltiu = 1'b0;

        #1;


        check_outputs(32'h00000000, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        ALU_A = 32'hFFFFFFFF;
        ALU_B = 32'h00000001;
        ALUOP = 2'b00;
        sltiu = 1'b0;

        #1;


        check_outputs(32'h00000000, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        ALU_A = 32'hFFFFFFFF;
        ALU_B = 32'h00000001;
        ALUOP = 2'b00;
        sltiu = 1'b1;

        #1;


        check_outputs(32'h00000000, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        ALU_A = 32'h7FFFFFFF;
        ALU_B = 32'h80000000;
        ALUOP = 2'b00;
        sltiu = 1'b0;

        #1;


        check_outputs(32'hFFFFFFFF, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        ALU_A = 32'hFFFFFFFF;
        ALU_B = 32'hFFFFFFFF;
        ALUOP = 2'b00;
        sltiu = 1'b0;

        #1;


        check_outputs(32'hFFFFFFFE, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        ALU_A = 32'd0;
        ALU_B = 32'd0;
        ALUOP = 2'b10;
        sltiu = 1'b1;

        #1;


        check_outputs(32'h00000000, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0);
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
        input [31:0] expected_ALU_C;
        input expected_ALU_ZERO;
        input expected_G;
        input expected_G_E;
        input expected_L;
        input expected_L_E;
        input expected_NE;
        input expected_less;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ALU_C === (expected_ALU_C ^ ALU_C ^ expected_ALU_C) &&
                expected_ALU_ZERO === (expected_ALU_ZERO ^ ALU_ZERO ^ expected_ALU_ZERO) &&
                expected_G === (expected_G ^ G ^ expected_G) &&
                expected_G_E === (expected_G_E ^ G_E ^ expected_G_E) &&
                expected_L === (expected_L ^ L ^ expected_L) &&
                expected_L_E === (expected_L_E ^ L_E ^ expected_L_E) &&
                expected_NE === (expected_NE ^ NE ^ expected_NE) &&
                expected_less === (expected_less ^ less ^ expected_less)) begin
                $display("PASS");
                $display("  Outputs: ALU_C=%h, ALU_ZERO=%b, G=%b, G_E=%b, L=%b, L_E=%b, NE=%b, less=%b",
                         ALU_C, ALU_ZERO, G, G_E, L, L_E, NE, less);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALU_C=%h, ALU_ZERO=%b, G=%b, G_E=%b, L=%b, L_E=%b, NE=%b, less=%b",
                         expected_ALU_C, expected_ALU_ZERO, expected_G, expected_G_E, expected_L, expected_L_E, expected_NE, expected_less);
                $display("  Got:      ALU_C=%h, ALU_ZERO=%b, G=%b, G_E=%b, L=%b, L_E=%b, NE=%b, less=%b",
                         ALU_C, ALU_ZERO, G, G_E, L, L_E, NE, less);
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
