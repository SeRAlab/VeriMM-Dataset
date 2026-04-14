`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] ALUCtrl;
    reg [31:0] inA;
    reg [31:0] inB;
    wire Zero;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUCtrl(ALUCtrl),
        .inA(inA),
        .inB(inB),
        .Zero(Zero),
        .out(out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case 001: Logical AND");
        ALUCtrl = 3'b000;
        inA = 32'hF0F0_AAAA;
        inB = 32'hFFFF_0000;

        #1;


        check_outputs(1'b0, 32'hF0F0_0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case 002: Logical OR");
        ALUCtrl = 3'b001;
        inA = 32'hF0F0_AAAA;
        inB = 32'h0F0F_5555;

        #1;


        check_outputs(1'b0, 32'hFFFF_FFFF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case 003: Addition");
        ALUCtrl = 3'b010;
        inA = 32'd12345678;
        inB = 32'd87654322;

        #1;


        check_outputs(1'b0, 32'd100000000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case 004: Addition resulting in Zero");
        ALUCtrl = 3'b010;
        inA = 32'hFFFF_FFFF;
        inB = 32'h0000_0001;

        #1;


        check_outputs(1'b1, 32'h0000_0000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case 005: Subtraction (A > B)");
        ALUCtrl = 3'b110;
        inA = 32'd1000;
        inB = 32'd400;

        #1;


        check_outputs(1'b0, 32'd600);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case 006: Subtraction (A = B)");
        ALUCtrl = 3'b110;
        inA = 32'hABCDE_123;
        inB = 32'hABCDE_123;

        #1;


        check_outputs(1'b1, 32'h0000_0000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case 007: SLT (True)");
        ALUCtrl = 3'b111;
        inA = 32'd50;
        inB = 32'd100;

        #1;


        check_outputs(1'b0, 32'h0000_0001);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case 008: SLT (False)");
        ALUCtrl = 3'b111;
        inA = 32'd100;
        inB = 32'd50;

        #1;


        check_outputs(1'b1, 32'h0000_0000);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case 009: SLL");
        ALUCtrl = 3'b011;
        inA = 32'h0000_0001;
        inB = 32'd10;

        #1;


        check_outputs(1'b0, 32'h0000_0400);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case 010: SLL to Zero");
        ALUCtrl = 3'b011;
        inA = 32'h8000_0000;
        inB = 32'd1;

        #1;


        check_outputs(1'b1, 32'h0000_0000);
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
        input expected_Zero;
        input [31:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Zero === (expected_Zero ^ Zero ^ expected_Zero) &&
                expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: Zero=%b, out=%h",
                         Zero, out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Zero=%b, out=%h",
                         expected_Zero, expected_out);
                $display("  Got:      Zero=%b, out=%h",
                         Zero, out);
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
