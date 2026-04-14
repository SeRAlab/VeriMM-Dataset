`timescale 1ns/1ps

module hpdmc_banktimer_tb;

    // Testbench signals (sequential circuit)
    reg read;
    reg sdram_rst;
    reg sys_clk;
    reg tim_cas;
    reg [1:0] tim_wr;
    reg write;
    wire precharge_safe;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    hpdmc_banktimer dut (
        .read(read),
        .sdram_rst(sdram_rst),
        .sys_clk(sys_clk),
        .tim_cas(tim_cas),
        .tim_wr(tim_wr),
        .write(write),
        .precharge_safe(precharge_safe)
    );

    // Clock generation (10ns period)
    initial begin
        sys_clk = 0;
        forever #5 sys_clk = ~sys_clk;
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
        $display("hpdmc_banktimer Testbench");
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
        input expected_precharge_safe;
        begin
            if (expected_precharge_safe === (expected_precharge_safe ^ precharge_safe ^ expected_precharge_safe)) begin
                $display("PASS");
                $display("  Outputs: precharge_safe=%b",
                         precharge_safe);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: precharge_safe=%b",
                         expected_precharge_safe);
                $display("  Got:      precharge_safe=%b",
                         precharge_safe);
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
        $dumpvars(0,read, sdram_rst, sys_clk, tim_cas, tim_wr, write, precharge_safe);
    end

endmodule
