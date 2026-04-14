`timescale 1ns/1ps

module carry_save_adder_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg [3:0] C;
    wire [3:0] C_out;
    wire [3:0] S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    carry_save_adder dut (
        .A(A),
        .B(B),
        .C(C),
        .C_out(C_out),
        .S(S)
    );
    task testcase001;

    begin
        $display("Testcase 001: All Zeros");
        test_num = test_num + 1;
        A = 4'h0; B = 4'h0; C = 4'h0;

        #1;


        check_outputs(4'h0, 4'h0);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: Single Bit Addition (Bit 0)");
        test_num = test_num + 1;
        A = 4'h1; B = 4'h1; C = 4'h1;


        #1;



        check_outputs(4'h1, 4'h1);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: Pass Through (A only)");
        test_num = test_num + 1;
        A = 4'hF; B = 4'h0; C = 4'h0;

        #1;


        check_outputs(4'h0, 4'hF);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Maximum Values");
        test_num = test_num + 1;
        A = 4'hF; B = 4'hF; C = 4'hF;

        #1;


        check_outputs(4'hF, 4'hF);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Mixed Inputs 1");
        test_num = test_num + 1;
        A = 4'h5; B = 4'hA; C = 4'h3;



        #1;




        check_outputs(4'h3, 4'hC);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: Mixed Inputs 2 (Complementary)");
        test_num = test_num + 1;
        A = 4'hA; B = 4'h5; C = 4'hF;



        #1;




        check_outputs(4'hF, 4'h0);
    end
        endtask

    task testcase007;

    begin
        $display("Testcase 007: Mixed Inputs 3 (Carry overflow)");
        test_num = test_num + 1;
        A = 4'hC; B = 4'hA; C = 4'h9;



        #1;




        check_outputs(4'h8, 4'hF);
    end
        endtask

    task testcase008;

    begin
        $display("Testcase 008: Alternating Bits");
        test_num = test_num + 1;
        A = 4'h6; B = 4'h9; C = 4'h6;



        #1;




        check_outputs(4'h6, 4'h9);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("carry_save_adder Testbench");
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
        input [3:0] expected_C_out;
        input [3:0] expected_S;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C_out === (expected_C_out ^ C_out ^ expected_C_out) &&
                expected_S === (expected_S ^ S ^ expected_S)) begin
                $display("PASS");
                $display("  Outputs: C_out=%h, S=%h",
                         C_out, S);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C_out=%h, S=%h",
                         expected_C_out, expected_S);
                $display("  Got:      C_out=%h, S=%h",
                         C_out, S);
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
