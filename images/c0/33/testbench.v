`timescale 1ns/1ps

module wbutohex_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] i_byte;
    reg i_clk;
    reg i_stb;
    wire [5:0] o_hexbits;
    wire o_stb;
    wire o_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    wbutohex dut (
        .i_byte(i_byte),
        .i_clk(i_clk),
        .i_stb(i_stb),
        .o_hexbits(o_hexbits),
        .o_stb(o_stb),
        .o_valid(o_valid)
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
        $display("wbutohex Testbench");
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
        input [5:0] expected_o_hexbits;
        input expected_o_stb;
        input expected_o_valid;
        begin
            if (expected_o_hexbits === (expected_o_hexbits ^ o_hexbits ^ expected_o_hexbits) &&
                expected_o_stb === (expected_o_stb ^ o_stb ^ expected_o_stb) &&
                expected_o_valid === (expected_o_valid ^ o_valid ^ expected_o_valid)) begin
                $display("PASS");
                $display("  Outputs: o_hexbits=%h, o_stb=%b, o_valid=%b",
                         o_hexbits, o_stb, o_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_hexbits=%h, o_stb=%b, o_valid=%b",
                         expected_o_hexbits, expected_o_stb, expected_o_valid);
                $display("  Got:      o_hexbits=%h, o_stb=%b, o_valid=%b",
                         o_hexbits, o_stb, o_valid);
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
        $dumpvars(0,i_byte, i_clk, i_stb, o_hexbits, o_stb, o_valid);
    end

endmodule
