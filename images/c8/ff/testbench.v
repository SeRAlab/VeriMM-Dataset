`timescale 1ns/1ps

module AND4_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    wire [3:0] Z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    AND4 dut (
        .A(A),
        .B(B),
        .Z(Z)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: All Zeros");
            A = 4'b0000;
            B = 4'b0000;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: All Ones");
            A = 4'b1111;
            B = 4'b1111;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Complementary Patterns (A & 5)");
            A = 4'b1010;
            B = 4'b0101;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Identity (A & F)");
            A = 4'b1011;
            B = 4'b1111;
            #1;

            check_outputs(4'b1011);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Zero Identity (A & 0)");
            A = 4'b1101;
            B = 4'b0000;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Bit Overlap (C & A)");
            A = 4'b1100;
            B = 4'b1010;
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case 007: Single Bit Set");
            A = 4'b0010;
            B = 4'b0010;
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case 008: High Nibble Logic");
            A = 4'b1110;
            B = 4'b0111;
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test Case 009: Alternating Bits (9 & D)");
            A = 4'b1001;
            B = 4'b1101;
            #1;

            check_outputs(4'b1001);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test Case 010: Boundary Check (7 & B)");
            A = 4'b0111;
            B = 4'b1011;
            #1;

            check_outputs(4'b0011);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("AND4 Testbench");
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
