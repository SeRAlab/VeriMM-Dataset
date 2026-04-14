`timescale 1ns/1ps

module ALU_64bit_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] A;
    reg [63:0] B;
    reg [2:0] opcode;
    wire carry_borrow;
    wire [63:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ALU_64bit dut (
        .A(A),
        .B(B),
        .opcode(opcode),
        .carry_borrow(carry_borrow),
        .result(result)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Addition (Basic)", test_num);
        A = 64'h0000000000000005;
        B = 64'h000000000000000A;
        opcode = 3'b000;
        #1;

        check_outputs(1'b0, 64'h000000000000000F);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Addition (Carry Out)", test_num);
        A = 64'hFFFFFFFFFFFFFFFF;
        B = 64'h0000000000000001;
        opcode = 3'b000;
        #1;

        check_outputs(1'b1, 64'h0000000000000000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Subtraction (Basic)", test_num);
        A = 64'h0000000000000014;
        B = 64'h0000000000000006;
        opcode = 3'b001;
        #1;

        check_outputs(1'b0, 64'h000000000000000E);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Subtraction (Borrow/Underflow)", test_num);
        A = 64'h0000000000000000;
        B = 64'h0000000000000001;
        opcode = 3'b001;
        #1;

        check_outputs(1'b1, 64'hFFFFFFFFFFFFFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Bitwise AND", test_num);
        A = 64'hAAAAAAAAAAAAAAAA;
        B = 64'hFFFFFFFF00000000;
        opcode = 3'b010;
        #1;

        check_outputs(1'b0, 64'hAAAAAAAA00000000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Bitwise OR", test_num);
        A = 64'h5555555555555555;
        B = 64'hAAAAAAAAAAAAAAAA;
        opcode = 3'b011;
        #1;

        check_outputs(1'b0, 64'hFFFFFFFFFFFFFFFF);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Bitwise XOR", test_num);
        A = 64'h1234567812345678;
        B = 64'h1234567812345678;
        opcode = 3'b100;
        #1;

        check_outputs(1'b0, 64'h0000000000000000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Shift Left", test_num);
        A = 64'h0000000000000001;
        B = 64'h0000000000000004;
        opcode = 3'b101;
        #1;

        check_outputs(1'b0, 64'h0000000000000010);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: Shift Right", test_num);
        A = 64'h0000000000000080;
        B = 64'h0000000000000003;
        opcode = 3'b110;
        #1;

        check_outputs(1'b0, 64'h0000000000000010);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test %0d: Compare (A < B is True)", test_num);
        A = 64'h0000000000000005;
        B = 64'h000000000000000A;
        opcode = 3'b111;
        #1;

        check_outputs(1'b0, 64'h0000000000000001);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        $display("Test %0d: Compare (A < B is False)", test_num);
        A = 64'h000000000000000A;
        B = 64'h0000000000000005;
        opcode = 3'b111;
        #1;

        check_outputs(1'b0, 64'h0000000000000000);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        $display("Test %0d: Compare (A == B is False)", test_num);
        A = 64'hFFFFFFFFFFFFFFFF;
        B = 64'hFFFFFFFFFFFFFFFF;
        opcode = 3'b111;
        #1;

        check_outputs(1'b0, 64'h0000000000000000);
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
        input expected_carry_borrow;
        input [63:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_carry_borrow === (expected_carry_borrow ^ carry_borrow ^ expected_carry_borrow) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: carry_borrow=%b, result=%h",
                         carry_borrow, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: carry_borrow=%b, result=%h",
                         expected_carry_borrow, expected_result);
                $display("  Got:      carry_borrow=%b, result=%h",
                         carry_borrow, result);
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
