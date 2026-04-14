`timescale 1ns/1ps

module wb_dma_pri_enc_sub_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] pri_in;
    reg valid;
    wire [7:0] pri_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    wb_dma_pri_enc_sub dut (
        .pri_in(pri_in),
        .valid(valid),
        .pri_out(pri_out)
    );
    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("wb_dma_pri_enc_sub Testbench");
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
