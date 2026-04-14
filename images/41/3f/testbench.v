`timescale 1ns/1ps

module binary_decoder_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] BIN;
    wire [3:0] DEC;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_decoder dut (
        .BIN(BIN),
        .DEC(DEC)
    );
    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_decoder Testbench");
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
        input [3:0] expected_DEC;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_DEC === (expected_DEC ^ DEC ^ expected_DEC)) begin
                $display("PASS");
                $display("  Outputs: DEC=%h",
                         DEC);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DEC=%h",
                         expected_DEC);
                $display("  Got:      DEC=%h",
                         DEC);
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
