`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] A;
    reg [1:0] B;
    reg Cin;
    wire Cout;
    wire [1:0] S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .Cin(Cin),
        .Cout(Cout),
        .S(S)
    );
    task testcase001;

        begin
            test_num = 1;
            A = 2'b00; B = 2'b00; Cin = 1'b0;
            $display("Test %0d: A=00, B=00, Cin=0 (Sum=0)", test_num);
            #1;

            check_outputs(1'b0, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            A = 2'b00; B = 2'b00; Cin = 1'b1;
            $display("Test %0d: A=00, B=00, Cin=1 (Sum=1)", test_num);
            #1;

            check_outputs(1'b0, 2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            A = 2'b01; B = 2'b10; Cin = 1'b0;
            $display("Test %0d: A=01, B=10, Cin=0 (Sum=3)", test_num);
            #1;

            check_outputs(1'b0, 2'b11);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            A = 2'b10; B = 2'b10; Cin = 1'b0;
            $display("Test %0d: A=10, B=10, Cin=0 (Sum=4, Overflow)", test_num);
            #1;

            check_outputs(1'b1, 2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            A = 2'b11; B = 2'b01; Cin = 1'b1;
            $display("Test %0d: A=11, B=01, Cin=1 (Sum=5, Overflow)", test_num);
            #1;

            check_outputs(1'b1, 2'b01);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            A = 2'b11; B = 2'b11; Cin = 1'b0;
            $display("Test %0d: A=11, B=11, Cin=0 (Sum=6, Overflow)", test_num);
            #1;

            check_outputs(1'b1, 2'b10);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            A = 2'b11; B = 2'b11; Cin = 1'b1;
            $display("Test %0d: A=11, B=11, Cin=1 (Sum=7, Overflow)", test_num);
            #1;

            check_outputs(1'b1, 2'b11);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            A = 2'b01; B = 2'b01; Cin = 1'b1;
            $display("Test %0d: A=01, B=01, Cin=1 (Sum=3)", test_num);
            #1;

            check_outputs(1'b0, 2'b11);
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
        input expected_Cout;
        input [1:0] expected_S;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Cout === (expected_Cout ^ Cout ^ expected_Cout) &&
                expected_S === (expected_S ^ S ^ expected_S)) begin
                $display("PASS");
                $display("  Outputs: Cout=%b, S=%h",
                         Cout, S);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Cout=%b, S=%h",
                         expected_Cout, expected_S);
                $display("  Got:      Cout=%b, S=%h",
                         Cout, S);
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
