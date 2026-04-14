`timescale 1ns/1ps

module CRC_chk_tb;

    // Testbench signals (sequential circuit)
    reg CRC_chk_en;
    reg [7:0] CRC_data;
    reg CRC_en;
    reg CRC_init;
    reg Clk;
    reg Reset;
    wire CRC_err;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    CRC_chk dut (
        .CRC_chk_en(CRC_chk_en),
        .CRC_data(CRC_data),
        .CRC_en(CRC_en),
        .CRC_init(CRC_init),
        .Clk(Clk),
        .Reset(Reset),
        .CRC_err(CRC_err)
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
        $display("CRC_chk Testbench");
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
        input expected_CRC_err;
        begin
            if (expected_CRC_err === (expected_CRC_err ^ CRC_err ^ expected_CRC_err)) begin
                $display("PASS");
                $display("  Outputs: CRC_err=%b",
                         CRC_err);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CRC_err=%b",
                         expected_CRC_err);
                $display("  Got:      CRC_err=%b",
                         CRC_err);
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
        $dumpvars(0,CRC_chk_en, CRC_data, CRC_en, CRC_init, Clk, Reset, CRC_err);
    end

endmodule
