`timescale 1ns/1ps

module hssi_tx_tb;

    // Testbench signals (combinational circuit)
    reg areset;
    reg clk;
    reg datain;
    wire clkout;
    wire dataout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    hssi_tx dut (
        .areset(areset),
        .clk(clk),
        .datain(datain),
        .clkout(clkout),
        .dataout(dataout)
    );
    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("hssi_tx Testbench");
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
        input expected_clkout;
        input expected_dataout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_clkout === (expected_clkout ^ clkout ^ expected_clkout) &&
                expected_dataout === (expected_dataout ^ dataout ^ expected_dataout)) begin
                $display("PASS");
                $display("  Outputs: clkout=%b, dataout=%b",
                         clkout, dataout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clkout=%b, dataout=%b",
                         expected_clkout, expected_dataout);
                $display("  Got:      clkout=%b, dataout=%b",
                         clkout, dataout);
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
