`timescale 1ns/1ps

module ALU_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] A;
    reg [63:0] B;
    reg [2:0] opcode;
    wire [63:0] result;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ALU dut (
        .A(A),
        .B(B),
        .opcode(opcode),
        .result(result),
        .valid(valid)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: ADD", test_num);
        A = 64'h1234567812345678;
        B = 64'h1111111111111111;
        opcode = 3'b000;
        #1;

        check_outputs(64'h2345678923456789, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: SUBTRACT", test_num);
        A = 64'hFFFFFFFFFFFFFFFF;
        B = 64'h0000000000000001;
        opcode = 3'b001;
        #1;

        check_outputs(64'hFFFFFFFFFFFFFFFE, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: AND", test_num);
        A = 64'hF0F0F0F0F0F0F0F0;
        B = 64'hCCCCCCCCCCCCCCCC;
        opcode = 3'b010;
        #1;

        check_outputs(64'hC0C0C0C0C0C0C0C0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: OR", test_num);
        A = 64'hF0F0F0F0F0F0F0F0;
        B = 64'hCCCCCCCCCCCCCCCC;
        opcode = 3'b011;
        #1;

        check_outputs(64'hFCFCFCFCFCFCFCFC, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: XOR", test_num);
        A = 64'hAAAAAAAAAAAAAAAA;
        B = 64'h5555555555555555;
        opcode = 3'b100;
        #1;

        check_outputs(64'hFFFFFFFFFFFFFFFF, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: NAND", test_num);
        A = 64'h00000000FFFFFFFF;
        B = 64'hFFFFFFFFFFFFFFFF;
        opcode = 3'b101;
        #1;

        check_outputs(64'hFFFFFFFF00000000, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: NOR", test_num);
        A = 64'h0000000000000000;
        B = 64'h0000000000000000;
        opcode = 3'b110;
        #1;

        check_outputs(64'hFFFFFFFFFFFFFFFF, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: XNOR", test_num);
        A = 64'hFEDCBA9876543210;
        B = 64'hFEDCBA9876543210;
        opcode = 3'b111;
        #1;

        check_outputs(64'hFFFFFFFFFFFFFFFF, 1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: SUBTRACT (Negative result)", test_num);
        A = 64'h0000000000000005;
        B = 64'h000000000000000A;
        opcode = 3'b001;
        #1;

        check_outputs(64'hFFFFFFFFFFFFFFFB, 1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: ADD (Overflow)", test_num);
        A = 64'hFFFFFFFFFFFFFFFF;
        B = 64'h0000000000000001;
        opcode = 3'b000;
        #1;

        check_outputs(64'h0000000000000000, 1'b1);
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
        input expected_valid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: result=%h, valid=%b",
                         result, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h, valid=%b",
                         expected_result, expected_valid);
                $display("  Got:      result=%h, valid=%b",
                         result, valid);
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
