`timescale 1ns/1ps

module z80memr_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    wire [15:0] a;
    wire [7:0] d;
    wire mreq;
    wire rd;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    z80memr dut (
        .clk(clk),
        .a(a),
        .d(d),
        .mreq(mreq),
        .rd(rd)
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
        $display("z80memr Testbench");
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
        input [15:0] expected_a;
        input [7:0] expected_d;
        input expected_mreq;
        input expected_rd;
        begin
            if (expected_a === (expected_a ^ a ^ expected_a) &&
                expected_d === (expected_d ^ d ^ expected_d) &&
                expected_mreq === (expected_mreq ^ mreq ^ expected_mreq) &&
                expected_rd === (expected_rd ^ rd ^ expected_rd)) begin
                $display("PASS");
                $display("  Outputs: a=%h, d=%h, mreq=%b, rd=%b",
                         a, d, mreq, rd);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: a=%h, d=%h, mreq=%b, rd=%b",
                         expected_a, expected_d, expected_mreq, expected_rd);
                $display("  Got:      a=%h, d=%h, mreq=%b, rd=%b",
                         a, d, mreq, rd);
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
        $dumpvars(0,clk, a, d, mreq, rd);
    end

endmodule
