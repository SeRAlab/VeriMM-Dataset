`timescale 1ns/1ps

module alu_8bit_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg [2:0] opcode;
    wire carry;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    alu_8bit dut (
        .a(a),
        .b(b),
        .opcode(opcode),
        .carry(carry),
        .result(result)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Addition (No Carry) - 15 + 10", test_num);
            opcode = 3'b000;
            a = 8'd15;
            b = 8'd10;
            #1;

            check_outputs(1'b0, 8'd25);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Addition (With Carry) - 255 + 1", test_num);
            opcode = 3'b000;
            a = 8'hFF;
            b = 8'h01;
            #1;

            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Subtraction (No Borrow) - 50 - 20", test_num);
            opcode = 3'b001;
            a = 8'd50;
            b = 8'd20;
            #1;

            check_outputs(1'b0, 8'd30);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Subtraction (With Borrow) - 10 - 20", test_num);
            opcode = 3'b001;
            a = 8'd10;
            b = 8'd20;

            #1;


            check_outputs(1'b1, 8'hF6);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Bitwise AND - 0xF0 & 0xCC", test_num);
            opcode = 3'b010;
            a = 8'hF0;
            b = 8'hCC;
            #1;

            check_outputs(1'b0, 8'hC0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Bitwise OR - 0xAA | 0x55", test_num);
            opcode = 3'b011;
            a = 8'hAA;
            b = 8'h55;
            #1;

            check_outputs(1'b0, 8'hFF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Bitwise XOR - 0xFF ^ 0x0F", test_num);
            opcode = 3'b100;
            a = 8'hFF;
            b = 8'h0F;
            #1;

            check_outputs(1'b0, 8'hF0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Addition with Zero", test_num);
            opcode = 3'b000;
            a = 8'hA5;
            b = 8'h00;
            #1;

            check_outputs(1'b0, 8'hA5);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: XOR Same Values", test_num);
            opcode = 3'b100;
            a = 8'h55;
            b = 8'h55;
            #1;

            check_outputs(1'b0, 8'h00);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: Subtraction Resulting in Zero", test_num);
            opcode = 3'b001;
            a = 8'h80;
            b = 8'h80;
            #1;

            check_outputs(1'b0, 8'h00);
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
        input [7:0] expected_result;
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
