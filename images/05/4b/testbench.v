`timescale 1ns/1ps

module ALU_16bit_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] A;
    reg [15:0] B;
    reg [2:0] opcode;
    wire cmp_result;
    wire [15:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ALU_16bit dut (
        .A(A),
        .B(B),
        .opcode(opcode),
        .cmp_result(cmp_result),
        .result(result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition (1234 + 1111)", test_num);
            A = 16'h1234; B = 16'h1111; opcode = 3'b000;
            #1;

            check_outputs(1'b0, 16'h2345);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition Overflow (FFFF + 0001)", test_num);
            A = 16'hFFFF; B = 16'h0001; opcode = 3'b000;
            #1;

            check_outputs(1'b0, 16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction (0050 - 0020)", test_num);
            A = 16'h0050; B = 16'h0020; opcode = 3'b001;
            #1;

            check_outputs(1'b0, 16'h0030);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction Underflow (0000 - 0001)", test_num);
            A = 16'h0000; B = 16'h0001; opcode = 3'b001;
            #1;

            check_outputs(1'b0, 16'hFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise AND (AAAA & F0F0)", test_num);
            A = 16'hAAAA; B = 16'hF0F0; opcode = 3'b010;
            #1;

            check_outputs(1'b0, 16'hA0A0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise OR (5555 | 0F0F)", test_num);
            A = 16'h5555; B = 16'h0F0F; opcode = 3'b011;
            #1;

            check_outputs(1'b0, 16'h5F5F);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise XOR (FFFF ^ 1234)", test_num);
            A = 16'hFFFF; B = 16'h1234; opcode = 3'b100;
            #1;

            check_outputs(1'b0, 16'hEDCB);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Comparison (10 < 20)", test_num);
            A = 16'd10; B = 16'd20; opcode = 3'b101;
            #1;

            check_outputs(1'b1, 16'h0000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Comparison (20 < 10)", test_num);
            A = 16'd20; B = 16'd10; opcode = 3'b101;
            #1;

            check_outputs(1'b0, 16'h0000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Logical Shift Left (0001 << 4)", test_num);
            A = 16'h0001; B = 16'h0004; opcode = 3'b110;
            #1;

            check_outputs(1'b0, 16'h0010);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Logical Shift Right (8000 >> 2)", test_num);
            A = 16'h8000; B = 16'h0002; opcode = 3'b111;
            #1;

            check_outputs(1'b0, 16'h2000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ALU_16bit Testbench");
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
        input expected_cmp_result;
        input [15:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cmp_result === (expected_cmp_result ^ cmp_result ^ expected_cmp_result) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: cmp_result=%b, result=%h",
                         cmp_result, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cmp_result=%b, result=%h",
                         expected_cmp_result, expected_result);
                $display("  Got:      cmp_result=%b, result=%h",
                         cmp_result, result);
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
