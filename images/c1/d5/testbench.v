`timescale 1ns/1ps

module wbusixchar_tb;

    // Testbench signals (sequential circuit)
    reg [6:0] i_bits;
    reg i_busy;
    reg i_clk;
    reg i_stb;
    wire o_busy;
    wire [7:0] o_char;
    wire o_stb;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    wbusixchar dut (
        .i_bits(i_bits),
        .i_busy(i_busy),
        .i_clk(i_clk),
        .i_stb(i_stb),
        .o_busy(o_busy),
        .o_char(o_char),
        .o_stb(o_stb)
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
        $display("wbusixchar Testbench");
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
        input expected_o_busy;
        input [7:0] expected_o_char;
        input expected_o_stb;
        begin
            if (expected_o_busy === (expected_o_busy ^ o_busy ^ expected_o_busy) &&
                expected_o_char === (expected_o_char ^ o_char ^ expected_o_char) &&
                expected_o_stb === (expected_o_stb ^ o_stb ^ expected_o_stb)) begin
                $display("PASS");
                $display("  Outputs: o_busy=%b, o_char=%h, o_stb=%b",
                         o_busy, o_char, o_stb);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_busy=%b, o_char=%h, o_stb=%b",
                         expected_o_busy, expected_o_char, expected_o_stb);
                $display("  Got:      o_busy=%b, o_char=%h, o_stb=%b",
                         o_busy, o_char, o_stb);
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
        $dumpvars(0,i_bits, i_busy, i_clk, i_stb, o_busy, o_char, o_stb);
    end

endmodule
