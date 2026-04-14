`timescale 1ns/1ps

module ripple_carry_adder_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg Cin;
    wire [4:0] Sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ripple_carry_adder dut (
        .A(A),
        .B(B),
        .Cin(Cin),
        .Sum(Sum)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: All Zeros", test_num);
            A = 4'b0000;
            B = 4'b0000;
            Cin = 1'b0;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Maximum A and B, No Cin", test_num);
            A = 4'b1111;
            B = 4'b1111;
            Cin = 1'b0;
            #1;

            check_outputs(5'b11110);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Maximum A and B with Cin", test_num);
            A = 4'b1111;
            B = 4'b1111;
            Cin = 1'b1;
            #1;

            check_outputs(5'b11111);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Single Bit Addition (Carry Generation)", test_num);
            A = 4'b1000;
            B = 4'b1000;
            Cin = 1'b0;
            #1;

            check_outputs(5'b10000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Alternating Bits", test_num);
            A = 4'b1010;
            B = 4'b0101;
            Cin = 1'b0;
            #1;

            check_outputs(5'b01111);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Alternating Bits with Cin", test_num);
            A = 4'b1010;
            B = 4'b0101;
            Cin = 1'b1;
            #1;

            check_outputs(5'b10000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Low Nibble Carry", test_num);
            A = 4'b0111;
            B = 4'b0001;
            Cin = 1'b0;
            #1;

            check_outputs(5'b01000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Only Cin set", test_num);
            A = 4'b0000;
            B = 4'b0000;
            Cin = 1'b1;
            #1;

            check_outputs(5'b00001);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test Case %0d: Arbitrary Values", test_num);
            A = 4'b0011;
            B = 4'b0110;
            Cin = 1'b0;
            #1;

            check_outputs(5'b01001);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test Case %0d: Overflow to 5th Bit", test_num);
            A = 4'b1100;
            B = 4'b0100;
            Cin = 1'b0;
            #1;

            check_outputs(5'b10000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ripple_carry_adder Testbench");
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
        input [4:0] expected_Sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Sum === (expected_Sum ^ Sum ^ expected_Sum)) begin
                $display("PASS");
                $display("  Outputs: Sum=%h",
                         Sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Sum=%h",
                         expected_Sum);
                $display("  Got:      Sum=%h",
                         Sum);
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
