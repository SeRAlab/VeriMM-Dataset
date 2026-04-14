`timescale 1ns/1ps

module ALU_32bit_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    reg [2:0] opcode;
    wire [31:0] result;
    wire zero_flag;

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
        .zero_flag(zero_flag)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Addition (Basic)", test_num);
        A = 32'd100;
        B = 32'd250;
        opcode = 3'b000;
        #1;

        check_outputs(32'd350, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Addition (Zero Result)", test_num);
        A = 32'hFFFFFFFF;
        B = 32'h00000001;
        opcode = 3'b000;
        #1;

        check_outputs(32'h00000000, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Subtraction (Basic)", test_num);
        A = 32'd500;
        B = 32'd150;
        opcode = 3'b001;
        #1;

        check_outputs(32'd350, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Subtraction (Zero Result)", test_num);
        A = 32'hABCDE123;
        B = 32'hABCDE123;
        opcode = 3'b001;
        #1;

        check_outputs(32'h00000000, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Subtraction (Negative Result)", test_num);
        A = 32'd10;
        B = 32'd20;
        opcode = 3'b001;

        #1;


        check_outputs(32'hFFFFFFF6, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Bitwise AND", test_num);
        A = 32'hF0F0F0F0;
        B = 32'hAAAA5555;
        opcode = 3'b010;
        #1;

        check_outputs(32'hA0A05050, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Bitwise OR", test_num);
        A = 32'hF0F0F0F0;
        B = 32'h0F0F0F0F;
        opcode = 3'b011;
        #1;

        check_outputs(32'hFFFFFFFF, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Bitwise XOR", test_num);
        A = 32'h12345678;
        B = 32'h87654321;
        opcode = 3'b100;
        #1;

        check_outputs(32'h95511559, 1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Bitwise XOR (Zero Result)", test_num);
        A = 32'h5555AAAA;
        B = 32'h5555AAAA;
        opcode = 3'b100;
        #1;

        check_outputs(32'h00000000, 1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: Bitwise AND (Zero Result)", test_num);
        A = 32'hAAAA_AAAA;
        B = 32'h5555_5555;
        opcode = 3'b010;
        #1;

        check_outputs(32'h00000000, 1'b1);
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
