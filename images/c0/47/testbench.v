`timescale 1ns/1ps

module convround_tb;

    // Testbench signals (sequential circuit)
    reg i_ce;
    reg i_clk;
    reg [15:0] i_val;
    wire [7:0] o_val;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    convround dut (
        .i_ce(i_ce),
        .i_clk(i_clk),
        .i_val(i_val),
        .o_val(o_val)
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
        $display("convround Testbench");
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
        input [7:0] expected_o_val;
        begin
            if (expected_o_val === (expected_o_val ^ o_val ^ expected_o_val)) begin
                $display("PASS");
                $display("  Outputs: o_val=%h",
                         o_val);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_val=%h",
                         expected_o_val);
                $display("  Got:      o_val=%h",
                         o_val);
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
        $dumpvars(0,i_ce, i_clk, i_val, o_val);
    end

endmodule
