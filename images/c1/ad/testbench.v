`timescale 1ns/1ps

module ag_reg_decoder_tb;

    // Testbench signals (combinational circuit)
    reg ctrl;
    reg [6:0] keyb_in;
    reg shift;
    wire [6:0] keyb_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ag_reg_decoder dut (
        .ctrl(ctrl),
        .keyb_in(keyb_in),
        .shift(shift),
        .keyb_out(keyb_out)
    );
    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ag_reg_decoder Testbench");
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
        input [6:0] expected_keyb_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_keyb_out === (expected_keyb_out ^ keyb_out ^ expected_keyb_out)) begin
                $display("PASS");
                $display("  Outputs: keyb_out=%h",
                         keyb_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: keyb_out=%h",
                         expected_keyb_out);
                $display("  Got:      keyb_out=%h",
                         keyb_out);
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
