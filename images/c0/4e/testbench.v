`timescale 1ns/1ps

module eth_crc_tb;

    // Testbench signals (sequential circuit)
    reg Clk;
    reg [3:0] Data;
    reg Enable;
    reg Initialize;
    reg Reset;
    wire [31:0] Crc;
    wire CrcError;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    eth_crc dut (
        .Clk(Clk),
        .Data(Data),
        .Enable(Enable),
        .Initialize(Initialize),
        .Reset(Reset),
        .Crc(Crc),
        .CrcError(CrcError)
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
        $display("eth_crc Testbench");
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
        input [31:0] expected_Crc;
        input expected_CrcError;
        begin
            if (expected_Crc === (expected_Crc ^ Crc ^ expected_Crc) &&
                expected_CrcError === (expected_CrcError ^ CrcError ^ expected_CrcError)) begin
                $display("PASS");
                $display("  Outputs: Crc=%h, CrcError=%b",
                         Crc, CrcError);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Crc=%h, CrcError=%b",
                         expected_Crc, expected_CrcError);
                $display("  Got:      Crc=%h, CrcError=%b",
                         Crc, CrcError);
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
        $dumpvars(0,Clk, Data, Enable, Initialize, Reset, Crc, CrcError);
    end

endmodule
