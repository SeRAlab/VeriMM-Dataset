`timescale 1ns/1ps

module alu_32bit_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg [1:0] control;
    wire [31:0] result;
    wire zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    alu_32bit dut (
        .a(a),
        .b(b),
        .control(control),
        .result(result),
        .zero(zero)
    );
    task testcase001;

    begin
        test_num = 1;
        a = 32'd100;
        b = 32'd250;
        control = 2'b00;
        $display("Test %0d: Addition (100 + 250)", test_num);
        #1;

        check_outputs(32'd350, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        a = 32'hFFFF_FFFF;
        b = 32'h0000_0001;
        control = 2'b00;
        $display("Test %0d: Addition with Overflow (0xFFFFFFFF + 1)", test_num);
        #1;

        check_outputs(32'h0000_0000, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        a = 32'd500;
        b = 32'd150;
        control = 2'b01;
        $display("Test %0d: Subtraction (500 - 150)", test_num);
        #1;

        check_outputs(32'd350, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        a = 32'hABCD_1234;
        b = 32'hABCD_1234;
        control = 2'b01;
        $display("Test %0d: Subtraction Resulting in Zero", test_num);
        #1;

        check_outputs(32'h0000_0000, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        a = 32'hF0F0_AAAA;
        b = 32'h0F0F_AAAA;
        control = 2'b10;
        $display("Test %0d: Bitwise AND", test_num);
        #1;

        check_outputs(32'h0000_AAAA, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        a = 32'hFFFF_0000;
        b = 32'h0000_FFFF;
        control = 2'b10;
        $display("Test %0d: Bitwise AND Zero Result", test_num);
        #1;

        check_outputs(32'h0000_0000, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        a = 32'h1234_0000;
        b = 32'h0000_5678;
        control = 2'b11;
        $display("Test %0d: Bitwise OR", test_num);
        #1;

        check_outputs(32'h1234_5678, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        a = 32'h0000_0000;
        b = 32'h0000_0000;
        control = 2'b11;
        $display("Test %0d: Bitwise OR Zero Result", test_num);
        #1;

        check_outputs(32'h0000_0000, 1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("alu_32bit Testbench");
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
        input [31:0] expected_result;
        input expected_zero;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result) &&
                expected_zero === (expected_zero ^ zero ^ expected_zero)) begin
                $display("PASS");
                $display("  Outputs: result=%h, zero=%b",
                         result, zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h, zero=%b",
                         expected_result, expected_zero);
                $display("  Got:      result=%h, zero=%b",
                         result, zero);
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
