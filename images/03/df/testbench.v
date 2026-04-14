`timescale 1ns/1ps

module ALU_64bit_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] A;
    reg [2:0] ALU_op;
    reg [63:0] B;
    wire [63:0] result;
    wire zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ALU_64bit dut (
        .A(A),
        .ALU_op(ALU_op),
        .B(B),
        .result(result),
        .zero(zero)
    );
    task testcase001;

        begin
            test_num = 1;
            A = 64'h000000000000000A;
            B = 64'h0000000000000014;
            ALU_op = OP_ADD;
            #1;

            check_outputs(64'h000000000000001E, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            A = 64'hFFFFFFFFFFFFFFFF;
            B = 64'h0000000000000001;
            ALU_op = OP_ADD;
            #1;

            check_outputs(64'h0000000000000000, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            A = 64'h0000000000000064;
            B = 64'h000000000000000A;
            ALU_op = OP_SUB;
            #1;

            check_outputs(64'h000000000000005A, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            A = 64'hABCDE00012345678;
            B = 64'hABCDE00012345678;
            ALU_op = OP_SUB;
            #1;

            check_outputs(64'h0000000000000000, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            A = 64'hF0F0F0F0F0F0F0F0;
            B = 64'h0F0F0F0F0F0F0F0F;
            ALU_op = OP_AND;
            #1;

            check_outputs(64'h0000000000000000, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            A = 64'hAAAAAAAAAAAAAAAA;
            B = 64'h5555555555555555;
            ALU_op = OP_OR;
            #1;

            check_outputs(64'hFFFFFFFFFFFFFFFF, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            A = 64'h1234567812345678;
            B = 64'h1234567812345678;
            ALU_op = OP_XOR;
            #1;

            check_outputs(64'h0000000000000000, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            A = 64'h0000000000000000;
            B = 64'h0000000000000001;
            ALU_op = OP_SUB;
            #1;

            check_outputs(64'hFFFFFFFFFFFFFFFF, 1'b0);
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
