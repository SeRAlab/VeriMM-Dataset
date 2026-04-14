`timescale 1ns/1ps

module array_multiplier_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    wire [7:0] P;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    array_multiplier dut (
        .A(A),
        .B(B),
        .P(P)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Zero Case (0 * 0)", test_num);
        A = 4'd0;
        B = 4'd0;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Multiplicand is Zero (12 * 0)", test_num);
        A = 4'd12;
        B = 4'd0;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Multiply by One (1 * 15)", test_num);
        A = 4'd1;
        B = 4'd15;
        #1;

        check_outputs(8'h0F);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Maximum Values (15 * 15)", test_num);
        A = 4'd15;
        B = 4'd15;
        #1;

        check_outputs(8'hE1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Powers of Two (4 * 8)", test_num);
        A = 4'd4;
        B = 4'd8;
        #1;

        check_outputs(8'h20);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Prime Numbers (7 * 11)", test_num);
        A = 4'd7;
        B = 4'd11;
        #1;

        check_outputs(8'h4D);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Alternating Bits (10 * 5)", test_num);
        A = 4'b1010;
        B = 4'b0101;
        #1;

        check_outputs(8'h32);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: High-Low Nibble Check (13 * 3)", test_num);
        A = 4'd13;
        B = 4'd3;
        #1;

        check_outputs(8'h27);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: Large Value times Small Value (14 * 2)", test_num);
        A = 4'd14;
        B = 4'd2;
        #1;

        check_outputs(8'h1C);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test %0d: Symmetric Case (9 * 9)", test_num);
        A = 4'd9;
        B = 4'd9;
        #1;

        check_outputs(8'h51);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("array_multiplier Testbench");
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
        input [7:0] expected_P;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_P === (expected_P ^ P ^ expected_P)) begin
                $display("PASS");
                $display("  Outputs: P=%h",
                         P);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: P=%h",
                         expected_P);
                $display("  Got:      P=%h",
                         P);
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
