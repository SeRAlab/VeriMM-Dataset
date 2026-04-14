`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] pri_in;
    reg valid;
    wire [7:0] pri_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .pri_in(pri_in),
        .valid(valid),
        .pri_out(pri_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: valid=0, pri_in=3'b111 (Disabled check)", test_num);
            valid = 1'b0;
            pri_in = 3'b111;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: valid=1, pri_in=3'b100 (Bit 2 only)", test_num);
            valid = 1'b1;
            pri_in = 3'b100;
            #1;

            check_outputs(8'd2);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: valid=1, pri_in=3'b111 (Bit 2 takes priority)", test_num);
            valid = 1'b1;
            pri_in = 3'b111;
            #1;

            check_outputs(8'd2);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: valid=1, pri_in=3'b010 (Bit 1 only)", test_num);
            valid = 1'b1;
            pri_in = 3'b010;
            #1;

            check_outputs(8'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: valid=1, pri_in=3'b011 (Bit 1 takes priority)", test_num);
            valid = 1'b1;
            pri_in = 3'b011;
            #1;

            check_outputs(8'd1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: valid=1, pri_in=3'b001 (Bit 0 only)", test_num);
            valid = 1'b1;
            pri_in = 3'b001;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: valid=1, pri_in=3'b000 (No inputs set)", test_num);
            valid = 1'b1;
            pri_in = 3'b000;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Toggle valid while pri_in is 3'b110", test_num);
            pri_in = 3'b110;
            valid = 1'b0; #5;
            valid = 1'b1;
            #1;

            check_outputs(8'd2);
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
        input [7:0] expected_pri_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_pri_out === (expected_pri_out ^ pri_out ^ expected_pri_out)) begin
                $display("PASS");
                $display("  Outputs: pri_out=%h",
                         pri_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pri_out=%h",
                         expected_pri_out);
                $display("  Got:      pri_out=%h",
                         pri_out);
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
