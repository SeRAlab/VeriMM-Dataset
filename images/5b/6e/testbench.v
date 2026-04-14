`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] w_out_M1_OUT;
    wire [31:0] w_out_M2_IN;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .w_out_M1_OUT(w_out_M1_OUT),
        .w_out_M2_IN(w_out_M2_IN)
    );
    task testcase001;

        begin
            test_num = 1;
            w_out_M1_OUT = 32'h00000000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            w_out_M1_OUT = 32'hFFFFFFFF;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            w_out_M1_OUT = 32'hAAAAAAAA;
            #1;

            check_outputs(32'hAAAAAAAA);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            w_out_M1_OUT = 32'h55555555;
            #1;

            check_outputs(32'h55555555);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            w_out_M1_OUT = 32'hDEADBEEF;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            w_out_M1_OUT = 32'h12345678;
            #1;

            check_outputs(32'h12345678);
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
        input [31:0] expected_w_out_M2_IN;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_w_out_M2_IN === (expected_w_out_M2_IN ^ w_out_M2_IN ^ expected_w_out_M2_IN)) begin
                $display("PASS");
                $display("  Outputs: w_out_M2_IN=%h",
                         w_out_M2_IN);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: w_out_M2_IN=%h",
                         expected_w_out_M2_IN);
                $display("  Got:      w_out_M2_IN=%h",
                         w_out_M2_IN);
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
