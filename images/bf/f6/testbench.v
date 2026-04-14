`timescale 1ns/1ps

module wbucompactlines_tb;

    // Testbench signals (sequential circuit)
    reg i_bus_busy;
    reg i_clk;
    reg [6:0] i_nl_hexbits;
    reg i_stb;
    reg i_tx_busy;
    wire o_busy;
    wire [6:0] o_nl_hexbits;
    wire o_stb;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    wbucompactlines dut (
        .i_bus_busy(i_bus_busy),
        .i_clk(i_clk),
        .i_nl_hexbits(i_nl_hexbits),
        .i_stb(i_stb),
        .i_tx_busy(i_tx_busy),
        .o_busy(o_busy),
        .o_nl_hexbits(o_nl_hexbits),
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
        $display("wbucompactlines Testbench");
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
        input [6:0] expected_o_nl_hexbits;
        input expected_o_stb;
        begin
            if (expected_o_busy === (expected_o_busy ^ o_busy ^ expected_o_busy) &&
                expected_o_nl_hexbits === (expected_o_nl_hexbits ^ o_nl_hexbits ^ expected_o_nl_hexbits) &&
                expected_o_stb === (expected_o_stb ^ o_stb ^ expected_o_stb)) begin
                $display("PASS");
                $display("  Outputs: o_busy=%b, o_nl_hexbits=%h, o_stb=%b",
                         o_busy, o_nl_hexbits, o_stb);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_busy=%b, o_nl_hexbits=%h, o_stb=%b",
                         expected_o_busy, expected_o_nl_hexbits, expected_o_stb);
                $display("  Got:      o_busy=%b, o_nl_hexbits=%h, o_stb=%b",
                         o_busy, o_nl_hexbits, o_stb);
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
        $dumpvars(0,i_bus_busy, i_clk, i_nl_hexbits, i_stb, i_tx_busy, o_busy, o_nl_hexbits, o_stb);
    end

endmodule
