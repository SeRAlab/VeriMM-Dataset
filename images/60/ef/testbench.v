`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A_in;
    reg [31:0] B_in;
    reg Cin;
    wire Carry;
    wire Negative;
    wire [31:0] Output;
    wire Overflow;
    wire Zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A_in(A_in),
        .B_in(B_in),
        .Cin(Cin),
        .Carry(Carry),
        .Negative(Negative),
        .Output(Output),
        .Overflow(Overflow),
        .Zero(Zero)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Addition (5 + 10)", test_num);
            A_in = 32'd5;
            B_in = 32'd10;
            Cin = 1'b0;

            #1;


            check_outputs(1'b0, 1'b0, 32'd15, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero Result (0 + 0)", test_num);
            A_in = 32'h00000000;
            B_in = 32'h00000000;
            Cin = 1'b0;

            #1;


            check_outputs(1'b0, 1'b0, 32'h00000000, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Carry Out (Max + 1)", test_num);
            A_in = 32'hFFFFFFFF;
            B_in = 32'h00000001;
            Cin = 1'b0;

            #1;


            check_outputs(1'b1, 1'b0, 32'h00000000, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition with Carry-In", test_num);
            A_in = 32'h0000000A;
            B_in = 32'h00000005;
            Cin = 1'b1;

            #1;


            check_outputs(1'b0, 1'b0, 32'h00000010, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Signed Overflow (Pos + Pos = Neg)", test_num);
            A_in = 32'h7FFFFFFF;
            B_in = 32'h00000001;
            Cin = 1'b0;

            #1;


            check_outputs(1'b0, 1'b1, 32'h80000000, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Signed Overflow (Neg + Neg = Pos)", test_num);
            A_in = 32'h80000000;
            B_in = 32'h80000000;
            Cin = 1'b0;


            #1;



            check_outputs(1'b1, 1'b0, 32'h00000000, 1'b1, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Negative Result No Overflow", test_num);
            A_in = 32'hFFFFFFFF;
            B_in = 32'hFFFFFFFF;
            Cin = 1'b0;


            #1;



            check_outputs(1'b1, 1'b1, 32'hFFFFFFFE, 1'b0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Negative Result with Carry-In", test_num);
            A_in = 32'hFFFFFFFE;
            B_in = 32'h00000000;
            Cin = 1'b1;


            #1;



            check_outputs(1'b0, 1'b1, 32'hFFFFFFFF, 1'b0, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Positive Result from Negative inputs", test_num);
            A_in = 32'hFFFFFFFF;
            B_in = 32'h00000002;
            Cin = 1'b0;


            #1;



            check_outputs(1'b1, 1'b0, 32'h00000001, 1'b0, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Overflow check", test_num);
            A_in = 32'h40000000;
            B_in = 32'h40000000;
            Cin = 1'b0;


            #1;



            check_outputs(1'b0, 1'b1, 32'h80000000, 1'b1, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input expected_Negative;
        input [31:0] expected_Output;
        input expected_Overflow;
        input expected_Zero;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Carry === (expected_Carry ^ Carry ^ expected_Carry) &&
                expected_Negative === (expected_Negative ^ Negative ^ expected_Negative) &&
                expected_Output === (expected_Output ^ Output ^ expected_Output) &&
                expected_Overflow === (expected_Overflow ^ Overflow ^ expected_Overflow) &&
                expected_Zero === (expected_Zero ^ Zero ^ expected_Zero)) begin
                $display("PASS");
                $display("  Outputs: Carry=%b, Negative=%b, Output=%h, Overflow=%b, Zero=%b",
                         Carry, Negative, Output, Overflow, Zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Carry=%b, Negative=%b, Output=%h, Overflow=%b, Zero=%b",
                         expected_Carry, expected_Negative, expected_Output, expected_Overflow, expected_Zero);
                $display("  Got:      Carry=%b, Negative=%b, Output=%h, Overflow=%b, Zero=%b",
                         Carry, Negative, Output, Overflow, Zero);
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
