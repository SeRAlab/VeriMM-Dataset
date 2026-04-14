`timescale 1ns/1ps

module dbg_crc8_d1_tb;

    // Testbench signals (sequential circuit)
    reg Clk;
    reg Data;
    reg EnableCrc;
    reg Reset;
    reg SyncResetCrc;
    wire [7:0] CrcOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dbg_crc8_d1 dut (
        .Clk(Clk),
        .Data(Data),
        .EnableCrc(EnableCrc),
        .Reset(Reset),
        .SyncResetCrc(SyncResetCrc),
        .CrcOut(CrcOut)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
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
        $display("dbg_crc8_d1 Testbench");
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
        input [7:0] expected_CrcOut;
        begin
            if (expected_CrcOut === (expected_CrcOut ^ CrcOut ^ expected_CrcOut)) begin
                $display("PASS");
                $display("  Outputs: CrcOut=%h",
                         CrcOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CrcOut=%h",
                         expected_CrcOut);
                $display("  Got:      CrcOut=%h",
                         CrcOut);
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
        $dumpvars(0,Clk, Data, EnableCrc, Reset, SyncResetCrc, CrcOut);
    end

endmodule
