`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] ALUA;
    reg [31:0] ALUB;
    reg [2:0] ALUOp;
    wire [31:0] ALU;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUA(ALUA),
        .ALUB(ALUB),
        .ALUOp(ALUOp),
        .ALU(ALU)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Addition (5 + 10)", test_num);
        ALUA = 32'd5;
        ALUB = 32'd10;
        ALUOp = 3'b001;
        #1;

        check_outputs(32'd15);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Addition (Max + 1)", test_num);
        ALUA = 32'hFFFFFFFF;
        ALUB = 32'h00000001;
        ALUOp = 3'b001;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Subtraction (20 - 5)", test_num);
        ALUA = 32'd20;
        ALUB = 32'd5;
        ALUOp = 3'b010;
        #1;

        check_outputs(32'd15);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Subtraction (5 - 10 = -5)", test_num);
        ALUA = 32'd5;
        ALUB = 32'd10;
        ALUOp = 3'b010;
        #1;

        check_outputs(32'hFFFFFFF6 + 32'd1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Bitwise OR (0xAAAA5555 | 0x5555AAAA)", test_num);
        ALUA = 32'hAAAA5555;
        ALUB = 32'h5555AAAA;
        ALUOp = 3'b011;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Bitwise OR (Val | 0)", test_num);
        ALUA = 32'h12345678;
        ALUB = 32'h00000000;
        ALUOp = 3'b011;
        #1;

        check_outputs(32'h12345678);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Invalid Op (000)", test_num);
        ALUA = 32'hFFFFFFFF;
        ALUB = 32'hFFFFFFFF;
        ALUOp = 3'b000;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Invalid Op (100)", test_num);
        ALUA = 32'h12345678;
        ALUB = 32'h12345678;
        ALUOp = 3'b100;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: Subtraction (0 - 0)", test_num);
        ALUA = 32'h0;
        ALUB = 32'h0;
        ALUOp = 3'b010;
        #1;

        check_outputs(32'h0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test %0d: Addition (0x12340000 + 0x00005678)", test_num);
        ALUA = 32'h12340000;
        ALUB = 32'h00005678;
        ALUOp = 3'b001;
        #1;

        check_outputs(32'h12345678);
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
        input [31:0] expected_ALU;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ALU === (expected_ALU ^ ALU ^ expected_ALU)) begin
                $display("PASS");
                $display("  Outputs: ALU=%h",
                         ALU);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALU=%h",
                         expected_ALU);
                $display("  Got:      ALU=%h",
                         ALU);
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
