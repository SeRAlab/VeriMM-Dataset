`timescale 1ns/1ps

module ALU_64bit_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] A;
    reg [2:0] ALU_control;
    reg [63:0] B;
    wire [63:0] ALU_result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ALU_64bit dut (
        .A(A),
        .ALU_control(ALU_control),
        .B(B),
        .ALU_result(ALU_result)
    );
    task testcase001;

        begin
            $display("Testcase 001: Addition (Basic)");
            A = 64'h0000000000000005;
            B = 64'h000000000000000A;
            ALU_control = 3'b000;
            #1;

            check_outputs(64'h000000000000000F);

            $display("Testcase 002: Addition (Overflow/Wrap)");
            A = 64'hFFFFFFFFFFFFFFFF;
            B = 64'h0000000000000001;
            ALU_control = 3'b000;
            #1;

            check_outputs(64'h0000000000000000);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 003: Subtraction (Basic)");
            A = 64'h0000000000000014;
            B = 64'h0000000000000006;
            ALU_control = 3'b001;
            #1;

            check_outputs(64'h000000000000000E);

            $display("Testcase 004: Subtraction (Underflow/Wrap)");
            A = 64'h0000000000000000;
            B = 64'h0000000000000001;
            ALU_control = 3'b001;
            #1;

            check_outputs(64'hFFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 005: Bitwise AND");
            A = 64'hF0F0F0F0F0F0F0F0;
            B = 64'hAAAAAAAABBBBBBBB;
            ALU_control = 3'b010;
            #1;

            check_outputs(A & B);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 006: Bitwise OR");
            A = 64'h1234567800000000;
            B = 64'h0000000087654321;
            ALU_control = 3'b011;
            #1;

            check_outputs(64'h1234567887654321);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 007: Bitwise XOR");
            A = 64'hAAAAAAAAAAAAAAAA;
            B = 64'hFFFFFFFFFFFFFFFF;
            ALU_control = 3'b100;
            #1;

            check_outputs(64'h5555555555555555);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 008: Bitwise NOT B");
            A = 64'hFFFFFFFFFFFFFFFF;
            B = 64'h0F0F0F0F0F0F0F0F;
            ALU_control = 3'b101;
            #1;

            check_outputs(64'hF0F0F0F0F0F0F0F0);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 009: Shift Left Logical (1 bit)");
            A = 64'h0000000000000001;
            B = 64'h0000000000000001;
            ALU_control = 3'b110;
            #1;

            check_outputs(64'h0000000000000002);

            $display("Testcase 010: Shift Left Logical (63 bits)");
            A = 64'h0000000000000001;
            B = 64'd63;
            ALU_control = 3'b110;
            #1;

            check_outputs(64'h8000000000000000);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 011: Shift Right Logical (1 bit)");
            A = 64'h8000000000000000;
            B = 64'h0000000000000001;
            ALU_control = 3'b111;
            #1;

            check_outputs(64'h4000000000000000);

            $display("Testcase 012: Shift Right Logical (Full clear)");
            A = 64'hFFFFFFFFFFFFFFFF;
            B = 64'd64;
            ALU_control = 3'b111;
            #1;

            check_outputs(64'h0000000000000000);
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
        input [63:0] expected_ALU_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ALU_result === (expected_ALU_result ^ ALU_result ^ expected_ALU_result)) begin
                $display("PASS");
                $display("  Outputs: ALU_result=%h",
                         ALU_result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALU_result=%h",
                         expected_ALU_result);
                $display("  Got:      ALU_result=%h",
                         ALU_result);
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
