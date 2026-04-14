`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a;
    reg [15:0] b;
    wire [15:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .y(y)
    );
    task testcase001;

    begin
        $display("Testcase 001: All zeros XOR");
        a = 16'h0000;
        b = 16'h0000;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: All ones XOR (Self)");
        a = 16'hFFFF;
        b = 16'hFFFF;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: All ones XOR Zero");
        a = 16'hFFFF;
        b = 16'h0000;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Alternating bit patterns (0101 ^ 1010)");
        a = 16'h5555;
        b = 16'hAAAA;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Arbitrary hex values 1");
        a = 16'h1234;
        b = 16'h4321;
        #1;

        check_outputs(16'h1234 ^ 16'h4321);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: Arbitrary hex values 2");
        a = 16'hABCD;
        b = 16'hDCBA;
        #1;

        check_outputs(16'hABCD ^ 16'hDCBA);
    end
        endtask

    task testcase007;

    begin
        $display("Testcase 007: Walking bit pattern");
        a = 16'h0001;
        b = 16'h8000;
        #1;

        check_outputs(16'h8001);
    end
        endtask

    task testcase008;

    begin
        $display("Testcase 008: Half and half patterns");
        a = 16'hFF00;
        b = 16'h00FF;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase009;

    begin
        $display("Testcase 009: Complementary pattern");
        a = 16'hC33C;
        b = 16'h3CC3;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase010;

    begin
        $display("Testcase 010: Identity check");
        a = 16'hDEAD;
        b = 16'h0000;
        #1;

        check_outputs(16'hDEAD);
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
        input [15:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
