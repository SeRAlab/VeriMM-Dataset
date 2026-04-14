`timescale 1ns/1ps

module ACC_tb;

    // Testbench signals (sequential circuit)
    reg [8:0] ACC_IN;
    reg EA;
    reg LA;
    reg clk;
    wire [8:0] ACC_ALU;
    wire [8:0] ACC_BUS;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ACC dut (
        .ACC_IN(ACC_IN),
        .EA(EA),
        .LA(LA),
        .clk(clk),
        .ACC_ALU(ACC_ALU),
        .ACC_BUS(ACC_BUS)
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
        $display("ACC Testbench");
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
        input [8:0] expected_ACC_ALU;
        input [8:0] expected_ACC_BUS;
        begin
            if (expected_ACC_ALU === (expected_ACC_ALU ^ ACC_ALU ^ expected_ACC_ALU) &&
                expected_ACC_BUS === (expected_ACC_BUS ^ ACC_BUS ^ expected_ACC_BUS)) begin
                $display("PASS");
                $display("  Outputs: ACC_ALU=%h, ACC_BUS=%h",
                         ACC_ALU, ACC_BUS);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ACC_ALU=%h, ACC_BUS=%h",
                         expected_ACC_ALU, expected_ACC_BUS);
                $display("  Got:      ACC_ALU=%h, ACC_BUS=%h",
                         ACC_ALU, ACC_BUS);
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
        $dumpvars(0,ACC_IN, EA, LA, clk, ACC_ALU, ACC_BUS);
    end

endmodule
