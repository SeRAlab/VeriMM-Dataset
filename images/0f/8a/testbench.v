`timescale 1ns/1ps

module alu_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    reg [2:0] opcode;
    wire carry_out;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    alu dut (
        .A(A),
        .B(B),
        .opcode(opcode),
        .carry_out(carry_out),
        .result(result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: AND Operation", test_num);
            A = 32'hF0F0F0F0;
            B = 32'hAAAA_AAAA;
            opcode = 3'b000;

            #1;


            check_outputs(1'b0, 32'hA0A0A0A0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: OR Operation", test_num);
            A = 32'hF0F0F0F0;
            B = 32'h0F0F0F0F;
            opcode = 3'b001;

            #1;


            check_outputs(1'b0, 32'hFFFFFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: ADD Operation (No Carry)", test_num);
            A = 32'h00000010;
            B = 32'h00000020;
            opcode = 3'b010;

            #1;


            check_outputs(1'b0, 32'h00000030);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: ADD Operation (With Carry Out)", test_num);
            A = 32'hFFFFFFFF;
            B = 32'h00000001;
            opcode = 3'b010;

            #1;


            check_outputs(1'b1, 32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: SUBTRACT Operation (Positive Result)", test_num);
            A = 32'h00000050;
            B = 32'h00000010;
            opcode = 3'b011;

            #1;


            check_outputs(1'b0, 32'h00000040);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: SUBTRACT Operation (With Borrow/Underflow)", test_num);
            A = 32'h00000000;
            B = 32'h00000001;
            opcode = 3'b011;

            #1;


            check_outputs(1'b1, 32'hFFFFFFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: NOR Operation", test_num);
            A = 32'h00000000;
            B = 32'h00000000;
            opcode = 3'b100;

            #1;


            check_outputs(1'b0, 32'hFFFFFFFF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: NAND Operation", test_num);
            A = 32'hFFFFFFFF;
            B = 32'hFFFFFFFF;
            opcode = 3'b101;

            #1;


            check_outputs(1'b0, 32'h00000000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: XOR Operation", test_num);
            A = 32'h12345678;
            B = 32'h12345678;
            opcode = 3'b110;

            #1;


            check_outputs(1'b0, 32'h00000000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: XNOR Operation", test_num);
            A = 32'h12345678;
            B = 32'h12345678;
            opcode = 3'b111;

            #1;


            check_outputs(1'b0, 32'hFFFFFFFF);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Complex ADD and Carry", test_num);
            A = 32'h80000000;
            B = 32'h80000000;
            opcode = 3'b010;

            #1;


            check_outputs(1'b1, 32'h00000000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("alu Testbench");
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
        input expected_carry_out;
        input [31:0] expected_result;
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
