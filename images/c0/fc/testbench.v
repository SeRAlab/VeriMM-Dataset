`timescale 1ns/1ps

module basic_hashfunc_tb;

    // Testbench signals (combinational circuit)
    reg [47:0] hf_in;
    wire [9:0] hf_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    basic_hashfunc dut (
        .hf_in(hf_in),
        .hf_out(hf_out)
    );
    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("basic_hashfunc Testbench");
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
        input [9:0] expected_hf_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_hf_out === (expected_hf_out ^ hf_out ^ expected_hf_out)) begin
                $display("PASS");
                $display("  Outputs: hf_out=%h",
                         hf_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hf_out=%h",
                         expected_hf_out);
                $display("  Got:      hf_out=%h",
                         hf_out);
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
