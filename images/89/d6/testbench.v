`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] n_LL;
    reg n_POUT;
    wire [3:0] n_LU;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .n_LL(n_LL),
        .n_POUT(n_POUT),
        .n_LU(n_LU)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Selecting line 0 with control signal active");
            n_POUT = 1'b1;
            n_LL = 2'b00;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Selecting line 1 with control signal active");
            n_POUT = 1'b1;
            n_LL = 2'b01;
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Selecting line 2 with control signal active");
            n_POUT = 1'b1;
            n_LL = 2'b10;
            #1;

            check_outputs(4'b0100);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Selecting line 3 with control signal active");
            n_POUT = 1'b1;
            n_LL = 2'b11;
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Control signal inactive - Output should be disabled (all zero)");
            n_POUT = 1'b0;
            n_LL = 2'b11;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase 006: Control signal inactive with different input - Output should be disabled");
            n_POUT = 1'b0;
            n_LL = 2'b00;
            #1;

            check_outputs(4'b0000);
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
        input [3:0] expected_n_LU;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_n_LU === (expected_n_LU ^ n_LU ^ expected_n_LU)) begin
                $display("PASS");
                $display("  Outputs: n_LU=%h",
                         n_LU);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: n_LU=%h",
                         expected_n_LU);
                $display("  Got:      n_LU=%h",
                         n_LU);
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
