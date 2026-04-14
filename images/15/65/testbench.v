`timescale 1ns/1ps

module ALU_64bit_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] A;
    reg [63:0] B;
    reg [2:0] opcode;
    wire carry_flag;
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
        .carry_flag(carry_flag),
        .result(result)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Addition (No Carry)", test_num);
        opcode = 3'd0;
        A = 64'h0000_0000_0000_0005;
        B = 64'h0000_0000_0000_000A;
        #1;

        check_outputs(1'b0, 64'h0000_0000_0000_000F);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Addition (With Carry)", test_num);
        opcode = 3'd0;
        A = 64'hFFFF_FFFF_FFFF_FFFF;
        B = 64'h0000_0000_0000_0001;
        #1;

        check_outputs(1'b1, 64'h0000_0000_0000_0000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Subtraction (Positive Result)", test_num);
        opcode = 3'd1;
        A = 64'h0000_0000_0000_000A;
        B = 64'h0000_0000_0000_0004;
        #1;

        check_outputs(1'b0, 64'h0000_0000_0000_0006);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Subtraction (With Borrow)", test_num);
        opcode = 3'd1;
        A = 64'h0000_0000_0000_0000;
        B = 64'h0000_0000_0000_0001;
        #1;

        check_outputs(1'b1, 64'hFFFF_FFFF_FFFF_FFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Bitwise AND", test_num);
        opcode = 3'd2;
        A = 64'hAAAA_AAAA_AAAA_AAAA;
        B = 64'hFFFF_0000_FFFF_0000;
        #1;

        check_outputs(1'b0, 64'hAAAA_0000_AAAA_0000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Bitwise OR", test_num);
        opcode = 3'd3;
        A = 64'h5555_5555_5555_5555;
        B = 64'h0000_FFFF_0000_FFFF;
        #1;

        check_outputs(1'b0, 64'h5555_FFFF_5555_FFFF);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Bitwise XOR", test_num);
        opcode = 3'd4;
        A = 64'hF0F0_F0F0_F0F0_F0F0;
        B = 64'hFFFF_FFFF_0000_0000;
        #1;

        check_outputs(1'b0, 64'h0F0F_0F0F_F0F0_F0F0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Logical Shift Left", test_num);
        opcode = 3'd5;
        A = 64'h0000_0000_0000_0001;
        B = 64'd4;
        #1;

        check_outputs(1'b0, 64'h0000_0000_0000_0010);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: Logical Shift Right", test_num);
        opcode = 3'd6;
        A = 64'h8000_0000_0000_0000;
        B = 64'd1;
        #1;

        check_outputs(1'b0, 64'h4000_0000_0000_0000);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test %0d: SLT (True)", test_num);
        opcode = 3'd7;
        A = 64'h0000_0000_0000_0005;
        B = 64'h0000_0000_0000_000A;
        #1;

        check_outputs(1'b0, 64'h0000_0000_0000_0001);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        $display("Test %0d: SLT (False)", test_num);
        opcode = 3'd7;
        A = 64'hFFFF_FFFF_FFFF_FFFF;
        B = 64'h0000_0000_0000_0001;
        #1;

        check_outputs(1'b0, 64'h0000_0000_0000_0000);
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
        input expected_carry_flag;
        input [63:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_carry_flag === (expected_carry_flag ^ carry_flag ^ expected_carry_flag) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: carry_flag=%b, result=%h",
                         carry_flag, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: carry_flag=%b, result=%h",
                         expected_carry_flag, expected_result);
                $display("  Got:      carry_flag=%b, result=%h",
                         carry_flag, result);
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
