`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] checksum_in;
    reg [127:0] data_in;
    wire [15:0] checksum_out;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .checksum_in(checksum_in),
        .data_in(data_in),
        .checksum_out(checksum_out),
        .valid(valid)
    );
    task testcase001;

        begin
            test_num = 1;
            data_in = 128'h0;
            checksum_in = 16'h1001;
            #1;

            check_outputs(16'h1001, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            data_in = 128'h0;
            checksum_in = 16'h0000;
            #1;

            check_outputs(16'h1001, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            data_in = 128'h01010101010101010101010101010101;
            checksum_in = 16'h9811;
            #1;

            check_outputs(16'h9811, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            data_in = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
            checksum_in = 16'h3A41;
            #1;

            check_outputs(16'h3A41, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;

            data_in = 128'h0F0E0D0C0B0A09080706050403020100;
            checksum_in = 16'hC279;
            #1;

            check_outputs(16'hC279, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;

            data_in = 128'h000102030405060708090A0B0C0D0E0F;
            checksum_in = 16'h7979;
            #1;

            check_outputs(16'h7979, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            data_in = 128'h0000000000000000FFFFFFFFFFFFFFFF;
            checksum_in = 16'hA521;
            #1;

            check_outputs(16'hA521, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            data_in = 128'hFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFB;
            checksum_in = 16'h1001;
            #1;

            check_outputs(16'h1001, 1'b1);
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
        input [15:0] expected_checksum_out;
        input expected_valid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_checksum_out === (expected_checksum_out ^ checksum_out ^ expected_checksum_out) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: checksum_out=%h, valid=%b",
                         checksum_out, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: checksum_out=%h, valid=%b",
                         expected_checksum_out, expected_valid);
                $display("  Got:      checksum_out=%h, valid=%b",
                         checksum_out, valid);
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
