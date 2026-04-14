`timescale 1ns/1ps

module bmc101_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] rx_pair;
    wire [1:0] path_0_bmc;
    wire [1:0] path_1_bmc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bmc101 dut (
        .rx_pair(rx_pair),
        .path_0_bmc(path_0_bmc),
        .path_1_bmc(path_1_bmc)
    );
    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bmc101 Testbench");
        $display("========================================");


        
        
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
        input [1:0] expected_path_0_bmc;
        input [1:0] expected_path_1_bmc;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_path_0_bmc === (expected_path_0_bmc ^ path_0_bmc ^ expected_path_0_bmc) &&
                expected_path_1_bmc === (expected_path_1_bmc ^ path_1_bmc ^ expected_path_1_bmc)) begin
                $display("PASS");
                $display("  Outputs: path_0_bmc=%h, path_1_bmc=%h",
                         path_0_bmc, path_1_bmc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: path_0_bmc=%h, path_1_bmc=%h",
                         expected_path_0_bmc, expected_path_1_bmc);
                $display("  Got:      path_0_bmc=%h, path_1_bmc=%h",
                         path_0_bmc, path_1_bmc);
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
