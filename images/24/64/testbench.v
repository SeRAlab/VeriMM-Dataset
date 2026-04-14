`timescale 1ns/1ps

module ALU16_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] A;
    reg [15:0] B;
    reg [3:0] opcode;
    wire [15:0] result;
    wire zero_flag;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ALU16 dut (
        .A(A),
        .B(B),
        .opcode(opcode),
        .result(result),
        .zero_flag(zero_flag)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: ADD 10 + 20", test_num);
            A = 16'd10;
            B = 16'd20;
            opcode = 4'b0000;
            #1;

            check_outputs(16'd30, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: ADD FFFF + 1 (Wrap-around to Zero)", test_num);
            A = 16'hFFFF;
            B = 16'h0001;
            opcode = 4'b0000;
            #1;

            check_outputs(16'h0000, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: SUB 50 - 20", test_num);
            A = 16'd50;
            B = 16'd20;
            opcode = 4'b0001;
            #1;

            check_outputs(16'd30, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: SUB 100 - 100 (Zero Flag)", test_num);
            A = 16'd100;
            B = 16'd100;
            opcode = 4'b0001;
            #1;

            check_outputs(16'h0000, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: SUB 0 - 1 (Wrap-around)", test_num);
            A = 16'h0000;
            B = 16'h0001;
            opcode = 4'b0001;
            #1;

            check_outputs(16'hFFFF, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: AND F0F0 & AAAA", test_num);
            A = 16'hF0F0;
            B = 16'hAAAA;
            opcode = 4'b0010;
            #1;

            check_outputs(16'hA0A0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: AND FFFF & 0000 (Zero Flag)", test_num);
            A = 16'hFFFF;
            B = 16'h0000;
            opcode = 4'b0010;
            #1;

            check_outputs(16'h0000, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: OR 1234 | 5678", test_num);
            A = 16'h1234;
            B = 16'h5678;
            opcode = 4'b0011;
            #1;

            check_outputs(16'h567C, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: OR FFFF | 0000", test_num);
            A = 16'hFFFF;
            B = 16'h0000;
            opcode = 4'b0011;
            #1;

            check_outputs(16'hFFFF, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: OR 0000 | 0000 (Zero Flag)", test_num);
            A = 16'h0000;
            B = 16'h0000;
            opcode = 4'b0011;
            #1;

            check_outputs(16'h0000, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ALU16 Testbench");
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
        input [15:0] expected_result;
        input expected_zero_flag;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result) &&
                expected_zero_flag === (expected_zero_flag ^ zero_flag ^ expected_zero_flag)) begin
                $display("PASS");
                $display("  Outputs: result=%h, zero_flag=%b",
                         result, zero_flag);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h, zero_flag=%b",
                         expected_result, expected_zero_flag);
                $display("  Got:      result=%h, zero_flag=%b",
                         result, zero_flag);
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
