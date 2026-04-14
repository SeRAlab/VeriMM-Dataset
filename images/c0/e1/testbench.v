`timescale 1ns/1ps

module address_pins_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] address;
    reg bus_ab_pin_we;
    reg clk;
    reg pin_control_oe;
    wire [15:0] abus;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    address_pins dut (
        .address(address),
        .bus_ab_pin_we(bus_ab_pin_we),
        .clk(clk),
        .pin_control_oe(pin_control_oe),
        .abus(abus)
    );

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
        $display("address_pins Testbench");
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
        input [15:0] expected_abus;
        begin
            if (expected_abus === (expected_abus ^ abus ^ expected_abus)) begin
                $display("PASS");
                $display("  Outputs: abus=%h",
                         abus);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: abus=%h",
                         expected_abus);
                $display("  Got:      abus=%h",
                         abus);
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
        $dumpvars(0,address, bus_ab_pin_we, clk, pin_control_oe, abus);
    end

endmodule
