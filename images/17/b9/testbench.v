`timescale 1ns/1ps

module ALU_64bit_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] A;
    reg [63:0] B;
    reg [2:0] opcode;
    wire carry_out;
    wire [63:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ALU_64bit dut (
        .A(A),
        .B(B),
        .opcode(opcode),
        .carry_out(carry_out),
        .result(result)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition (Simple)", test_num);
        A = 64'd100;
        B = 64'd150;
        opcode = 3'b000;
        #1;

        check_outputs(1'b0, 64'd250);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition (Carry Out)", test_num);
        A = 64'hFFFF_FFFF_FFFF_FFFF;
        B = 64'h0000_0000_0000_0001;
        opcode = 3'b000;
        #1;

        check_outputs(1'b1, 64'h0000_0000_0000_0000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Subtraction (Simple)", test_num);
        A = 64'd500;
        B = 64'd200;
        opcode = 3'b001;
        #1;

        check_outputs(1'b0, 64'd300);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Subtraction (Borrow)", test_num);
        A = 64'h0000_0000_0000_0000;
        B = 64'h0000_0000_0000_0001;
        opcode = 3'b001;
        #1;

        check_outputs(1'b1, 64'hFFFF_FFFF_FFFF_FFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bitwise AND", test_num);
        A = 64'hAAAA_AAAA_AAAA_AAAA;
        B = 64'hFFFF_FFFF_0000_0000;
        opcode = 3'b010;
        #1;

        check_outputs(1'b0, 64'hAAAA_AAAA_0000_0000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bitwise OR", test_num);
        A = 64'h1234_0000_0000_0000;
        B = 64'h0000_0000_0000_5678;
        opcode = 3'b011;
        #1;

        check_outputs(1'b0, 64'h1234_0000_0000_5678);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bitwise XOR", test_num);
        A = 64'hF0F0_F0F0_F0F0_F0F0;
        B = 64'hFFFF_FFFF_FFFF_FFFF;
        opcode = 3'b100;
        #1;

        check_outputs(1'b0, 64'h0F0F_0F0F_0F0F_0F0F);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Shift Left", test_num);
        A = 64'h0000_0000_0000_0001;
        B = 64'd4;
        opcode = 3'b101;
        #1;

        check_outputs(1'b0, 64'h0000_0000_0000_0010);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Shift Right", test_num);
        A = 64'h8000_0000_0000_0000;
        B = 64'd1;
        opcode = 3'b110;
        #1;

        check_outputs(1'b0, 64'h4000_0000_0000_0000);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: SLT (True)", test_num);
        A = 64'hFFFF_FFFF_FFFF_FFFE;
        B = 64'h0000_0000_0000_0001;
        opcode = 3'b111;
        #1;

        check_outputs(1'b0, 64'h0000_0000_0000_0001);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("Test %0d: SLT (False)", test_num);
        A = 64'h0000_0000_0000_0005;
        B = 64'hFFFF_FFFF_FFFF_FFFB;
        opcode = 3'b111;
        #1;

        check_outputs(1'b0, 64'h0000_0000_0000_0000);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Shift Left Max", test_num);
        A = 64'hFFFF_FFFF_FFFF_FFFF;
        B = 64'd63;
        opcode = 3'b101;
        #1;

        check_outputs(1'b0, 64'h8000_0000_0000_0000);
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
        input expected_carry_out;
        input [63:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_carry_out === (expected_carry_out ^ carry_out ^ expected_carry_out) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: carry_out=%b, result=%h",
                         carry_out, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: carry_out=%b, result=%h",
                         expected_carry_out, expected_result);
                $display("  Got:      carry_out=%b, result=%h",
                         carry_out, result);
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
