`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    wire [3:0] Z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .Z(Z)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 4'd2; B = 4'd3;
        $display("Testcase %0d: A=%d, B=%d (Sum=5, <=9)", test_num, A, B);
        #1;

        check_outputs(4'd5);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 4'd4; B = 4'd5;
        $display("Testcase %0d: A=%d, B=%d (Sum=9, <=9)", test_num, A, B);
        #1;

        check_outputs(4'd9);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 4'd5; B = 4'd5;
        $display("Testcase %0d: A=%d, B=%d (Sum=10, >9, Modulo 10 = 0)", test_num, A, B);
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 4'd8; B = 4'd4;
        $display("Testcase %0d: A=%d, B=%d (Sum=12, >9, Modulo 10 = 2)", test_num, A, B);
        #1;

        check_outputs(4'd2);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 4'd9; B = 4'd9;
        $display("Testcase %0d: A=%d, B=%d (Sum=18, >9, Modulo 10 = 8)", test_num, A, B);
        #1;

        check_outputs(4'd8);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = 4'hF; B = 4'h0;
        $display("Testcase %0d: A=%d, B=%d (Sum=15, >9, Modulo 10 = 5)", test_num, A, B);
        #1;

        check_outputs(4'd5);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A = 4'hF; B = 4'hF;
        $display("Testcase %0d: A=%d, B=%d (Sum=30, >9, Modulo 10 = 0)", test_num, A, B);
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A = 4'd0; B = 4'd0;
        $display("Testcase %0d: A=%d, B=%d (Sum=0, <=9)", test_num, A, B);
        #1;

        check_outputs(4'd0);
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
        input [3:0] expected_Z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Z === (expected_Z ^ Z ^ expected_Z)) begin
                $display("PASS");
                $display("  Outputs: Z=%h",
                         Z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Z=%h",
                         expected_Z);
                $display("  Got:      Z=%h",
                         Z);
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
