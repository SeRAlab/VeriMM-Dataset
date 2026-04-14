`timescale 1ns/1ps

module ALU_32bit_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    reg [2:0] opcode;
    wire [31:0] result;
    wire zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ALU_32bit dut (
        .A(A),
        .B(B),
        .opcode(opcode),
        .result(result),
        .zero(zero)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: ADD 5 + 10", test_num);
            A = 32'd5;
            B = 32'd10;
            opcode = 3'b000;
            #1;

            check_outputs(32'd15, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: ADD 0xFFFFFFFF + 1 (Wrap-around to Zero)", test_num);
            A = 32'hFFFF_FFFF;
            B = 32'h0000_0001;
            opcode = 3'b000;
            #1;

            check_outputs(32'h0000_0000, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: SUB 20 - 5", test_num);
            A = 32'd20;
            B = 32'd5;
            opcode = 3'b001;
            #1;

            check_outputs(32'd15, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: SUB 100 - 100", test_num);
            A = 32'd100;
            B = 32'd100;
            opcode = 3'b001;
            #1;

            check_outputs(32'h0000_0000, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: AND 0xF0F0F0F0 & 0xAAAA_AAAA", test_num);
            A = 32'hF0F0_F0F0;
            B = 32'hAAAA_AAAA;
            opcode = 3'b010;
            #1;

            check_outputs(32'hA0A0_A0A0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: OR 0xF0F0F0F0 | 0x0F0F_0F0F", test_num);
            A = 32'hF0F0_F0F0;
            B = 32'h0F0F_0F0F;
            opcode = 3'b011;
            #1;

            check_outputs(32'hFFFF_FFFF, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: XOR 0x12345678 ^ 0x12345678", test_num);
            A = 32'h1234_5678;
            B = 32'h1234_5678;
            opcode = 3'b100;
            #1;

            check_outputs(32'h0000_0000, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: NAND 0xFFFF0000 & 0x0000FFFF", test_num);
            A = 32'hFFFF_0000;
            B = 32'h0000_FFFF;
            opcode = 3'b101;
            #1;

            check_outputs(32'hFFFF_FFFF, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: NOR 0x00000000 | 0x00000000", test_num);
            A = 32'h0000_0000;
            B = 32'h0000_0000;
            opcode = 3'b110;
            #1;

            check_outputs(32'hFFFF_FFFF, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: XNOR 0xAAAA_AAAA ^ 0x5555_5555", test_num);
            A = 32'hAAAA_AAAA;
            B = 32'h5555_5555;
            opcode = 3'b111;
            #1;

            check_outputs(32'h0000_0000, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ALU_32bit Testbench");
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
        input [31:0] expected_result;
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
