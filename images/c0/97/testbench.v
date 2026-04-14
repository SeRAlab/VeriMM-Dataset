`timescale 1ns/1ps

module pin_control_tb;

    // Testbench signals (combinational circuit)
    reg T1;
    reg T2;
    reg T3;
    reg T4;
    reg fFetch;
    reg fIORead;
    reg fIOWrite;
    reg fMRead;
    reg fMWrite;
    wire bus_ab_pin_we;
    wire bus_db_pin_oe;
    wire bus_db_pin_re;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pin_control dut (
        .T1(T1),
        .T2(T2),
        .T3(T3),
        .T4(T4),
        .fFetch(fFetch),
        .fIORead(fIORead),
        .fIOWrite(fIOWrite),
        .fMRead(fMRead),
        .fMWrite(fMWrite),
        .bus_ab_pin_we(bus_ab_pin_we),
        .bus_db_pin_oe(bus_db_pin_oe),
        .bus_db_pin_re(bus_db_pin_re)
    );
    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pin_control Testbench");
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
        input expected_bus_ab_pin_we;
        input expected_bus_db_pin_oe;
        input expected_bus_db_pin_re;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_bus_ab_pin_we === (expected_bus_ab_pin_we ^ bus_ab_pin_we ^ expected_bus_ab_pin_we) &&
                expected_bus_db_pin_oe === (expected_bus_db_pin_oe ^ bus_db_pin_oe ^ expected_bus_db_pin_oe) &&
                expected_bus_db_pin_re === (expected_bus_db_pin_re ^ bus_db_pin_re ^ expected_bus_db_pin_re)) begin
                $display("PASS");
                $display("  Outputs: bus_ab_pin_we=%b, bus_db_pin_oe=%b, bus_db_pin_re=%b",
                         bus_ab_pin_we, bus_db_pin_oe, bus_db_pin_re);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bus_ab_pin_we=%b, bus_db_pin_oe=%b, bus_db_pin_re=%b",
                         expected_bus_ab_pin_we, expected_bus_db_pin_oe, expected_bus_db_pin_re);
                $display("  Got:      bus_ab_pin_we=%b, bus_db_pin_oe=%b, bus_db_pin_re=%b",
                         bus_ab_pin_we, bus_db_pin_oe, bus_db_pin_re);
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
