`timescale 1ns/1ps

module ALU_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg [2:0] op_code;
    wire [7:0] Result;
    wire zero_flag;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ALU dut (
        .A(A),
        .B(B),
        .op_code(op_code),
        .Result(Result),
        .zero_flag(zero_flag)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Addition (0x12 + 0x34)", test_num);
        A = 8'h12;
        B = 8'h34;
        op_code = 3'b000;
        #1;

        check_outputs(8'h46, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Addition with Zero Result (0xFF + 0x01)", test_num);
        A = 8'hFF;
        B = 8'h01;
        op_code = 3'b000;
        #1;

        check_outputs(8'h00, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Subtraction (0x20 - 0x05)", test_num);
        A = 8'h20;
        B = 8'h05;
        op_code = 3'b001;
        #1;

        check_outputs(8'h1B, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Subtraction resulting in Zero (0x10 - 0x10)", test_num);
        A = 8'h10;
        B = 8'h10;
        op_code = 3'b001;
        #1;

        check_outputs(8'h00, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Subtraction with Underflow (0x00 - 0x01)", test_num);
        A = 8'h00;
        B = 8'h01;
        op_code = 3'b001;
        #1;

        check_outputs(8'hFF, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Bitwise AND (0xAA & 0xF0)", test_num);
        A = 8'hAA;
        B = 8'hF0;
        op_code = 3'b010;
        #1;

        check_outputs(8'hA0, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Bitwise AND resulting in Zero (0x55 & 0xAA)", test_num);
        A = 8'h55;
        B = 8'hAA;
        op_code = 3'b010;
        #1;

        check_outputs(8'h00, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Bitwise OR (0x0F | 0xF0)", test_num);
        A = 8'h0F;
        B = 8'hF0;
        op_code = 3'b011;
        #1;

        check_outputs(8'hFF, 1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Bitwise OR resulting in Zero (0x00 | 0x00)", test_num);
        A = 8'h00;
        B = 8'h00;
        op_code = 3'b011;
        #1;

        check_outputs(8'h00, 1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Bitwise XOR (0xFF ^ 0x0F)", test_num);
        A = 8'hFF;
        B = 8'h0F;
        op_code = 3'b100;
        #1;

        check_outputs(8'hF0, 1'b0);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Bitwise XOR resulting in Zero (0xCC ^ 0xCC)", test_num);
        A = 8'hCC;
        B = 8'hCC;
        op_code = 3'b100;
        #1;

        check_outputs(8'h00, 1'b1);
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
        input [7:0] expected_Result;
        input expected_zero_flag;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Result === (expected_Result ^ Result ^ expected_Result) &&
                expected_zero_flag === (expected_zero_flag ^ zero_flag ^ expected_zero_flag)) begin
                $display("PASS");
                $display("  Outputs: Result=%h, zero_flag=%b",
                         Result, zero_flag);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Result=%h, zero_flag=%b",
                         expected_Result, expected_zero_flag);
                $display("  Got:      Result=%h, zero_flag=%b",
                         Result, zero_flag);
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
