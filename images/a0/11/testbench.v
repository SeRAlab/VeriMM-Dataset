`timescale 1ns/1ps

module shift_register_16bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg reset;
    reg s_in;
    wire [15:0] p_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register_16bit dut (
        .clk(clk),
        .en(en),
        .reset(reset),
        .s_in(s_in),
        .p_out(p_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
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
        $display("shift_register_16bit Testbench");
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
        input [15:0] expected_p_out;
        begin
            if (expected_p_out === (expected_p_out ^ p_out ^ expected_p_out)) begin
                $display("PASS");
                $display("  Outputs: p_out=%h",
                         p_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: p_out=%h",
                         expected_p_out);
                $display("  Got:      p_out=%h",
                         p_out);
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
        $dumpvars(0,clk, en, reset, s_in, p_out);
    end

endmodule
