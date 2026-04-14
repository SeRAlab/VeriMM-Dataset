`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] data1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data1(data1)
    );
    task testcase001;

    begin
        test_num = 1;

        data1 = 32'h00000000;
        exp_b0 = 4'h0; exp_b1 = 4'h0; exp_b2 = 4'h0; exp_b3 = 4'h0;
        #1;

        check_outputs();
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        data1 = 32'hFFFFFFFF;
        exp_b0 = 4'hF; exp_b1 = 4'hF; exp_b2 = 4'hF; exp_b3 = 4'hF;
        #1;

        check_outputs();
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        data1 = 32'h00004321;
        exp_b0 = 4'h1; exp_b1 = 4'h2; exp_b2 = 4'h3; exp_b3 = 4'h4;
        #1;

        check_outputs();
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        data1 = 32'h1234ABCD;
        exp_b0 = 4'hD; exp_b1 = 4'hC; exp_b2 = 4'hB; exp_b3 = 4'hA;
        #1;

        check_outputs();
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        data1 = 32'h5555AAAA;
        exp_b0 = 4'hA; exp_b1 = 4'hA; exp_b2 = 4'hA; exp_b3 = 4'hA;
        #1;

        check_outputs();
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
        begin
            #1; // Small delay for combinational logic to settle
            if () begin
                $display("PASS");
                $display("  Outputs: ",
                         );
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ",
                         );
                $display("  Got:      ",
                         );
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
