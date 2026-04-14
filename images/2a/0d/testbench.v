`timescale 1ns/1ps

module ALU_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] A;
    reg [2:0] ALU_control;
    reg [63:0] B;
    wire [63:0] ALU_result;
    wire zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ALU dut (
        .A(A),
        .ALU_control(ALU_control),
        .B(B),
        .ALU_result(ALU_result),
        .zero(zero)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Addition (10 + 20)", test_num);
            A = 64'd10;
            B = 64'd20;
            ALU_control = 3'b000;
            #1;

            check_outputs(64'd30, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Addition Zero Result (0 + 0)", test_num);
            A = 64'd0;
            B = 64'd0;
            ALU_control = 3'b000;
            #1;

            check_outputs(64'd0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Subtraction (50 - 15)", test_num);
            A = 64'd50;
            B = 64'd15;
            ALU_control = 3'b001;
            #1;

            check_outputs(64'd35, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Subtraction Result Zero (100 - 100)", test_num);
            A = 64'd100;
            B = 64'd100;
            ALU_control = 3'b001;
            #1;

            check_outputs(64'd0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Bitwise AND", test_num);
            A = 64'hAAAA_AAAA_AAAA_AAAA;
            B = 64'hFFFF_0000_FFFF_0000;
            ALU_control = 3'b010;
            #1;

            check_outputs(64'hAAAA_0000_AAAA_0000, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Bitwise OR", test_num);
            A = 64'h1234_5678_0000_0000;
            B = 64'h0000_0000_8765_4321;
            ALU_control = 3'b011;
            #1;

            check_outputs(64'h1234_5678_8765_4321, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Bitwise XOR", test_num);
            A = 64'hFFFF_FFFF_FFFF_FFFF;
            B = 64'hAAAA_AAAA_AAAA_AAAA;
            ALU_control = 3'b100;
            #1;

            check_outputs(64'h5555_5555_5555_5555, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Shift Left (1 << 4)", test_num);
            A = 64'h0000_0000_0000_0001;
            B = 64'd4;
            ALU_control = 3'b101;
            #1;

            check_outputs(64'h0000_0000_0000_0010, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Shift Right (0x80...0 >> 1)", test_num);
            A = 64'h8000_0000_0000_0000;
            B = 64'd1;
            ALU_control = 3'b110;
            #1;

            check_outputs(64'h4000_0000_0000_0000, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: SLT (5 < 10)", test_num);
            A = 64'd5;
            B = 64'd10;
            ALU_control = 3'b111;
            #1;

            check_outputs(64'd1, 1'b0);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            $display("Test %0d: SLT (10 < 5)", test_num);
            A = 64'd10;
            B = 64'd5;
            ALU_control = 3'b111;
            #1;

            check_outputs(64'd0, 1'b1);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            $display("Test %0d: SLT Signed (-1 < 1)", test_num);
            A = 64'hFFFF_FFFF_FFFF_FFFF;
            B = 64'h0000_0000_0000_0001;
            ALU_control = 3'b111;

            #1;


            check_outputs(64'd1, 1'b0);
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
        input [63:0] expected_ALU_result;
        input expected_zero;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ALU_result === (expected_ALU_result ^ ALU_result ^ expected_ALU_result) &&
                expected_zero === (expected_zero ^ zero ^ expected_zero)) begin
                $display("PASS");
                $display("  Outputs: ALU_result=%h, zero=%b",
                         ALU_result, zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALU_result=%h, zero=%b",
                         expected_ALU_result, expected_zero);
                $display("  Got:      ALU_result=%h, zero=%b",
                         ALU_result, zero);
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
