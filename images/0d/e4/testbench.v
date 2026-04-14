`timescale 1ns/1ps

module ALU_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [3:0] ALU_op;
    reg [31:0] B;
    wire [31:0] ALU_out;
    wire ALU_zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ALU dut (
        .A(A),
        .ALU_op(ALU_op),
        .B(B),
        .ALU_out(ALU_out),
        .ALU_zero(ALU_zero)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition (5 + 3)", test_num);
            ALU_op = 4'b0000;
            A = 32'd5;
            B = 32'd3;
            #1;

            check_outputs(32'd8, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition (Overflow to Zero)", test_num);
            ALU_op = 4'b0000;
            A = 32'hFFFFFFFF;
            B = 32'h00000001;
            #1;

            check_outputs(32'h00000000, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction (10 - 4)", test_num);
            ALU_op = 4'b0001;
            A = 32'd10;
            B = 32'd4;
            #1;

            check_outputs(32'd6, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction (5 - 5)", test_num);
            ALU_op = 4'b0001;
            A = 32'd5;
            B = 32'd5;
            #1;

            check_outputs(32'h00000000, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise AND", test_num);
            ALU_op = 4'b0010;
            A = 32'hAAAA_AAAA;
            B = 32'h5555_5555;
            #1;

            check_outputs(32'h0000_0000, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise OR", test_num);
            ALU_op = 4'b0011;
            A = 32'hF0F0_F0F0;
            B = 32'h0F0F_0F0F;
            #1;

            check_outputs(32'hFFFF_FFFF, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise XOR", test_num);
            ALU_op = 4'b0100;
            A = 32'h1234_5678;
            B = 32'h1234_5678;
            #1;

            check_outputs(32'h0000_0000, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Left Shift (1 << 4)", test_num);
            ALU_op = 4'b0101;
            A = 32'h0000_0001;
            B = 32'd4;
            #1;

            check_outputs(32'h0000_0010, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Right Shift (0x80 >> 1)", test_num);
            ALU_op = 4'b0110;
            A = 32'h0000_0080;
            B = 32'd1;
            #1;

            check_outputs(32'h0000_0040, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: SLT (Signed: -1 < 1)", test_num);
            ALU_op = 4'b0111;
            A = 32'hFFFF_FFFF;
            B = 32'h0000_0001;
            #1;

            check_outputs(32'h0000_0001, 1'b0);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Test %0d: SLT (Signed: 1 < -1)", test_num);
            ALU_op = 4'b0111;
            A = 32'h0000_0001;
            B = 32'hFFFF_FFFF;
            #1;

            check_outputs(32'h0000_0000, 1'b1);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            $display("Test %0d: SLTU (Unsigned: -1 < 1)", test_num);
            ALU_op = 4'b1000;
            A = 32'hFFFF_FFFF;
            B = 32'h0000_0001;
            #1;

            check_outputs(32'h0000_0000, 1'b1);
        end
        endtask

    task testcase013;

        begin
            test_num = test_num + 1;
            $display("Test %0d: SLTU (Unsigned: 1 < 2)", test_num);
            ALU_op = 4'b1000;
            A = 32'h0000_0001;
            B = 32'h0000_0002;
            #1;

            check_outputs(32'h0000_0001, 1'b0);
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
        testcase013();
        
        
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
        input [31:0] expected_ALU_out;
        input expected_ALU_zero;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ALU_out === (expected_ALU_out ^ ALU_out ^ expected_ALU_out) &&
                expected_ALU_zero === (expected_ALU_zero ^ ALU_zero ^ expected_ALU_zero)) begin
                $display("PASS");
                $display("  Outputs: ALU_out=%h, ALU_zero=%b",
                         ALU_out, ALU_zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALU_out=%h, ALU_zero=%b",
                         expected_ALU_out, expected_ALU_zero);
                $display("  Got:      ALU_out=%h, ALU_zero=%b",
                         ALU_out, ALU_zero);
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
