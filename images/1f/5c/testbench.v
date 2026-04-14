`timescale 1ns/1ps

module ALU_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg [1:0] op;
    wire carry_out;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ALU dut (
        .a(a),
        .b(b),
        .op(op),
        .carry_out(carry_out),
        .result(result)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Addition (Simple)", test_num);
        a = 8'h10; b = 8'h05; op = 2'b00;
        #1;

        check_outputs(1'b0, 8'h15);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Addition (With Carry Out)", test_num);
        a = 8'hFF; b = 8'h01; op = 2'b00;
        #1;

        check_outputs(1'b1, 8'h00);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Subtraction (Simple)", test_num);
        a = 8'h20; b = 8'h10; op = 2'b01;
        #1;

        check_outputs(1'b0, 8'h10);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Subtraction (With Borrow)", test_num);
        a = 8'h00; b = 8'h01; op = 2'b01;
        #1;

        check_outputs(1'b1, 8'hFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Bitwise AND", test_num);
        a = 8'hAA; b = 8'hF0; op = 2'b10;
        #1;

        check_outputs(1'b0, 8'hA0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Bitwise OR", test_num);
        a = 8'h55; b = 8'h0F; op = 2'b11;
        #1;

        check_outputs(1'b0, 8'h5F);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Addition (Zero Result)", test_num);
        a = 8'h00; b = 8'h00; op = 2'b00;
        #1;

        check_outputs(1'b0, 8'h00);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Subtraction (Result Zero)", test_num);
        a = 8'h88; b = 8'h88; op = 2'b01;
        #1;

        check_outputs(1'b0, 8'h00);
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
