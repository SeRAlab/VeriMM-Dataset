`timescale 1ns/1ps

module sixteen_bit_adder_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] A;
    reg [15:0] B;
    wire Carry;
    wire [15:0] Sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sixteen_bit_adder dut (
        .A(A),
        .B(B),
        .Carry(Carry),
        .Sum(Sum)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 16'h0000;
        B = 16'h0000;
        $display("Testcase %0d: 0 + 0", test_num);
        #1;

        check_outputs(1'b0, 16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 16'h1234;
        B = 16'h1111;
        $display("Testcase %0d: Simple Addition (No Carry Out)", test_num);
        #1;

        check_outputs(1'b0, 16'h2345);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 16'hFFFF;
        B = 16'h0000;
        $display("Testcase %0d: Max Input + Zero", test_num);
        #1;

        check_outputs(1'b0, 16'hFFFF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 16'hFFFF;
        B = 16'h0001;
        $display("Testcase %0d: Edge Case Overflow (Sum=0, Carry=1)", test_num);
        #1;

        check_outputs(1'b1, 16'h0000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 16'hFFFF;
        B = 16'hFFFF;
        $display("Testcase %0d: Max possible values (FFFF + FFFF)", test_num);
        #1;

        check_outputs(1'b1, 16'hFFFE);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = 16'hAAAA;
        B = 16'h5555;
        $display("Testcase %0d: Complementary Bits (All Ones result)", test_num);
        #1;

        check_outputs(1'b0, 16'hFFFF);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A = 16'h00FF;
        B = 16'h0001;
        $display("Testcase %0d: Internal carry propagation (00FF + 0001)", test_num);
        #1;

        check_outputs(1'b0, 16'h0100);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A = 16'h8000;
        B = 16'h8000;
        $display("Testcase %0d: MSB addition with carry out", test_num);
        #1;

        check_outputs(1'b1, 16'h0000);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        A = 16'hCCCC;
        B = 16'h3333;
        $display("Testcase %0d: Alternating bit patterns", test_num);
        #1;

        check_outputs(1'b0, 16'hFFFF);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        A = 16'hA000;
        B = 16'h7000;
        $display("Testcase %0d: Arbitrary values with carry out", test_num);
        #1;

        check_outputs(1'b1, 16'h1000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sixteen_bit_adder Testbench");
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
        input expected_Carry;
        input [15:0] expected_Sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Carry === (expected_Carry ^ Carry ^ expected_Carry) &&
                expected_Sum === (expected_Sum ^ Sum ^ expected_Sum)) begin
                $display("PASS");
                $display("  Outputs: Carry=%b, Sum=%h",
                         Carry, Sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Carry=%b, Sum=%h",
                         expected_Carry, expected_Sum);
                $display("  Got:      Carry=%b, Sum=%h",
                         Carry, Sum);
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
