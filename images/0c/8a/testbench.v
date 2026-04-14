`timescale 1ns/1ps

module adder_64bit_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] A;
    reg [63:0] B;
    wire COUT;
    wire [63:0] SUM;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adder_64bit dut (
        .A(A),
        .B(B),
        .COUT(COUT),
        .SUM(SUM)
    );
    task testcase001;

        begin
            $display("Testcase 001: Zero + Zero");
            A = 64'h0;
            B = 64'h0;
            #1;

            check_outputs(1'b0, 64'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Minimum values (1 + 1)");
            A = 64'h1;
            B = 64'h1;
            #1;

            check_outputs(1'b0, 64'h2);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Identity property (A + 0)");
            A = 64'hFEDCBA9876543210;
            B = 64'h0;
            #1;

            check_outputs(1'b0, 64'hFEDCBA9876543210);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Maximum value minus one + 1 (No overflow yet)");
            A = 64'hFFFFFFFFFFFFFFFE;
            B = 64'h1;
            #1;

            check_outputs(1'b0, 64'hFFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Maximum value + 1 (Overflow trigger)");
            A = 64'hFFFFFFFFFFFFFFFF;
            B = 64'h1;
            #1;

            check_outputs(1'b1, 64'h0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: High bit addition (Carry-out check)");
            A = 64'h8000000000000000;
            B = 64'h8000000000000000;
            #1;

            check_outputs(1'b1, 64'h0);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Max + Max");
            A = 64'hFFFFFFFFFFFFFFFF;
            B = 64'hFFFFFFFFFFFFFFFF;
            #1;

            check_outputs(1'b1, 64'hFFFFFFFFFFFFFFFE);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Bit pattern AAAA + 5555");
            A = 64'hAAAAAAAAAAAAAAAA;
            B = 64'h5555555555555555;
            #1;

            check_outputs(1'b0, 64'hFFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: Carry propagation across all nibbles");
            A = 64'hEEEEEEEEEEEEEEEE;
            B = 64'h1111111111111112;
            #1;

            check_outputs(1'b1, 64'h0);
        end
        endtask

    task testcase010;

        begin
            $display("Testcase 010: Random data addition");
            A = 64'h123456789ABCDEF0;
            B = 64'h0FEDCBA987654321;
            #1;

            check_outputs(1'b0, 64'h2222222222222211);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adder_64bit Testbench");
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
        input expected_COUT;
        input [63:0] expected_SUM;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_COUT === (expected_COUT ^ COUT ^ expected_COUT) &&
                expected_SUM === (expected_SUM ^ SUM ^ expected_SUM)) begin
                $display("PASS");
                $display("  Outputs: COUT=%b, SUM=%h",
                         COUT, SUM);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: COUT=%b, SUM=%h",
                         expected_COUT, expected_SUM);
                $display("  Got:      COUT=%b, SUM=%h",
                         COUT, SUM);
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
