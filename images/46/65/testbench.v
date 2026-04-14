`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] in;
    wire [1:0] dec_out;
    wire [1:0] enc_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .dec_out(dec_out),
        .enc_out(enc_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Input = 2'b00", test_num);
            in = 2'b00;



            #1;




            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Input = 2'b01", test_num);
            in = 2'b01;
            #10;
            #1;

            check_outputs(2'b01, 2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Input = 2'b10", test_num);
            in = 2'b10;
            #10;
            #1;

            check_outputs(2'b10, 2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Input = 2'b11", test_num);
            in = 2'b11;
            #10;
            #1;

            check_outputs(2'b11, 2'b11);
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
        input [1:0] expected_dec_out;
        input [1:0] expected_enc_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dec_out === (expected_dec_out ^ dec_out ^ expected_dec_out) &&
                expected_enc_out === (expected_enc_out ^ enc_out ^ expected_enc_out)) begin
                $display("PASS");
                $display("  Outputs: dec_out=%h, enc_out=%h",
                         dec_out, enc_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dec_out=%h, enc_out=%h",
                         expected_dec_out, expected_enc_out);
                $display("  Got:      dec_out=%h, enc_out=%h",
                         dec_out, enc_out);
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
