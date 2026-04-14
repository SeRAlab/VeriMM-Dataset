`timescale 1ns/1ps

module binary_decoder_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] BIN_IN;
    wire [3:0] DEC_OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_decoder dut (
        .BIN_IN(BIN_IN),
        .DEC_OUT(DEC_OUT)
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
        input [3:0] expected_DEC_OUT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_DEC_OUT === (expected_DEC_OUT ^ DEC_OUT ^ expected_DEC_OUT)) begin
                $display("PASS");
                $display("  Outputs: DEC_OUT=%h",
                         DEC_OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DEC_OUT=%h",
                         expected_DEC_OUT);
                $display("  Got:      DEC_OUT=%h",
                         DEC_OUT);
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
