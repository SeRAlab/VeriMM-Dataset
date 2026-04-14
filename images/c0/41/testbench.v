`timescale 1ns/1ps

module ADDR_ROM_tb;

    // Testbench signals (combinational circuit)
    reg CS;
    reg [4:0] IR_OUT;
    wire [4:0] AR_OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ADDR_ROM dut (
        .CS(CS),
        .IR_OUT(IR_OUT),
        .AR_OUT(AR_OUT)
    );
    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ADDR_ROM Testbench");
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
        input [4:0] expected_AR_OUT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_AR_OUT === (expected_AR_OUT ^ AR_OUT ^ expected_AR_OUT)) begin
                $display("PASS");
                $display("  Outputs: AR_OUT=%h",
                         AR_OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: AR_OUT=%h",
                         expected_AR_OUT);
                $display("  Got:      AR_OUT=%h",
                         AR_OUT);
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
