`timescale 1ns/1ps

module ALU_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [2:0] ALU_op;
    reg [7:0] B;
    wire carry_out;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ALU dut (
        .A(A),
        .ALU_op(ALU_op),
        .B(B),
        .carry_out(carry_out),
        .result(result)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: ADD - Basic", test_num);
        A = 8'h12;
        B = 8'h34;
        ALU_op = 3'b000;
        #1;

        check_outputs(1'b0, 8'h46);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: ADD - Carry Out", test_num);
        A = 8'hFF;
        B = 8'h02;
        ALU_op = 3'b000;
        #1;

        check_outputs(1'b1, 8'h01);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: SUBTRACT - Basic", test_num);
        A = 8'h20;
        B = 8'h10;
        ALU_op = 3'b001;
        #1;

        check_outputs(1'b0, 8'h10);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: SUBTRACT - Borrow", test_num);
        A = 8'h05;
        B = 8'h06;
        ALU_op = 3'b001;
        #1;

        check_outputs(1'b1, 8'hFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: AND", test_num);
        A = 8'hAA;
        B = 8'hF0;
        ALU_op = 3'b010;
        #1;

        check_outputs(1'b0, 8'hA0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: OR", test_num);
        A = 8'h55;
        B = 8'h0F;
        ALU_op = 3'b011;
        #1;

        check_outputs(1'b0, 8'h5F);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: XOR", test_num);
        A = 8'hFF;
        B = 8'hAA;
        ALU_op = 3'b100;
        #1;

        check_outputs(1'b0, 8'h55);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: NOT (Input A)", test_num);
        A = 8'h0F;
        B = 8'hFF;
        ALU_op = 3'b101;
        #1;

        check_outputs(1'b0, 8'hF0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: NAND", test_num);
        A = 8'hFF;
        B = 8'h01;
        ALU_op = 3'b110;
        #1;

        check_outputs(1'b0, 8'hFE);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: NOR", test_num);
        A = 8'h00;
        B = 8'h01;
        ALU_op = 3'b111;
        #1;

        check_outputs(1'b0, 8'hFE);
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
        input expected_carry_out;
        input [7:0] expected_result;
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
