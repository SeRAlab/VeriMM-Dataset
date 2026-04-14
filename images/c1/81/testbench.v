`timescale 1ns/1ps

module spiarbiter_tb;

    // Testbench signals (sequential circuit)
    reg i_ck_a;
    reg i_ck_b;
    reg i_clk;
    reg i_cs_a_n;
    reg i_cs_b_n;
    reg i_mosi_a;
    reg i_mosi_b;
    wire o_ck;
    wire o_cs_a_n;
    wire o_cs_b_n;
    wire o_grant;
    wire o_mosi;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    spiarbiter dut (
        .i_ck_a(i_ck_a),
        .i_ck_b(i_ck_b),
        .i_clk(i_clk),
        .i_cs_a_n(i_cs_a_n),
        .i_cs_b_n(i_cs_b_n),
        .i_mosi_a(i_mosi_a),
        .i_mosi_b(i_mosi_b),
        .o_ck(o_ck),
        .o_cs_a_n(o_cs_a_n),
        .o_cs_b_n(o_cs_b_n),
        .o_grant(o_grant),
        .o_mosi(o_mosi)
    );

    // Clock generation (10ns period)
    initial begin
        i_clk = 0;
        forever #5 i_clk = ~i_clk;
    end

    task reset_dut;
    //define reset task
    endtask
    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("spiarbiter Testbench");
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
        input expected_o_ck;
        input expected_o_cs_a_n;
        input expected_o_cs_b_n;
        input expected_o_grant;
        input expected_o_mosi;
        begin
            if (expected_o_ck === (expected_o_ck ^ o_ck ^ expected_o_ck) &&
                expected_o_cs_a_n === (expected_o_cs_a_n ^ o_cs_a_n ^ expected_o_cs_a_n) &&
                expected_o_cs_b_n === (expected_o_cs_b_n ^ o_cs_b_n ^ expected_o_cs_b_n) &&
                expected_o_grant === (expected_o_grant ^ o_grant ^ expected_o_grant) &&
                expected_o_mosi === (expected_o_mosi ^ o_mosi ^ expected_o_mosi)) begin
                $display("PASS");
                $display("  Outputs: o_ck=%b, o_cs_a_n=%b, o_cs_b_n=%b, o_grant=%b, o_mosi=%b",
                         o_ck, o_cs_a_n, o_cs_b_n, o_grant, o_mosi);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_ck=%b, o_cs_a_n=%b, o_cs_b_n=%b, o_grant=%b, o_mosi=%b",
                         expected_o_ck, expected_o_cs_a_n, expected_o_cs_b_n, expected_o_grant, expected_o_mosi);
                $display("  Got:      o_ck=%b, o_cs_a_n=%b, o_cs_b_n=%b, o_grant=%b, o_mosi=%b",
                         o_ck, o_cs_a_n, o_cs_b_n, o_grant, o_mosi);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,i_ck_a, i_ck_b, i_clk, i_cs_a_n, i_cs_b_n, i_mosi_a, i_mosi_b, o_ck, o_cs_a_n, o_cs_b_n, o_grant, o_mosi);
    end

endmodule
