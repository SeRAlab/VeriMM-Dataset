`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] ra1;
    reg [4:0] ra2;
    reg [4:0] wa3;
    reg [31:0] wd3;
    reg we3;
    wire [31:0] rd1;
    wire [31:0] rd2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ra1(ra1),
        .ra2(ra2),
        .wa3(wa3),
        .wd3(wd3),
        .we3(we3),
        .rd1(rd1),
        .rd2(rd2)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase 001: Register 0 Read-Only Zero Check");

        we3 = 0; wa3 = 0; wd3 = 0; ra1 = 0; ra2 = 0;
        #5;

        we3 = 1; wa3 = 0; wd3 = 32'hFFFFFFFF;
        #5;

        ra1 = 0; ra2 = 0;
        #5;
        #1;

        check_outputs(32'h0, 32'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase 002: Basic Write and Read (Register 1)");
        we3 = 0; wa3 = 0; wd3 = 0; ra1 = 0; ra2 = 0;
        #5;

        we3 = 1; wa3 = 5'd1; wd3 = 32'hDEADBEEF;
        #5;

        we3 = 0; ra1 = 5'd1; ra2 = 5'd0;
        #5;
        #1;

        check_outputs(32'hDEADBEEF, 32'h0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase 003: Simultaneous Dual Port Read");
        we3 = 0; wa3 = 0; wd3 = 0; ra1 = 0; ra2 = 0;
        #5;

        we3 = 1; wa3 = 5'd10; wd3 = 32'h11112222;
        #5;

        we3 = 1; wa3 = 5'd20; wd3 = 32'hAAAA5555;
        #5;

        we3 = 0; ra1 = 5'd10; ra2 = 5'd20;
        #5;
        #1;

        check_outputs(32'h11112222, 32'hAAAA5555);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase 004: Write Enable (we3) Logic Check");
        we3 = 0; wa3 = 0; wd3 = 0; ra1 = 0; ra2 = 0;
        #5;

        we3 = 0; wa3 = 5'd5; wd3 = 32'hCAFEBABE;
        #5;

        ra1 = 5'd5; ra2 = 0;
        #5;
        #1;

        check_outputs(32'h0, 32'h0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase 005: Boundary Register 31 Check");
        we3 = 0; wa3 = 0; wd3 = 0; ra1 = 0; ra2 = 0;
        #5;

        we3 = 1; wa3 = 5'd31; wd3 = 32'h87654321;
        #5;

        we3 = 0; ra1 = 5'd31; ra2 = 5'd31;
        #5;
        #1;

        check_outputs(32'h87654321, 32'h87654321);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase 006: Overwrite and Data Isolation");
        we3 = 0; wa3 = 0; wd3 = 0; ra1 = 0; ra2 = 0;
        #5;

        we3 = 1; wa3 = 5'd7; wd3 = 32'h00001111;
        #5;

        we3 = 1; wa3 = 5'd7; wd3 = 32'hFFFF0000;
        #5;

        we3 = 1; wa3 = 5'd8; wd3 = 32'hABCDEF99;
        #5;

        we3 = 0; ra1 = 5'd7; ra2 = 5'd8;
        #5;
        #1;

        check_outputs(32'hFFFF0000, 32'hABCDEF99);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase 007: Single Register Dual Read");
        we3 = 0; wa3 = 0; wd3 = 0; ra1 = 0; ra2 = 0;
        #5;
        we3 = 1; wa3 = 5'd15; wd3 = 32'h55AA55AA;
        #5;
        we3 = 0; ra1 = 5'd15; ra2 = 5'd15;
        #5;
        #1;

        check_outputs(32'h55AA55AA, 32'h55AA55AA);
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
        input [31:0] expected_rd1;
        input [31:0] expected_rd2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_rd1 === (expected_rd1 ^ rd1 ^ expected_rd1) &&
                expected_rd2 === (expected_rd2 ^ rd2 ^ expected_rd2)) begin
                $display("PASS");
                $display("  Outputs: rd1=%h, rd2=%h",
                         rd1, rd2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rd1=%h, rd2=%h",
                         expected_rd1, expected_rd2);
                $display("  Got:      rd1=%h, rd2=%h",
                         rd1, rd2);
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
