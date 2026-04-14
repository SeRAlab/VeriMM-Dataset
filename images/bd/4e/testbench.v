`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg C;
    wire [3:0] S;
    wire V;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .S(S),
        .V(V)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 4'b0010; B = 4'b0011; C = 1'b0;
        $display("Test %0d: Addition 2 + 3", test_num);
        #1;

        check_outputs(4'b0101, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 4'b0111; B = 4'b0001; C = 1'b0;
        $display("Test %0d: Addition 7 + 1 (Overflow)", test_num);
        #1;

        check_outputs(4'b1000, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 4'b1111; B = 4'b1111; C = 1'b0;
        $display("Test %0d: Addition -1 + -1", test_num);
        #1;

        check_outputs(4'b1110, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 4'b1000; B = 4'b1111; C = 1'b0;
        $display("Test %0d: Addition -8 + -1 (Overflow)", test_num);
        #1;

        check_outputs(4'b0111, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 4'b0100; B = 4'b0001; C = 1'b1;
        $display("Test %0d: Subtraction 4 - 1", test_num);
        #1;

        check_outputs(4'b0011, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = 4'b0111; B = 4'b1111; C = 1'b1;
        $display("Test %0d: Subtraction 7 - (-1) (Overflow)", test_num);
        #1;

        check_outputs(4'b1000, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A = 4'b1000; B = 4'b0001; C = 1'b1;
        $display("Test %0d: Subtraction -8 - 1 (Overflow)", test_num);
        #1;

        check_outputs(4'b0111, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A = 4'b0000; B = 4'b0000; C = 1'b1;
        $display("Test %0d: Subtraction 0 - 0", test_num);
        #1;

        check_outputs(4'b0000, 1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        A = 4'b1000; B = 4'b1000; C = 1'b1;
        $display("Test %0d: Subtraction -8 - (-8)", test_num);
        #1;

        check_outputs(4'b0000, 1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        A = 4'b0111; B = 4'b1000; C = 1'b0;
        $display("Test %0d: Addition 7 + (-8)", test_num);
        #1;

        check_outputs(4'b1111, 1'b0);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        A = 4'b0000; B = 4'b1000; C = 1'b1;
        $display("Test %0d: Subtraction 0 - (-8) (Overflow)", test_num);
        #1;

        check_outputs(4'b1000, 1'b1);
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
        testcase011();
        
        
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
        input [3:0] expected_S;
        input expected_V;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_S === (expected_S ^ S ^ expected_S) &&
                expected_V === (expected_V ^ V ^ expected_V)) begin
                $display("PASS");
                $display("  Outputs: S=%h, V=%b",
                         S, V);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: S=%h, V=%b",
                         expected_S, expected_V);
                $display("  Got:      S=%h, V=%b",
                         S, V);
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
