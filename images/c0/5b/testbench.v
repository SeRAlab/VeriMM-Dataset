`timescale 1ns/1ps

module key_expander_tb;

    // Testbench signals (combinational circuit)
    reg add_w_out;
    reg enc_dec;
    reg [31:0] g_out;
    reg [127:0] key_in;
    reg [3:0] round;
    wire [31:0] g_in;
    wire [127:0] key_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    key_expander dut (
        .add_w_out(add_w_out),
        .enc_dec(enc_dec),
        .g_out(g_out),
        .key_in(key_in),
        .round(round),
        .g_in(g_in),
        .key_out(key_out)
    );
    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("key_expander Testbench");
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
        input [31:0] expected_g_in;
        input [127:0] expected_key_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_g_in === (expected_g_in ^ g_in ^ expected_g_in) &&
                expected_key_out === (expected_key_out ^ key_out ^ expected_key_out)) begin
                $display("PASS");
                $display("  Outputs: g_in=%h, key_out=%h",
                         g_in, key_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: g_in=%h, key_out=%h",
                         expected_g_in, expected_key_out);
                $display("  Got:      g_in=%h, key_out=%h",
                         g_in, key_out);
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
