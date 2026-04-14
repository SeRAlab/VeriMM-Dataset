`timescale 1ns/1ps

module jt51_sh_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] din;
    wire [4:0] drop;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    jt51_sh dut (
        .clk(clk),
        .din(din),
        .drop(drop)
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
        $display("jt51_sh Testbench");
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
        input [4:0] expected_drop;
        begin
            if (expected_drop === (expected_drop ^ drop ^ expected_drop)) begin
                $display("PASS");
                $display("  Outputs: drop=%h",
                         drop);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: drop=%h",
                         expected_drop);
                $display("  Got:      drop=%h",
                         drop);
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
        $dumpvars(0,clk, din, drop);
    end

endmodule
