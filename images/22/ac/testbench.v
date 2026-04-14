`timescale 1ns/1ps

module multiplier_2bit_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] A;
    reg [1:0] B;
    wire [3:0] P;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    multiplier_2bit dut (
        .A(A),
        .B(B),
        .P(P)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 2'd0; B = 2'd0;
        $display("Test 001: A=0, B=0 (Zero Case)");
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 2'd0; B = 2'd3;
        $display("Test 002: A=0, B=3 (Zero Property)");
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 2'd3; B = 2'd0;
        $display("Test 003: A=3, B=0 (Zero Property)");
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 2'd1; B = 2'd1;
        $display("Test 004: A=1, B=1 (Identity)");
        #1;

        check_outputs(4'd1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 2'd1; B = 2'd2;
        $display("Test 005: A=1, B=2 (Identity)");
        #1;

        check_outputs(4'd2);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = 2'd3; B = 2'd1;
        $display("Test 006: A=3, B=1 (Identity)");
        #1;

        check_outputs(4'd3);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A = 2'd2; B = 2'd2;
        $display("Test 007: A=2, B=2");
        #1;

        check_outputs(4'd4);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A = 2'd2; B = 2'd3;
        $display("Test 008: A=2, B=3");
        #1;

        check_outputs(4'd6);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        A = 2'd3; B = 2'd2;
        $display("Test 009: A=3, B=2");
        #1;

        check_outputs(4'd6);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        A = 2'd3; B = 2'd3;
        $display("Test 010: A=3, B=3 (Max Case)");
        #1;

        check_outputs(4'd9);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("multiplier_2bit Testbench");
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
        input [3:0] expected_P;
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
