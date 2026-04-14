`timescale 1ns/1ps

module priority_encoder_3bit_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] data_in;
    wire [1:0] pos_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    priority_encoder_3bit dut (
        .data_in(data_in),
        .pos_out(pos_out)
    );
    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("priority_encoder_3bit Testbench");
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
        input [1:0] expected_pos_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_pos_out === (expected_pos_out ^ pos_out ^ expected_pos_out)) begin
                $display("PASS");
                $display("  Outputs: pos_out=%h",
                         pos_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pos_out=%h",
                         expected_pos_out);
                $display("  Got:      pos_out=%h",
                         pos_out);
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
