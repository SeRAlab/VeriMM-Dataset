`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] data_in;
    reg enable;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data_in(data_in),
        .enable(enable),
        .data_out(data_out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Enable LOW - Output should be zero", test_num);
            data_in = 8'hFF;
            enable = 1'b0;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Enable HIGH - Shift 0x01 (Result: 0x04)", test_num);
            data_in = 8'h01;
            enable = 1'b1;
            #1;

            check_outputs(8'h04);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Enable HIGH - Shift 0xFF (Result: 0xFC)", test_num);
            data_in = 8'hFF;
            enable = 1'b1;
            #1;

            check_outputs(8'hFC);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Enable HIGH - Shift 0xC0 (Result: 0x00, MSBs discarded)", test_num);
            data_in = 8'hC0;
            enable = 1'b1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Enable HIGH - Shift 0x55 (Result: 0x54)", test_num);
            data_in = 8'h55;
            enable = 1'b1;
            #1;

            check_outputs(8'h54);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Enable HIGH - Shift 0xAA (Result: 0xA8)", test_num);
            data_in = 8'hAA;
            enable = 1'b1;
            #1;

            check_outputs(8'hA8);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Enable HIGH - Shift 0x0F (Result: 0x3C)", test_num);
            data_in = 8'h0F;
            enable = 1'b1;
            #1;

            check_outputs(8'h3C);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Enable HIGH - Shift 0x00 (Result: 0x00)", test_num);
            data_in = 8'h00;
            enable = 1'b1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Enable LOW - Shift 0x33 with Enable toggled OFF (Result: 0x00)", test_num);
            data_in = 8'h33;
            enable = 1'b0;
            #1;

            check_outputs(8'h00);
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
        testcase008();
        testcase009();
        
        
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
        input [7:0] expected_data_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
