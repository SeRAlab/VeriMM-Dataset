`timescale 1ns/1ps

module counter_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] CE;
    reg CS;
    reg WR;
    reg clk;
    reg cmd;
    reg [7:0] din;
    wire [7:0] dout;
    wire [7:0] mode;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    counter dut (
        .CE(CE),
        .CS(CS),
        .WR(WR),
        .clk(clk),
        .cmd(cmd),
        .din(din),
        .dout(dout),
        .mode(mode)
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
        $display("counter Testbench");
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
        input [7:0] expected_dout;
        input [7:0] expected_mode;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_mode === (expected_mode ^ mode ^ expected_mode)) begin
                $display("PASS");
                $display("  Outputs: dout=%h, mode=%h",
                         dout, mode);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h, mode=%h",
                         expected_dout, expected_mode);
                $display("  Got:      dout=%h, mode=%h",
                         dout, mode);
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
        $dumpvars(0,CE, CS, WR, clk, cmd, din, dout, mode);
    end

endmodule
