`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    wire [8:0] O;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .O(O)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            A = 8'h00; B = 8'h00;
            $display("Testcase %0d: All Zeros (A=%h, B=%h)", test_num, A, B);
            #1;

            check_outputs(calculate_expected(A, B));
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            A = 8'hFF; B = 8'hFF;
            $display("Testcase %0d: All Ones (A=%h, B=%h)", test_num, A, B);
            #1;

            check_outputs(calculate_expected(A, B));
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            A = 8'hAA; B = 8'h55;
            $display("Testcase %0d: Alternating Bits (A=%h, B=%h)", test_num, A, B);
            #1;

            check_outputs(calculate_expected(A, B));
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            A = 8'h00; B = 8'h0F;
            $display("Testcase %0d: Check Lower Bits B (A=%h, B=%h)", test_num, A, B);
            #1;

            check_outputs(calculate_expected(A, B));
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            A = 8'h10; B = 8'h20;
            $display("Testcase %0d: Upper Nibble Addition No Carry (A=%h, B=%h)", test_num, A, B);
            #1;

            check_outputs(calculate_expected(A, B));
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            A = 8'hF0; B = 8'h10;
            $display("Testcase %0d: Upper Nibble Addition Wrap (A=%h, B=%h)", test_num, A, B);
            #1;

            check_outputs(calculate_expected(A, B));
        end
        endtask

    task testcase007;

        integer i;
        begin
            for (i = 0; i < 8; i = i + 1) begin
                test_num = test_num + 1;
                A = (1 << i); B = 8'h00;
                $display("Testcase %0d: Walking A (Bit %0d)", test_num, i);
                #1;

                check_outputs(calculate_expected(A, B));
            end
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
        input [8:0] expected_O;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_O === (expected_O ^ O ^ expected_O)) begin
                $display("PASS");
                $display("  Outputs: O=%h",
                         O);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: O=%h",
                         expected_O);
                $display("  Got:      O=%h",
                         O);
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
