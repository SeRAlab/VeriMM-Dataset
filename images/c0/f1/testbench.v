`timescale 1ns/1ps

module eth_clockgen_tb;

    // Testbench signals (sequential circuit)
    reg Clk;
    reg [7:0] Divider;
    reg Reset;
    wire Mdc;
    wire MdcEn;
    wire MdcEn_n;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    eth_clockgen dut (
        .Clk(Clk),
        .Divider(Divider),
        .Reset(Reset),
        .Mdc(Mdc),
        .MdcEn(MdcEn),
        .MdcEn_n(MdcEn_n)
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
        $display("eth_clockgen Testbench");
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
        input expected_Mdc;
        input expected_MdcEn;
        input expected_MdcEn_n;
        begin
            if (expected_Mdc === (expected_Mdc ^ Mdc ^ expected_Mdc) &&
                expected_MdcEn === (expected_MdcEn ^ MdcEn ^ expected_MdcEn) &&
                expected_MdcEn_n === (expected_MdcEn_n ^ MdcEn_n ^ expected_MdcEn_n)) begin
                $display("PASS");
                $display("  Outputs: Mdc=%b, MdcEn=%b, MdcEn_n=%b",
                         Mdc, MdcEn, MdcEn_n);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Mdc=%b, MdcEn=%b, MdcEn_n=%b",
                         expected_Mdc, expected_MdcEn, expected_MdcEn_n);
                $display("  Got:      Mdc=%b, MdcEn=%b, MdcEn_n=%b",
                         Mdc, MdcEn, MdcEn_n);
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
        $dumpvars(0,Clk, Divider, Reset, Mdc, MdcEn, MdcEn_n);
    end

endmodule
