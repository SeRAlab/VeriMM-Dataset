`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg [3:0] C;
    reg [3:0] D;
    reg [1:0] S;
    wire [3:0] out;

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
        .S(S),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 4'd15; B = 4'd10; C = 4'd5; D = 4'd0;
        S = 2'b00;
        #1;

        check_outputs(4'd15);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 4'd2; B = 4'd14; C = 4'd8; D = 4'd1;
        S = 2'b00;
        #1;

        check_outputs(4'd14);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 4'd1; B = 4'd3; C = 4'd12; D = 4'd7;
        S = 2'b01;
        #1;

        check_outputs(4'd12);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 4'd0; B = 4'd4; C = 4'd8; D = 4'd15;
        S = 2'b11;
        #1;

        check_outputs(4'd15);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 4'd7; B = 4'd7; C = 4'd7; D = 4'd7;
        S = 2'b00;
        #1;

        check_outputs(4'd7);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = 4'd10; B = 4'd10; C = 4'd2; D = 4'd1;
        S = 2'b00;
        #1;

        check_outputs(4'd10);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A = 4'd1; B = 4'd2; C = 4'd9; D = 4'd9;
        S = 2'b10;
        #1;

        check_outputs(4'd9);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A = 4'd0; B = 4'd0; C = 4'd0; D = 4'd0;
        S = 2'b00;
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        A = 4'd13; B = 4'd5; C = 4'd13; D = 4'd13;
        S = 2'b00;
        #1;

        check_outputs(4'd13);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        A = 4'hE; B = 4'hF; C = 4'hC; D = 4'hD;
        S = 2'b00;
        #1;

        check_outputs(4'hF);
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
        input [3:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
