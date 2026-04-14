`timescale 1ns/1ps

module pit_prescale_tb;

    // Testbench signals (sequential circuit)
    reg async_rst_b;
    reg bus_clk;
    reg cnt_sync_o;
    reg [3:0] divisor;
    reg ext_sync_i;
    reg pit_slave;
    reg sync_reset;
    wire counter_sync;
    wire prescale_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pit_prescale dut (
        .async_rst_b(async_rst_b),
        .bus_clk(bus_clk),
        .cnt_sync_o(cnt_sync_o),
        .divisor(divisor),
        .ext_sync_i(ext_sync_i),
        .pit_slave(pit_slave),
        .sync_reset(sync_reset),
        .counter_sync(counter_sync),
        .prescale_out(prescale_out)
    );

    // Clock generation (10ns period)
    initial begin
        async_rst_b = 0;
        forever #5 async_rst_b = ~async_rst_b;
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
        $display("pit_prescale Testbench");
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
        input expected_counter_sync;
        input expected_prescale_out;
        begin
            if (expected_counter_sync === (expected_counter_sync ^ counter_sync ^ expected_counter_sync) &&
                expected_prescale_out === (expected_prescale_out ^ prescale_out ^ expected_prescale_out)) begin
                $display("PASS");
                $display("  Outputs: counter_sync=%b, prescale_out=%b",
                         counter_sync, prescale_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: counter_sync=%b, prescale_out=%b",
                         expected_counter_sync, expected_prescale_out);
                $display("  Got:      counter_sync=%b, prescale_out=%b",
                         counter_sync, prescale_out);
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
        $dumpvars(0,async_rst_b, bus_clk, cnt_sync_o, divisor, ext_sync_i, pit_slave, sync_reset, counter_sync, prescale_out);
    end

endmodule
