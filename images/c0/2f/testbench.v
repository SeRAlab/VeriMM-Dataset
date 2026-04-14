`timescale 1ns/1ps

module int_encoder_tb;

    // Testbench signals (combinational circuit)
    reg executed;
    reg int_sig_in;
    reg rst;
    wire int_request;
    wire int_vect;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    int_encoder dut (
        .executed(executed),
        .int_sig_in(int_sig_in),
        .rst(rst),
        .int_request(int_request),
        .int_vect(int_vect)
    );
    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("int_encoder Testbench");
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
        input expected_int_request;
        input expected_int_vect;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_int_request === (expected_int_request ^ int_request ^ expected_int_request) &&
                expected_int_vect === (expected_int_vect ^ int_vect ^ expected_int_vect)) begin
                $display("PASS");
                $display("  Outputs: int_request=%b, int_vect=%b",
                         int_request, int_vect);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: int_request=%b, int_vect=%b",
                         expected_int_request, expected_int_vect);
                $display("  Got:      int_request=%b, int_vect=%b",
                         int_request, int_vect);
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
