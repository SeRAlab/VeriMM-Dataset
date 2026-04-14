`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [4:0] aluc;
    reg [31:0] b;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .aluc(aluc),
        .b(b),
        .result(result)
    );
    task testcase001;

    begin
        test_num = 1;
        a = 32'h0000000A; b = 32'h00000014; aluc = ALU_ADD;
        $display("Test %0d: Addition (10 + 20)", test_num);
        #1;

        check_outputs(32'h0000001E);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        a = 32'h00000032; b = 32'h0000000A; aluc = ALU_SUB;
        $display("Test %0d: Subtraction (50 - 10)", test_num);
        #1;

        check_outputs(32'h00000028);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        a = 32'hF0F0FFFF; b = 32'hAAAA5555; aluc = ALU_AND;
        $display("Test %0d: Bitwise AND", test_num);
        #1;

        check_outputs(32'hA0A05555);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        a = 32'hF0F00000; b = 32'h0000AAAA; aluc = ALU_OR;
        $display("Test %0d: Bitwise OR", test_num);
        #1;

        check_outputs(32'hF0F0AAAA);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        a = 32'hFFFFFFFF; b = 32'h12345678; aluc = ALU_XOR;
        $display("Test %0d: Bitwise XOR", test_num);
        #1;

        check_outputs(32'hEDCBA987);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        a = 32'h00000000; b = 32'h00000000; aluc = ALU_NOR;
        $display("Test %0d: Bitwise NOR (Zero check)", test_num);
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        a = 32'hFFFFFFFF; b = 32'h00000001; aluc = ALU_SLT;
        $display("Test %0d: SLT Signed (-1 < 1)", test_num);
        #1;

        check_outputs(32'h00000001);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        a = 32'hFFFFFFFF; b = 32'h00000001; aluc = ALU_SLTU;
        $display("Test %0d: SLTU Unsigned (MAX < 1)", test_num);
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        a = 32'h00000004; b = 32'h00000001; aluc = ALU_SLL;
        $display("Test %0d: SLL (1 << 4)", test_num);
        #1;

        check_outputs(32'h00000010);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        a = 32'h00000002; b = 32'h80000000; aluc = ALU_SRL;
        $display("Test %0d: SRL (MSB shift right logical)", test_num);
        #1;

        check_outputs(32'h20000000);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        a = 32'h00000004; b = 32'hF0000000; aluc = ALU_SRA;
        $display("Test %0d: SRA (Sign extension check)", test_num);
        #1;

        check_outputs(32'hFF000000);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        a = 32'h00000000; b = 32'h0000ABCD; aluc = ALU_LUI;
        $display("Test %0d: LUI (Load ABCD to upper)", test_num);
        #1;

        check_outputs(32'hABCD0000);
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
        input [31:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
