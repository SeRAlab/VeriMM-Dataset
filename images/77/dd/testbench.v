`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] comb_circuit_out;
    reg [3:0] priority_enc_out;
    wire [3:0] max_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .comb_circuit_out(comb_circuit_out),
        .priority_enc_out(priority_enc_out),
        .max_out(max_out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Both inputs zero", test_num);
            priority_enc_out = 4'd0;
            comb_circuit_out = 4'd0;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Both inputs maximum", test_num);
            priority_enc_out = 4'd15;
            comb_circuit_out = 4'd15;
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: priority_enc_out is greater", test_num);
            priority_enc_out = 4'd10;
            comb_circuit_out = 4'd5;
            #1;

            check_outputs(4'd10);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: comb_circuit_out is greater", test_num);
            priority_enc_out = 4'd3;
            comb_circuit_out = 4'd12;
            #1;

            check_outputs(4'd12);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Boundary condition (1 vs 0)", test_num);
            priority_enc_out = 4'd1;
            comb_circuit_out = 4'd0;
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Boundary condition (0 vs 1)", test_num);
            priority_enc_out = 4'd0;
            comb_circuit_out = 4'd1;
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: One input is max, other is mid", test_num);
            priority_enc_out = 4'd7;
            comb_circuit_out = 4'd15;
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Comparison near max value", test_num);
            priority_enc_out = 4'd15;
            comb_circuit_out = 4'd14;
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Power of 2 comparison", test_num);
            priority_enc_out = 4'd8;
            comb_circuit_out = 4'd4;
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: Equality at mid-range", test_num);
            priority_enc_out = 4'd8;
            comb_circuit_out = 4'd8;
            #1;

            check_outputs(4'd8);
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
        input [3:0] expected_max_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_max_out === (expected_max_out ^ max_out ^ expected_max_out)) begin
                $display("PASS");
                $display("  Outputs: max_out=%h",
                         max_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: max_out=%h",
                         expected_max_out);
                $display("  Got:      max_out=%h",
                         max_out);
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
