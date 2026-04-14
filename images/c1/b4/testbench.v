`timescale 1ns/1ps

module ICAP_SPARTAN6_tb;

    // Testbench signals (sequential circuit)
    reg CE;
    reg CLK;
    reg [15:0] I;
    reg WRITE;
    wire BUSY;
    wire [15:0] O;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ICAP_SPARTAN6 dut (
        .CE(CE),
        .CLK(CLK),
        .I(I),
        .WRITE(WRITE),
        .BUSY(BUSY),
        .O(O)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
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
        $display("ICAP_SPARTAN6 Testbench");
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
        input expected_BUSY;
        input [15:0] expected_O;
        begin
            if (expected_BUSY === (expected_BUSY ^ BUSY ^ expected_BUSY) &&
                expected_O === (expected_O ^ O ^ expected_O)) begin
                $display("PASS");
                $display("  Outputs: BUSY=%b, O=%h",
                         BUSY, O);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: BUSY=%b, O=%h",
                         expected_BUSY, expected_O);
                $display("  Got:      BUSY=%b, O=%h",
                         BUSY, O);
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
        $dumpvars(0,CE, CLK, I, WRITE, BUSY, O);
    end

endmodule
