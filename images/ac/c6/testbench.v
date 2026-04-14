`timescale 1ns/1ps

module edge_detector_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg IN;
    reg RST;
    wire EDGE_DET;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    edge_detector dut (
        .CLK(CLK),
        .IN(IN),
        .RST(RST),
        .EDGE_DET(EDGE_DET)
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
        $display("edge_detector Testbench");
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
        input expected_EDGE_DET;
        begin
            if (expected_EDGE_DET === (expected_EDGE_DET ^ EDGE_DET ^ expected_EDGE_DET)) begin
                $display("PASS");
                $display("  Outputs: EDGE_DET=%b",
                         EDGE_DET);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: EDGE_DET=%b",
                         expected_EDGE_DET);
                $display("  Got:      EDGE_DET=%b",
                         EDGE_DET);
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
        $dumpvars(0,CLK, IN, RST, EDGE_DET);
    end

endmodule
