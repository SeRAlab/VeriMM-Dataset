`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] A;
    reg [3:0] BS;
    reg S;
    wire [15:0] F;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .BS(BS),
        .S(S),
        .F(F)
    );
    task testcase001;

    begin
        $display("Testcase 001: Inserting 1s into an all-zero vector (Bits 0-3)");
        A = 16'h0000;
        S = 1'b1;

        BS = 4'd0; #1;
 check_outputs(16'h0001);
        BS = 4'd1; #1;
 check_outputs(16'h0002);
        BS = 4'd2; #1;
 check_outputs(16'h0004);
        BS = 4'd3; #1;
 check_outputs(16'h0008);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: Inserting 1s into an all-zero vector (Bits 4-7)");
        A = 16'h0000;
        S = 1'b1;

        BS = 4'd4; #1;
 check_outputs(16'h0010);
        BS = 4'd5; #1;
 check_outputs(16'h0020);
        BS = 4'd6; #1;
 check_outputs(16'h0040);
        BS = 4'd7; #1;
 check_outputs(16'h0080);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: Inserting 1s into an all-zero vector (Bits 8-11)");
        A = 16'h0000;
        S = 1'b1;

        BS = 4'd8;  #1;
  check_outputs(16'h0100);
        BS = 4'd9;  #1;
  check_outputs(16'h0200);
        BS = 4'd10; #1;
 check_outputs(16'h0400);
        BS = 4'd11; #1;
 check_outputs(16'h0800);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Inserting 1s into an all-zero vector (Bits 12-15)");
        A = 16'h0000;
        S = 1'b1;

        BS = 4'd12; #1;
 check_outputs(16'h1000);
        BS = 4'd13; #1;
 check_outputs(16'h2000);
        BS = 4'd14; #1;
 check_outputs(16'h4000);
        BS = 4'd15; #1;
 check_outputs(16'h8000);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Clearing bits (S=0) in an all-ones vector (Nibble 0)");
        A = 16'hFFFF;
        S = 1'b0;

        BS = 4'd0; #1;
 check_outputs(16'hFFFE);
        BS = 4'd1; #1;
 check_outputs(16'hFFFD);
        BS = 4'd2; #1;
 check_outputs(16'hFFFB);
        BS = 4'd3; #1;
 check_outputs(16'hFFF7);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: Clearing bits (S=0) in an all-ones vector (Nibble 3)");
        A = 16'hFFFF;
        S = 1'b0;

        BS = 4'd12; #1;
 check_outputs(16'hEFFF);
        BS = 4'd13; #1;
 check_outputs(16'hDFFF);
        BS = 4'd14; #1;
 check_outputs(16'hBFFF);
        BS = 4'd15; #1;
 check_outputs(16'h7FFF);
    end
        endtask

    task testcase007;

    begin
        $display("Testcase 007: Pattern check with alternating bits");
        A = 16'hAAAA;
        S = 1'b1;
        BS = 4'd0;  #1;
  check_outputs(16'hAAAB);
        BS = 4'd1;  #1;
  check_outputs(16'hAAAA);

        A = 16'h5555;
        S = 1'b0;
        BS = 4'd0;  #1;
  check_outputs(16'h5554);
        BS = 4'd1;  #1;
  check_outputs(16'h5555);
    end
        endtask

    task testcase008;

    begin
        $display("Testcase 008: Verifying specific bit position 8");
        A = 16'hF0F0;
        S = 1'b1;
        BS = 4'd8;  #1;
  check_outputs(16'hF1F0);
        S = 1'b0;
        BS = 4'd8;  #1;
  check_outputs(16'hF0F0);

        A = 16'h0F0F;
        S = 1'b0;
        BS = 4'd3;  #1;
  check_outputs(16'h0F07);
        S = 1'b1;
        BS = 4'd3;  #1;
  check_outputs(16'h0F0F);
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
        input [15:0] expected_F;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_F === (expected_F ^ F ^ expected_F)) begin
                $display("PASS");
                $display("  Outputs: F=%h",
                         F);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: F=%h",
                         expected_F);
                $display("  Got:      F=%h",
                         F);
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
