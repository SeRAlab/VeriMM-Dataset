`timescale 1ns/1ps

module ALU_64bit_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] A;
    reg [63:0] B;
    reg [2:0] op_sel;
    wire [63:0] result;
    wire zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ALU_64bit dut (
        .A(A),
        .B(B),
        .op_sel(op_sel),
        .result(result),
        .zero(zero)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Addition (5 + 10)", test_num);
        A = 64'd5;
        B = 64'd10;
        op_sel = 3'b000;
        #1;

        check_outputs(64'd15, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Addition (Max + 1 = 0)", test_num);
        A = 64'hFFFF_FFFF_FFFF_FFFF;
        B = 64'd1;
        op_sel = 3'b000;
        #1;

        check_outputs(64'd0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Subtraction (100 - 40)", test_num);
        A = 64'd100;
        B = 64'd40;
        op_sel = 3'b001;
        #1;

        check_outputs(64'd60, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Subtraction (50 - 50 = 0)", test_num);
        A = 64'd50;
        B = 64'd50;
        op_sel = 3'b001;
        #1;

        check_outputs(64'd0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Subtraction (0 - 1)", test_num);
        A = 64'd0;
        B = 64'd1;
        op_sel = 3'b001;
        #1;

        check_outputs(64'hFFFF_FFFF_FFFF_FFFF, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Bitwise AND", test_num);
        A = 64'hF0F0_F0F0_AAAA_AAAA;
        B = 64'h0F0F_0F0F_AAAA_AAAA;
        op_sel = 3'b010;
        #1;

        check_outputs(64'h0000_0000_AAAA_AAAA, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Bitwise AND (Result Zero)", test_num);
        A = 64'hAAAA_AAAA_AAAA_AAAA;
        B = 64'h5555_5555_5555_5555;
        op_sel = 3'b010;
        #1;

        check_outputs(64'd0, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Bitwise OR", test_num);
        A = 64'hF0F0_F0F0_0000_0000;
        B = 64'h0F0F_0F0F_FFFF_FFFF;
        op_sel = 3'b011;
        #1;

        check_outputs(64'hFFFF_FFFF_FFFF_FFFF, 1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: Bitwise XOR", test_num);
        A = 64'h1234_5678_9ABC_DEF0;
        B = 64'hFFFF_FFFF_FFFF_FFFF;
        op_sel = 3'b100;
        #1;

        check_outputs(~64'h1234_5678_9ABC_DEF0, 1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test %0d: Bitwise XOR (A ^ A = 0)", test_num);
        A = 64'hDEAD_BEEF_CAFE_BABE;
        B = 64'hDEAD_BEEF_CAFE_BABE;
        op_sel = 3'b100;
        #1;

        check_outputs(64'd0, 1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ALU_64bit Testbench");
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
        input [63:0] expected_result;
        input expected_zero;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result) &&
                expected_zero === (expected_zero ^ zero ^ expected_zero)) begin
                $display("PASS");
                $display("  Outputs: result=%h, zero=%b",
                         result, zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h, zero=%b",
                         expected_result, expected_zero);
                $display("  Got:      result=%h, zero=%b",
                         result, zero);
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
