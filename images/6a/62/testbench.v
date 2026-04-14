`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg cyc;
    wire [31:0] a0.cyc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cyc(cyc),
        .a0.cyc(a0.cyc)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Input cyc = 0 (Expected output all bits HIGH)", test_num);
        cyc = 1'b0;


        #1;



        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Input cyc = 1 (Expected output all bits LOW)", test_num);
        cyc = 1'b1;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Input cyc = 0 (Transition back to LOW input)", test_num);
        cyc = 1'b0;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Input cyc = 1 (Transition back to HIGH input)", test_num);
        cyc = 1'b1;
        #1;

        check_outputs(32'h00000000);
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
        input [31:0] expected_a0.cyc;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_a0.cyc === (expected_a0.cyc ^ a0.cyc ^ expected_a0.cyc)) begin
                $display("PASS");
                $display("  Outputs: a0.cyc=%h",
                         a0.cyc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: a0.cyc=%h",
                         expected_a0.cyc);
                $display("  Got:      a0.cyc=%h",
                         a0.cyc);
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
