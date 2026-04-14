`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] one;
    reg one_A;
    reg one_B;
    reg [15:0] two;
    reg two_A;
    reg two_B;
    wire forwarda;
    wire forwardb;
    wire [15:0] outA;
    wire [15:0] outB;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .one(one),
        .one_A(one_A),
        .one_B(one_B),
        .two(two),
        .two_A(two_A),
        .two_B(two_B),
        .forwarda(forwarda),
        .forwardb(forwardb),
        .outA(outA),
        .outB(outB)
    );
    task testcase001;

    begin
        $display("Testcase 001: All signals idle");
        one = 16'hAAAA; two = 16'h5555;
        one_A = 0; one_B = 0; two_A = 0; two_B = 0;
        #1;

        check_outputs(1'b0, 1'b0, 16'h0000, 16'h0000);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: one_A active");
        one = 16'h1111; two = 16'h2222;
        one_A = 1; one_B = 0; two_A = 0; two_B = 0;
        #1;

        check_outputs(1'b1, 1'b0, 16'h1111, 16'h0000);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: two_A active");
        one = 16'h1111; two = 16'h2222;
        one_A = 0; one_B = 0; two_A = 1; two_B = 0;
        #1;

        check_outputs(1'b1, 1'b0, 16'h2222, 16'h0000);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Priority Conflict A (one_A & two_A)");
        one = 16'h1111; two = 16'h2222;
        one_A = 1; one_B = 0; two_A = 1; two_B = 0;
        #1;

        check_outputs(1'b1, 1'b0, 16'h2222, 16'h0000);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: one_B active");
        one = 16'hCCCC; two = 16'hDDDD;
        one_A = 0; one_B = 1; two_A = 0; two_B = 0;
        #1;

        check_outputs(1'b0, 1'b1, 16'h0000, 16'hCCCC);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: two_B active");
        one = 16'hCCCC; two = 16'hDDDD;
        one_A = 0; one_B = 0; two_A = 0; two_B = 1;
        #1;

        check_outputs(1'b0, 1'b1, 16'h0000, 16'hDDDD);
    end
        endtask

    task testcase007;

    begin
        $display("Testcase 007: Priority Conflict B (one_B & two_B)");
        one = 16'hCCCC; two = 16'hDDDD;
        one_A = 0; one_B = 1; two_A = 0; two_B = 1;
        #1;

        check_outputs(1'b0, 1'b1, 16'h0000, 16'hDDDD);
    end
        endtask

    task testcase008;

    begin
        $display("Testcase 008: Diagonal Forwarding (one_A, two_B)");
        one = 16'h1234; two = 16'h5678;
        one_A = 1; one_B = 0; two_A = 0; two_B = 1;
        #1;

        check_outputs(1'b1, 1'b1, 16'h1234, 16'h5678);
    end
        endtask

    task testcase009;

    begin
        $display("Testcase 009: Diagonal Forwarding (two_A, one_B)");
        one = 16'h1234; two = 16'h5678;
        one_A = 0; one_B = 1; two_A = 1; two_B = 0;
        #1;

        check_outputs(1'b1, 1'b1, 16'h5678, 16'h1234);
    end
        endtask

    task testcase010;

    begin
        $display("Testcase 010: Selection of same source 'one' for both A and B");
        one = 16'hF0F0; two = 16'h0F0F;
        one_A = 1; one_B = 1; two_A = 0; two_B = 0;
        #1;

        check_outputs(1'b1, 1'b1, 16'hF0F0, 16'hF0F0);
    end
        endtask

    task testcase011;

    begin
        $display("Testcase 011: Selection of same source 'two' for both A and B");
        one = 16'hF0F0; two = 16'h0F0F;
        one_A = 0; one_B = 0; two_A = 1; two_B = 1;
        #1;

        check_outputs(1'b1, 1'b1, 16'h0F0F, 16'h0F0F);
    end
        endtask

    task testcase012;

    begin
        $display("Testcase 012: All control signals high");
        one = 16'h1212; two = 16'h3434;
        one_A = 1; one_B = 1; two_A = 1; two_B = 1;
        #1;

        check_outputs(1'b1, 1'b1, 16'h3434, 16'h3434);
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
        input expected_forwarda;
        input expected_forwardb;
        input [15:0] expected_outA;
        input [15:0] expected_outB;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_forwarda === (expected_forwarda ^ forwarda ^ expected_forwarda) &&
                expected_forwardb === (expected_forwardb ^ forwardb ^ expected_forwardb) &&
                expected_outA === (expected_outA ^ outA ^ expected_outA) &&
                expected_outB === (expected_outB ^ outB ^ expected_outB)) begin
                $display("PASS");
                $display("  Outputs: forwarda=%b, forwardb=%b, outA=%h, outB=%h",
                         forwarda, forwardb, outA, outB);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: forwarda=%b, forwardb=%b, outA=%h, outB=%h",
                         expected_forwarda, expected_forwardb, expected_outA, expected_outB);
                $display("  Got:      forwarda=%b, forwardb=%b, outA=%h, outB=%h",
                         forwarda, forwardb, outA, outB);
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
