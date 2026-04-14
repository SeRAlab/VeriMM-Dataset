`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [3:0] ALUOp;
    reg [31:0] B;
    wire [31:0] ALUOUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .ALUOp(ALUOp),
        .B(B),
        .ALUOUT(ALUOUT)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition (100 + 50)", test_num);
        A = 32'd100;
        B = 32'd50;
        ALUOp = 4'd0;
        #1;

        check_outputs(32'd150);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Subtraction (100 - 30)", test_num);
        A = 32'd100;
        B = 32'd30;
        ALUOp = 4'd1;
        #1;

        check_outputs(32'd70);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bitwise AND", test_num);
        A = 32'hF0F0FFFF;
        B = 32'h0F0F0000;
        ALUOp = 4'd2;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bitwise OR", test_num);
        A = 32'hAAAA0000;
        B = 32'h00005555;
        ALUOp = 4'd3;
        #1;

        check_outputs(32'hAAAA5555);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bitwise XOR", test_num);
        A = 32'hAAAAAAAA;
        B = 32'hFFFFFFFF;
        ALUOp = 4'd4;
        #1;

        check_outputs(32'h55555555);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bitwise NOR", test_num);
        A = 32'h0000FFFF;
        B = 32'h00000000;
        ALUOp = 4'd5;
        #1;

        check_outputs(32'hFFFF0000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: SLL (1 << 4)", test_num);
        A = 32'h00000001;
        B = 32'd4;
        ALUOp = 4'd6;
        #1;

        check_outputs(32'h00000010);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: SRL (0x80000000 >> 4)", test_num);
        A = 32'h80000000;
        B = 32'd4;
        ALUOp = 4'd7;
        #1;

        check_outputs(32'h08000000);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: SRA (0x80000000 >>> 4)", test_num);
        A = 32'h80000000;
        B = 32'd4;
        ALUOp = 4'd8;
        #1;

        check_outputs(32'hF8000000);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: SLT (-1 < 1)", test_num);
        A = 32'hFFFFFFFF;
        B = 32'h00000001;
        ALUOp = 4'd9;
        #1;

        check_outputs(32'd1);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("Test %0d: SLTU (0xFFFFFFFF < 1)", test_num);
        A = 32'hFFFFFFFF;
        B = 32'h00000001;
        ALUOp = 4'd10;
        #1;

        check_outputs(32'd0);
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
        input [31:0] expected_ALUOUT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ALUOUT === (expected_ALUOUT ^ ALUOUT ^ expected_ALUOUT)) begin
                $display("PASS");
                $display("  Outputs: ALUOUT=%h",
                         ALUOUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALUOUT=%h",
                         expected_ALUOUT);
                $display("  Got:      ALUOUT=%h",
                         ALUOUT);
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
