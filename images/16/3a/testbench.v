`timescale 1ns/1ps

module ALU_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a;
    reg [15:0] b;
    reg [3:0] opcode;
    wire carry;
    wire [15:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ALU dut (
        .a(a),
        .b(b),
        .opcode(opcode),
        .carry(carry),
        .result(result)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Addition (Normal)", test_num);
        opcode = 4'b0000;
        a = 16'h1234;
        b = 16'h1111;
        #1;

        check_outputs(1'b0, 16'h2345);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Addition (With Carry)", test_num);
        opcode = 4'b0000;
        a = 16'hFFFF;
        b = 16'h0001;
        #1;

        check_outputs(1'b1, 16'h0000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Subtraction (Normal)", test_num);
        opcode = 4'b0001;
        a = 16'h0020;
        b = 16'h0005;
        #1;

        check_outputs(1'b0, 16'h001B);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Subtraction (With Borrow/Carry)", test_num);
        opcode = 4'b0001;
        a = 16'h0000;
        b = 16'h0001;
        #1;

        check_outputs(1'b1, 16'hFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Bitwise AND", test_num);
        opcode = 4'b0010;
        a = 16'hAAAA;
        b = 16'hF0F0;
        #1;

        check_outputs(1'b0, 16'hA0A0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Bitwise OR", test_num);
        opcode = 4'b0011;
        a = 16'h1234;
        b = 16'h8765;
        #1;

        check_outputs(1'b0, 16'h9775);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Bitwise XOR", test_num);
        opcode = 4'b0100;
        a = 16'h5555;
        b = 16'hFFFF;
        #1;

        check_outputs(1'b0, 16'hAAAA);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Shift Left (a << b)", test_num);
        opcode = 4'b0101;
        a = 16'h0001;
        b = 16'h0004;
        #1;

        check_outputs(1'b0, 16'h0010);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: Shift Right (a >> b)", test_num);
        opcode = 4'b0110;
        a = 16'h8000;
        b = 16'h0004;
        #1;

        check_outputs(1'b0, 16'h0800);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test %0d: Addition (Zero + Zero)", test_num);
        opcode = 4'b0000;
        a = 16'h0000;
        b = 16'h0000;
        #1;

        check_outputs(1'b0, 16'h0000);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        $display("Test %0d: Subtraction (Equal Values)", test_num);
        opcode = 4'b0001;
        a = 16'hABCD;
        b = 16'hABCD;
        #1;

        check_outputs(1'b0, 16'h0000);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        $display("Test %0d: Logical AND (Zero result)", test_num);
        opcode = 4'b0010;
        a = 16'hAAAA;
        b = 16'h5555;
        #1;

        check_outputs(1'b0, 16'h0000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ALU Testbench");
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
        input expected_carry;
        input [15:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_carry === (expected_carry ^ carry ^ expected_carry) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: carry=%b, result=%h",
                         carry, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: carry=%b, result=%h",
                         expected_carry, expected_result);
                $display("  Got:      carry=%b, result=%h",
                         carry, result);
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
