`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] A;
    reg [4:0] B;
    reg [3:0] S;
    wire Cout;
    wire [4:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .S(S),
        .Cout(Cout),
        .Y(Y)
    );
    task testcase001;

    begin
        test_num = 1;
        S = 4'h0; A = 5'h05; B = 5'h03;
        #1;

        check_outputs(1'b0, 5'h08);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        S = 4'h0; A = 5'h0D; B = 5'h04;
        #1;

        check_outputs(1'b1, 5'h11);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        S = 4'h1; A = 5'h0A; B = 5'h04;
        #1;

        check_outputs(1'b0, 5'h06);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        S = 4'h2; A = 5'h05; B = 5'h00;
        #1;

        check_outputs(1'b0, 5'h0A);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        S = 4'h3; A = 5'h0C; B = 5'h00;
        #1;

        check_outputs(1'b0, 5'h06);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        S = 4'h4; A = 5'h0C; B = 5'h0A;
        #1;

        check_outputs(1'b0, 5'h08);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        S = 4'h5; A = 5'h0C; B = 5'h0A;
        #1;

        check_outputs(1'b0, 5'h0E);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        S = 4'h6; A = 5'h0C; B = 5'h0A;
        #1;

        check_outputs(1'b0, 5'h06);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        S = 4'h7; A = 5'h05; B = 5'h00;
        #1;

        check_outputs(1'b0, 5'h0A);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        S = 4'h8; A = 5'h0F; B = 5'h05;
        #1;

        check_outputs(1'b0, 5'h01);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        S = 4'h9; A = 5'h02; B = 5'h08;
        #1;

        check_outputs(1'b0, 5'h01);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        S = 4'hA; A = 5'h07; B = 5'h07;
        #1;

        check_outputs(1'b0, 5'h01);
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
        testcase012();
        
        
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
        input [4:0] expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Cout === (expected_Cout ^ Cout ^ expected_Cout) &&
                expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Cout=%b, Y=%h",
                         Cout, Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Cout=%b, Y=%h",
                         expected_Cout, expected_Y);
                $display("  Got:      Cout=%b, Y=%h",
                         Cout, Y);
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
