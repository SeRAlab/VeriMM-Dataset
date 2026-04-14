`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] rom_address;
    wire [26:0] rom_data;

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
        test_num = 1;
        rom_address = 6'd0;
        #10;

        #1;


        check_outputs(27'h0000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        rom_address = 6'd1;
        #10;
        #1;

        check_outputs(27'h0000000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        rom_address = 6'd8;
        #10;
        #1;

        check_outputs(27'h0000000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        rom_address = 6'd32;
        #10;
        #1;

        check_outputs(27'h0000000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        rom_address = 6'd45;
        #10;
        #1;

        check_outputs(27'h0000000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        rom_address = 6'd63;
        #10;
        #1;

        check_outputs(27'h0000000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        rom_address = 6'd10;
        #5;
        rom_address = 6'd20;
        #5;
        rom_address = 6'd30;
        #10;
        #1;

        check_outputs(27'h0000000);
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
        testcase006();
        testcase007();
        
        
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
        input [26:0] expected_rom_data;
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
