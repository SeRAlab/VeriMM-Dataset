`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg [3:0] C;
    reg [3:0] D;
    reg M;
    reg [1:0] select;
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
        .D(D),
        .M(M),
        .select(select),
        .S(S),
        .V(V)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 4'd3; B = 4'd2; C = 4'd0; D = 4'd0; select = 2'b00; M = 1'b0;
        $display("Test %0d: A + B (3 + 2)", test_num);
        #1;

        check_outputs(4'd5, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 4'd0; B = 4'd5; C = 4'd0; D = 4'd0; select = 2'b01; M = 1'b0;
        $display("Test %0d: B + B (5 + 5)", test_num);
        #1;

        check_outputs(4'b1010, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 4'd0; B = 4'b1101; C = 4'b1010; D = 4'd0; select = 2'b10; M = 1'b0;
        $display("Test %0d: C + B (-6 + -3)", test_num);
        #1;

        check_outputs(4'b0111, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 4'd0; B = 4'b1100; C = 4'd0; D = 4'b0100; select = 2'b11; M = 1'b0;
        $display("Test %0d: D + B (4 + -4)", test_num);
        #1;

        check_outputs(4'b0000, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 4'd7; B = 4'd3; C = 4'd0; D = 4'd0; select = 2'b00; M = 1'b1;
        $display("Test %0d: A - B (7 - 3)", test_num);
        #1;

        check_outputs(4'd4, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = 4'd0; B = 4'd6; C = 4'd0; D = 4'd0; select = 2'b01; M = 1'b1;
        $display("Test %0d: B - B (6 - 6)", test_num);
        #1;

        check_outputs(4'd0, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A = 4'd0; B = 4'd4; C = 4'b1011; D = 4'd0; select = 2'b10; M = 1'b1;
        $display("Test %0d: C - B (-5 - 4)", test_num);
        #1;

        check_outputs(4'b0111, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A = 4'd0; B = 4'b1011; C = 4'd0; D = 4'b0100; select = 2'b11; M = 1'b1;
        $display("Test %0d: D - B (4 - -5)", test_num);
        #1;

        check_outputs(4'b1001, 1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        A = 4'b0111; B = 4'b0000; select = 2'b00; M = 1'b0;
        $display("Test %0d: Max positive boundary check", test_num);
        #1;

        check_outputs(4'b0111, 1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        A = 4'b1000; B = 4'b0000; select = 2'b00; M = 1'b1;
        $display("Test %0d: Min negative boundary check", test_num);
        #1;

        check_outputs(4'b1000, 1'b0);
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
