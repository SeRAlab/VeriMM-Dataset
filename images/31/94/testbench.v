`timescale 1ns/1ps

module alu_8bit_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg [2:0] opcode;
    wire [7:0] R;
    wire Z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    alu_8bit dut (
        .A(A),
        .B(B),
        .opcode(opcode),
        .R(R),
        .Z(Z)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Addition (10 + 20)", test_num);
        A = 8'd10; B = 8'd20; opcode = 3'b000;
        #1;

        check_outputs(8'd30, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Addition Overflow (200 + 60)", test_num);
        A = 8'd200; B = 8'd60; opcode = 3'b000;
        #1;

        check_outputs(8'd4, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Addition Resulting in Zero (255 + 1)", test_num);
        A = 8'hFF; B = 8'h01; opcode = 3'b000;
        #1;

        check_outputs(8'h00, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Subtraction (50 - 20)", test_num);
        A = 8'd50; B = 8'd20; opcode = 3'b001;
        #1;

        check_outputs(8'd30, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Subtraction Resulting in Zero (100 - 100)", test_num);
        A = 8'd100; B = 8'd100; opcode = 3'b001;
        #1;

        check_outputs(8'h00, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Bitwise AND (0xAA & 0xF0)", test_num);
        A = 8'hAA; B = 8'hF0; opcode = 3'b010;
        #1;

        check_outputs(8'hA0, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Bitwise AND Resulting in Zero (0x55 & 0xAA)", test_num);
        A = 8'h55; B = 8'hAA; opcode = 3'b010;
        #1;

        check_outputs(8'h00, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Bitwise OR (0x0F | 0xF0)", test_num);
        A = 8'h0F; B = 8'hF0; opcode = 3'b011;
        #1;

        check_outputs(8'hFF, 1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: Bitwise XOR (0xFF ^ 0xAA)", test_num);
        A = 8'hFF; B = 8'hAA; opcode = 3'b100;
        #1;

        check_outputs(8'h55, 1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test %0d: Bitwise NOR (~(0x01 | 0x02))", test_num);
        A = 8'h01; B = 8'h02; opcode = 3'b101;
        #1;

        check_outputs(8'hFC, 1'b0);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        $display("Test %0d: Bitwise NAND (~(0xFF & 0x0F))", test_num);
        A = 8'hFF; B = 8'h0F; opcode = 3'b110;
        #1;

        check_outputs(8'hF0, 1'b0);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        $display("Test %0d: Comparison A < B (5 < 10)", test_num);
        A = 8'd5; B = 8'd10; opcode = 3'b111;
        #1;

        check_outputs(8'd1, 1'b0);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        $display("Test %0d: Comparison A < B (10 < 5)", test_num);
        A = 8'd10; B = 8'd5; opcode = 3'b111;
        #1;

        check_outputs(8'd0, 1'b1);
    end
        endtask

    task testcase014;

    begin
        test_num = 14;
        $display("Test %0d: Comparison A < B (5 < 5)", test_num);
        A = 8'd5; B = 8'd5; opcode = 3'b111;
        #1;

        check_outputs(8'd0, 1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("alu_8bit Testbench");
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
        testcase014();
        
        
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
        input [7:0] expected_R;
        input expected_Z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_R === (expected_R ^ R ^ expected_R) &&
                expected_Z === (expected_Z ^ Z ^ expected_Z)) begin
                $display("PASS");
                $display("  Outputs: R=%h, Z=%b",
                         R, Z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: R=%h, Z=%b",
                         expected_R, expected_Z);
                $display("  Got:      R=%h, Z=%b",
                         R, Z);
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
