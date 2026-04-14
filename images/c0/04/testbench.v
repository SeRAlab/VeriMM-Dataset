`timescale 1ns/1ps

module zzecc_sctag_30b_cor_tb;

    // Testbench signals (combinational circuit)
    reg [23:0] din;
    reg [4:0] parity;
    wire [4:0] corrected_bit;
    wire [23:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    zzecc_sctag_30b_cor dut (
        .din(din),
        .parity(parity),
        .corrected_bit(corrected_bit),
        .dout(dout)
    );
    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("zzecc_sctag_30b_cor Testbench");
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
        input [4:0] expected_corrected_bit;
        input [23:0] expected_dout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_corrected_bit === (expected_corrected_bit ^ corrected_bit ^ expected_corrected_bit) &&
                expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: corrected_bit=%h, dout=%h",
                         corrected_bit, dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: corrected_bit=%h, dout=%h",
                         expected_corrected_bit, expected_dout);
                $display("  Got:      corrected_bit=%h, dout=%h",
                         corrected_bit, dout);
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
