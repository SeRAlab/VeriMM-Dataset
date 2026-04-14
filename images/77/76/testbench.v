`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] A;
    reg [2:0] B;
    reg C_In;
    wire C_Out;
    wire [2:0] Out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C_In(C_In),
        .C_Out(C_Out),
        .Out(Out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All inputs zero (0 + 0 + 0)", test_num);
            A = 3'b000;
            B = 3'b000;
            C_In = 1'b0;
            #1;

            check_outputs(1'b0, 3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic addition no carry (1 + 2 + 0)", test_num);
            A = 3'b001;
            B = 3'b010;
            C_In = 1'b0;
            #1;

            check_outputs(1'b0, 3'b011);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Max sum without carry-out (3 + 4 + 0)", test_num);
            A = 3'b011;
            B = 3'b100;
            C_In = 1'b0;
            #1;

            check_outputs(1'b0, 3'b111);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition resulting in exact carry-out (7 + 1 + 0)", test_num);
            A = 3'b111;
            B = 3'b001;
            C_In = 1'b0;
            #1;

            check_outputs(1'b1, 3'b000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Carry-in only (0 + 0 + 1)", test_num);
            A = 3'b000;
            B = 3'b000;
            C_In = 1'b1;
            #1;

            check_outputs(1'b0, 3'b001);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum possible sum (7 + 7 + 1)", test_num);
            A = 3'b111;
            B = 3'b111;
            C_In = 1'b1;
            #1;

            check_outputs(1'b1, 3'b111);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Adding with carry-in and internal carry (3 + 4 + 1)", test_num);
            A = 3'b011;
            B = 3'b100;
            C_In = 1'b1;
            #1;

            check_outputs(1'b1, 3'b000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating bits (5 + 2 + 0)", test_num);
            A = 3'b101;
            B = 3'b010;
            C_In = 1'b0;
            #1;

            check_outputs(1'b0, 3'b111);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary carry-out (4 + 4 + 0)", test_num);
            A = 3'b100;
            B = 3'b100;
            C_In = 1'b0;
            #1;

            check_outputs(1'b1, 3'b000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Random values (6 + 3 + 1)", test_num);
            A = 3'b110;
            B = 3'b011;
            C_In = 1'b1;
            #1;

            check_outputs(1'b1, 3'b010);
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
        input expected_C_Out;
        input [2:0] expected_Out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C_Out === (expected_C_Out ^ C_Out ^ expected_C_Out) &&
                expected_Out === (expected_Out ^ Out ^ expected_Out)) begin
                $display("PASS");
                $display("  Outputs: C_Out=%b, Out=%h",
                         C_Out, Out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C_Out=%b, Out=%h",
                         expected_C_Out, expected_Out);
                $display("  Got:      C_Out=%b, Out=%h",
                         C_Out, Out);
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
