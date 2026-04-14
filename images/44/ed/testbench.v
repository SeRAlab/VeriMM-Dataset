`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] exposure;
    reg [4:0] rom_address;
    wire [35:0] rom_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .exposure(exposure),
        .rom_address(rom_address),
        .rom_data(rom_data)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Reading Address 0, Exposure 0", test_num);
            exposure = 16'h0000;
            rom_address = 5'd0;


            #10;
            #1;

            check_outputs(36'h0300805);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Reading Address 5, Exposure 0", test_num);
            exposure = 16'h0000;
            rom_address = 5'd5;
            #10;
            #1;

            check_outputs(36'h0300E01);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Testing Exposure Integration (Value 0x1234)", test_num);
            exposure = 16'h1234;
            rom_address = 5'd16;
            #10;

            #1;


            check_outputs(36'h030121234);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Testing Exposure Integration (Value 0xFFFF)", test_num);
            exposure = 16'hFFFF;
            rom_address = 5'd16;
            #10;
            #1;

            check_outputs(36'h03012FFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Reading Maximum Address (31)", test_num);
            exposure = 16'h0000;
            rom_address = 5'd31;
            #10;

            #1;


            check_outputs(36'h000000000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Verify static address 1 remains constant regardless of exposure", test_num);
            exposure = 16'hABCD;
            rom_address = 5'd1;
            #10;
            #1;

            check_outputs(36'h0300905);
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
        input [35:0] expected_rom_data;
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
