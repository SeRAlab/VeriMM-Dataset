`timescale 1ns/1ps

module UART_BRG_tb;

    // Testbench signals (sequential circuit)
    reg Clk;
    reg [7:0] Div;
    reg [3:0] PS;
    reg Rst;
    wire CE_16x;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    UART_BRG dut (
        .Clk(Clk),
        .Div(Div),
        .PS(PS),
        .Rst(Rst),
        .CE_16x(CE_16x)
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
        $display("UART_BRG Testbench");
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
        input expected_CE_16x;
        begin
            if (expected_CE_16x === (expected_CE_16x ^ CE_16x ^ expected_CE_16x)) begin
                $display("PASS");
                $display("  Outputs: CE_16x=%b",
                         CE_16x);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CE_16x=%b",
                         expected_CE_16x);
                $display("  Got:      CE_16x=%b",
                         CE_16x);
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
        $dumpvars(0,Clk, Div, PS, Rst, CE_16x);
    end

endmodule
