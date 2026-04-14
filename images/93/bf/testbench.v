`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] bin;
    wire [6:0] hex;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bin(bin),
        .hex(hex)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: bin = 4'h0");
        bin = 4'h0;
        #1;

        check_outputs(7'h3F);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: bin = 4'h1");
        bin = 4'h1;
        #1;

        check_outputs(7'h06);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: bin = 4'h2");
        bin = 4'h2;
        #1;

        check_outputs(7'h5B);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: bin = 4'h3");
        bin = 4'h3;
        #1;

        check_outputs(7'h4F);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: bin = 4'h4");
        bin = 4'h4;
        #1;

        check_outputs(7'h66);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: bin = 4'h5");
        bin = 4'h5;
        #1;

        check_outputs(7'h6D);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case 007: bin = 4'h6");
        bin = 4'h6;
        #1;

        check_outputs(7'h7D);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case 008: bin = 4'h7");
        bin = 4'h7;
        #1;

        check_outputs(7'h07);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case 009: bin = 4'h8");
        bin = 4'h8;
        #1;

        check_outputs(7'h7F);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case 010: bin = 4'h9");
        bin = 4'h9;
        #1;

        check_outputs(7'h6F);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        $display("Test Case 011: bin = 4'hA");
        bin = 4'hA;
        #1;

        check_outputs(7'h77);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        $display("Test Case 012: bin = 4'hB");
        bin = 4'hB;
        #1;

        check_outputs(7'h7C);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        $display("Test Case 013: bin = 4'hC");
        bin = 4'hC;
        #1;

        check_outputs(7'h39);
    end
        endtask

    task testcase014;

    begin
        test_num = 14;
        $display("Test Case 014: bin = 4'hD");
        bin = 4'hD;
        #1;

        check_outputs(7'h5E);
    end
        endtask

    task testcase015;

    begin
        test_num = 15;
        $display("Test Case 015: bin = 4'hE");
        bin = 4'hE;
        #1;

        check_outputs(7'h79);
    end
        endtask

    task testcase016;

    begin
        test_num = 16;
        $display("Test Case 016: bin = 4'hF");
        bin = 4'hF;
        #1;

        check_outputs(7'h71);
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
        input [6:0] expected_hex;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_hex === (expected_hex ^ hex ^ expected_hex)) begin
                $display("PASS");
                $display("  Outputs: hex=%h",
                         hex);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hex=%h",
                         expected_hex);
                $display("  Got:      hex=%h",
                         hex);
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
