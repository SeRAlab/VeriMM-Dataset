`timescale 1ns/1ps

module concat_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg [7:0] C;
    reg [7:0] D;
    wire [15:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    concat_module dut (
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .Y(Y)
    );
    task testcase001;

    begin
        $display("Testcase 001: Simple sequential nibbles");
        test_num = 1;
        A = 8'h01;
        B = 8'h02;
        C = 8'h03;
        D = 8'h04;

        #1;


        check_outputs(16'h1234);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: All zeros");
        test_num = 2;
        A = 8'h00;
        B = 8'h00;
        C = 8'h00;
        D = 8'h00;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: Maximum nibble values (0xF)");
        test_num = 3;
        A = 8'h0F;
        B = 8'h0F;
        C = 8'h0F;
        D = 8'h0F;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Hex letter patterns");
        test_num = 4;
        A = 8'h0A;
        B = 8'h0B;
        C = 8'h0C;
        D = 8'h0D;
        #1;

        check_outputs(16'hABCD);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Alternating bit patterns (5 and A)");
        test_num = 5;
        A = 8'h05;
        B = 8'h0A;
        C = 8'h05;
        D = 8'h0A;
        #1;

        check_outputs(16'h5A5A);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: Verifying only lower nibbles are used");
        test_num = 6;
        A = 8'hF2;
        B = 8'hE4;
        C = 8'hD6;
        D = 8'hC8;
        #1;

        check_outputs(16'h2468);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("concat_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [15:0] expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%h",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%h",
                         expected_Y);
                $display("  Got:      Y=%h",
                         Y);
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
