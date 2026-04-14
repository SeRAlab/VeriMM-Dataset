`timescale 1ns/1ps

module bus_switch_tb;

    // Testbench signals (combinational circuit)
    reg ctl_sw_1d;
    reg ctl_sw_1u;
    reg ctl_sw_2d;
    reg ctl_sw_2u;
    reg ctl_sw_mask543_en;
    wire bus_sw_1d;
    wire bus_sw_1u;
    wire bus_sw_2d;
    wire bus_sw_2u;
    wire bus_sw_mask543_en;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bus_switch dut (
        .ctl_sw_1d(ctl_sw_1d),
        .ctl_sw_1u(ctl_sw_1u),
        .ctl_sw_2d(ctl_sw_2d),
        .ctl_sw_2u(ctl_sw_2u),
        .ctl_sw_mask543_en(ctl_sw_mask543_en),
        .bus_sw_1d(bus_sw_1d),
        .bus_sw_1u(bus_sw_1u),
        .bus_sw_2d(bus_sw_2d),
        .bus_sw_2u(bus_sw_2u),
        .bus_sw_mask543_en(bus_sw_mask543_en)
    );
    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bus_switch Testbench");
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
        input expected_bus_sw_1d;
        input expected_bus_sw_1u;
        input expected_bus_sw_2d;
        input expected_bus_sw_2u;
        input expected_bus_sw_mask543_en;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_bus_sw_1d === (expected_bus_sw_1d ^ bus_sw_1d ^ expected_bus_sw_1d) &&
                expected_bus_sw_1u === (expected_bus_sw_1u ^ bus_sw_1u ^ expected_bus_sw_1u) &&
                expected_bus_sw_2d === (expected_bus_sw_2d ^ bus_sw_2d ^ expected_bus_sw_2d) &&
                expected_bus_sw_2u === (expected_bus_sw_2u ^ bus_sw_2u ^ expected_bus_sw_2u) &&
                expected_bus_sw_mask543_en === (expected_bus_sw_mask543_en ^ bus_sw_mask543_en ^ expected_bus_sw_mask543_en)) begin
                $display("PASS");
                $display("  Outputs: bus_sw_1d=%b, bus_sw_1u=%b, bus_sw_2d=%b, bus_sw_2u=%b, bus_sw_mask543_en=%b",
                         bus_sw_1d, bus_sw_1u, bus_sw_2d, bus_sw_2u, bus_sw_mask543_en);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bus_sw_1d=%b, bus_sw_1u=%b, bus_sw_2d=%b, bus_sw_2u=%b, bus_sw_mask543_en=%b",
                         expected_bus_sw_1d, expected_bus_sw_1u, expected_bus_sw_2d, expected_bus_sw_2u, expected_bus_sw_mask543_en);
                $display("  Got:      bus_sw_1d=%b, bus_sw_1u=%b, bus_sw_2d=%b, bus_sw_2u=%b, bus_sw_mask543_en=%b",
                         bus_sw_1d, bus_sw_1u, bus_sw_2d, bus_sw_2u, bus_sw_mask543_en);
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

endmodule
