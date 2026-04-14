`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] rom_address;
    wire [23:0] rom_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .rom_address(rom_address),
        .rom_data(rom_data)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        rom_address = 5'd0;
        $display("Test %0d: Address 0 (Valid Range)", test_num);
        #1;

        check_outputs(24'h000040);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        rom_address = 5'd10;
        $display("Test %0d: Address 10 (Valid Range)", test_num);
        #1;

        check_outputs(24'h0002C0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        rom_address = 5'd19;
        $display("Test %0d: Address 19 (Boundary Valid)", test_num);
        #1;

        check_outputs(24'h000500);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        rom_address = 5'd20;
        $display("Test %0d: Address 20 (Boundary Invalid)", test_num);
        #1;

        check_outputs(24'h000000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        rom_address = 5'd31;
        $display("Test %0d: Address 31 (Max Invalid Range)", test_num);
        #1;

        check_outputs(24'h000000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input [23:0] expected_rom_data;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_rom_data === (expected_rom_data ^ rom_data ^ expected_rom_data)) begin
                $display("PASS");
                $display("  Outputs: rom_data=%h",
                         rom_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rom_data=%h",
                         expected_rom_data);
                $display("  Got:      rom_data=%h",
                         rom_data);
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
