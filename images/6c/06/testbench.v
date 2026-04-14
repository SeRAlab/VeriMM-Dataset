`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] mix_in;
    wire [31:0] mix_out_dec;
    wire [31:0] mix_out_enc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .mix_in(mix_in),
        .mix_out_dec(mix_out_dec),
        .mix_out_enc(mix_out_enc)
    );
    task testcase001;

    begin
        test_num = 1;
        mix_in = 32'h00000000;
        #1;

        check_outputs(32'h00000000, 32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        mix_in = 32'h01010101;
        #1;

        check_outputs(32'h01010101, 32'h01010101);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        mix_in = 32'hd4bf5d30;
        #1;

        check_outputs(32'h7bc839d8, 32'h046681e5);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        mix_in = 32'h046681e5;
        #1;

        check_outputs(32'hd4bf5d30, 32'h99a6c276);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        mix_in = 32'h8e4da1bc;
        #1;

        check_outputs(32'hdb135345, 32'h6d88a3b2);
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
        input [31:0] expected_mix_out_dec;
        input [31:0] expected_mix_out_enc;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_mix_out_dec === (expected_mix_out_dec ^ mix_out_dec ^ expected_mix_out_dec) &&
                expected_mix_out_enc === (expected_mix_out_enc ^ mix_out_enc ^ expected_mix_out_enc)) begin
                $display("PASS");
                $display("  Outputs: mix_out_dec=%h, mix_out_enc=%h",
                         mix_out_dec, mix_out_enc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mix_out_dec=%h, mix_out_enc=%h",
                         expected_mix_out_dec, expected_mix_out_enc);
                $display("  Got:      mix_out_dec=%h, mix_out_enc=%h",
                         mix_out_dec, mix_out_enc);
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
