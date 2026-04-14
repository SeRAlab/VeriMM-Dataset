`timescale 1ns/1ps

module ALU_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    reg [2:0] opcode;
    wire Z;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ALU dut (
        .A(A),
        .B(B),
        .opcode(opcode),
        .Z(Z),
        .result(result)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: ADD - Positive Numbers", test_num);
        A = 32'd10;
        B = 32'd20;
        opcode = 3'b000;
        #1;

        check_outputs(1'b0, 32'd30);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: SUB - Result Zero", test_num);
        A = 32'd50;
        B = 32'd50;
        opcode = 3'b001;
        #1;

        check_outputs(1'b1, 32'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: AND - Bitwise Mask", test_num);
        A = 32'hF0F0FFFF;
        B = 32'h0F0F0000;
        opcode = 3'b010;
        #1;

        check_outputs(1'b1, 32'h00000000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: OR - Bitwise Merge", test_num);
        A = 32'hAAAA0000;
        B = 32'h00005555;
        opcode = 3'b011;
        #1;

        check_outputs(1'b0, 32'hAAAA5555);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: XOR - Identity", test_num);
        A = 32'h12345678;
        B = 32'h12345678;
        opcode = 3'b100;
        #1;

        check_outputs(1'b1, 32'h00000000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: SLT - A < B (Signed)", test_num);
        A = 32'hFFFFFFFF;
        B = 32'h00000001;
        opcode = 3'b101;
        #1;

        check_outputs(1'b0, 32'd1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %03d: SLT - A > B (Signed)", test_num);
        A = 32'h00000005;
        B = 32'hFFFFFFFB;
        opcode = 3'b101;
        #1;

        check_outputs(1'b1, 32'd0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %03d: NOR - Zero inputs", test_num);
        A = 32'h00000000;
        B = 32'h00000000;
        opcode = 3'b110;
        #1;

        check_outputs(1'b0, 32'hFFFFFFFF);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %03d: NAND - All ones", test_num);
        A = 32'hFFFFFFFF;
        B = 32'hFFFFFFFF;
        opcode = 3'b111;
        #1;

        check_outputs(1'b1, 32'h00000000);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %03d: ADD - Overflow wrap", test_num);
        A = 32'hFFFFFFFF;
        B = 32'h00000001;
        opcode = 3'b000;
        #1;

        check_outputs(1'b1, 32'h00000000);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        $display("Testcase %03d: SUB - Negative result", test_num);
        A = 32'd10;
        B = 32'd20;
        opcode = 3'b001;
        #1;

        check_outputs(1'b0, 32'hFFFFFFF6);
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
        input expected_Z;
        input [31:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Z === (expected_Z ^ Z ^ expected_Z) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: Z=%b, result=%h",
                         Z, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Z=%b, result=%h",
                         expected_Z, expected_result);
                $display("  Got:      Z=%b, result=%h",
                         Z, result);
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
