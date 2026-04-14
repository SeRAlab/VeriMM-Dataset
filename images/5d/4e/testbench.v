`timescale 1ns/1ps

module alu_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg [1:0] ctrl;
    wire carry_out;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    alu dut (
        .A(A),
        .B(B),
        .ctrl(ctrl),
        .carry_out(carry_out),
        .result(result)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition - Basic", test_num);
        A = 8'd15; B = 8'd30; ctrl = 2'b00;
        #1;

        check_outputs(1'b0, 8'd45);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition - Carry Out", test_num);
        A = 8'hFF; B = 8'h01; ctrl = 2'b00;
        #1;

        check_outputs(1'b1, 8'h00);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Subtraction - Positive Result", test_num);
        A = 8'd100; B = 8'd40; ctrl = 2'b01;
        #1;

        check_outputs(1'b0, 8'd60);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Subtraction - Negative Result (Borrow)", test_num);
        A = 8'd10; B = 8'd20; ctrl = 2'b01;
        #1;

        check_outputs(1'b1, 8'hF6);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bitwise AND", test_num);
        A = 8'b1010_1010; B = 8'b1111_0000; ctrl = 2'b10;
        #1;

        check_outputs(1'b0, 8'b1010_0000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bitwise OR", test_num);
        A = 8'b1010_1010; B = 8'b0101_0101; ctrl = 2'b11;
        #1;

        check_outputs(1'b0, 8'b1111_1111);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition - Zeros", test_num);
        A = 8'h00; B = 8'h00; ctrl = 2'b00;
        #1;

        check_outputs(1'b0, 8'h00);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Subtraction - Zero Result", test_num);
        A = 8'hAA; B = 8'hAA; ctrl = 2'b01;
        #1;

        check_outputs(1'b0, 8'h00);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bitwise AND - Zero Result", test_num);
        A = 8'hF0; B = 8'h0F; ctrl = 2'b10;
        #1;

        check_outputs(1'b0, 8'h00);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition - Large Carry", test_num);
        A = 8'hFF; B = 8'hFF; ctrl = 2'b00;
        #1;

        check_outputs(1'b1, 8'hFE);
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
