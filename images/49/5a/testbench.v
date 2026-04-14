`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] bcd;
    wire [7:0] bin;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bcd(bcd),
        .bin(bin)
    );
    task testcase001;

    begin
        bcd = 4'b0000;
        $display("Testcase 001: Input 0");
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase002;

    begin
        bcd = 4'b0001;
        $display("Testcase 002: Input 1");
        #1;

        check_outputs(8'd1);
    end
        endtask

    task testcase003;

    begin
        bcd = 4'b0101;
        $display("Testcase 003: Input 5");
        #1;

        check_outputs(8'd5);
    end
        endtask

    task testcase004;

    begin
        bcd = 4'b1000;
        $display("Testcase 004: Input 8");
        #1;

        check_outputs(8'd8);
    end
        endtask

    task testcase005;

    begin
        bcd = 4'b1001;
        $display("Testcase 005: Input 9");
        #1;

        check_outputs(8'd9);
    end
        endtask

    task testcase006;

    begin
        bcd = 4'b1010;
        $display("Testcase 006: Input 10 (Invalid)");
        #1;

        check_outputs(8'bzzzzzzzz);
    end
        endtask

    task testcase007;

    begin
        bcd = 4'b1100;
        $display("Testcase 007: Input 12 (Invalid)");
        #1;

        check_outputs(8'bzzzzzzzz);
    end
        endtask

    task testcase008;

    begin
        bcd = 4'b1111;
        $display("Testcase 008: Input 15 (Invalid)");
        #1;

        check_outputs(8'bzzzzzzzz);
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
        input [7:0] expected_bin;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_bin === (expected_bin ^ bin ^ expected_bin)) begin
                $display("PASS");
                $display("  Outputs: bin=%h",
                         bin);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bin=%h",
                         expected_bin);
                $display("  Got:      bin=%h",
                         bin);
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
