`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg enable;
    reg [3:0] in;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .enable(enable),
        .in(in),
        .out(out)
    );
    task testcase001;

    begin
        enable = 0; in = 4'h0;
        $display("Testcase 001: Enable=0, In=0x0");
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        enable = 0; in = 4'hF;
        $display("Testcase 002: Enable=0, In=0xF");
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase003;

    begin
        enable = 1; in = 4'h0;
        $display("Testcase 003: Enable=1, In=0x0");
        #1;

        check_outputs(16'h0001);
    end
        endtask

    task testcase004;

    begin
        enable = 1; in = 4'h1;
        $display("Testcase 004: Enable=1, In=0x1");
        #1;

        check_outputs(16'h0002);
    end
        endtask

    task testcase005;

    begin
        enable = 1; in = 4'h2;
        $display("Testcase 005: Enable=1, In=0x2");
        #1;

        check_outputs(16'h0004);
    end
        endtask

    task testcase006;

    begin
        enable = 1; in = 4'h3;
        $display("Testcase 006: Enable=1, In=0x3");
        #1;

        check_outputs(16'h0008);
    end
        endtask

    task testcase007;

    begin
        enable = 1; in = 4'h4;
        $display("Testcase 007: Enable=1, In=0x4");
        #1;

        check_outputs(16'h0010);
    end
        endtask

    task testcase008;

    begin
        enable = 1; in = 4'h5;
        $display("Testcase 008: Enable=1, In=0x5");
        #1;

        check_outputs(16'h0020);
    end
        endtask

    task testcase009;

    begin
        enable = 1; in = 4'h6;
        $display("Testcase 009: Enable=1, In=0x6");
        #1;

        check_outputs(16'h0040);
    end
        endtask

    task testcase010;

    begin
        enable = 1; in = 4'h7;
        $display("Testcase 010: Enable=1, In=0x7");
        #1;

        check_outputs(16'h0080);
    end
        endtask

    task testcase011;

    begin
        enable = 1; in = 4'h8;
        $display("Testcase 011: Enable=1, In=0x8");
        #1;

        check_outputs(16'h0100);
    end
        endtask

    task testcase012;

    begin
        enable = 1; in = 4'h9;
        $display("Testcase 012: Enable=1, In=0x9");
        #1;

        check_outputs(16'h0200);
    end
        endtask

    task testcase013;

    begin
        enable = 1; in = 4'hA;
        $display("Testcase 013: Enable=1, In=0xA");
        #1;

        check_outputs(16'h0400);
    end
        endtask

    task testcase014;

    begin
        enable = 1; in = 4'hB;
        $display("Testcase 014: Enable=1, In=0xB");
        #1;

        check_outputs(16'h0800);
    end
        endtask

    task testcase015;

    begin
        enable = 1; in = 4'hC;
        $display("Testcase 015: Enable=1, In=0xC");
        #1;

        check_outputs(16'h1000);
    end
        endtask

    task testcase016;

    begin
        enable = 1; in = 4'hD;
        $display("Testcase 016: Enable=1, In=0xD");
        #1;

        check_outputs(16'h2000);
    end
        endtask

    task testcase017;

    begin
        enable = 1; in = 4'hE;
        $display("Testcase 017: Enable=1, In=0xE");
        #1;

        check_outputs(16'h4000);
    end
        endtask

    task testcase018;

    begin
        enable = 1; in = 4'hF;
        $display("Testcase 018: Enable=1, In=0xF");
        #1;

        check_outputs(16'h8000);
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
        testcase013();
        testcase014();
        testcase015();
        testcase016();
        testcase017();
        testcase018();
        
        
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
        input [15:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
