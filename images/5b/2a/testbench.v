`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] i_data;
    reg i_oe;
    wire [7:0] o_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_data(i_data),
        .i_oe(i_oe),
        .o_data(o_data)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Enable high, data 0xAA", test_num);
            i_oe = 1'b1;
            i_data = 8'hAA;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Enable low, data 0xAA", test_num);
            i_oe = 1'b0;
            i_data = 8'hAA;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Enable high, data 0x55", test_num);
            i_oe = 1'b1;
            i_data = 8'h55;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Enable low, data 0x55", test_num);
            i_oe = 1'b0;
            i_data = 8'h55;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Enable high, data 0xFF", test_num);
            i_oe = 1'b1;
            i_data = 8'hFF;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Enable low, data 0xFF", test_num);
            i_oe = 1'b0;
            i_data = 8'hFF;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Enable high, data 0x00", test_num);
            i_oe = 1'b1;
            i_data = 8'h00;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Enable low, data 0x00", test_num);
            i_oe = 1'b0;
            i_data = 8'h00;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Enable high, data 0x12", test_num);
            i_oe = 1'b1;
            i_data = 8'h12;
            #1;

            check_outputs(8'h12);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: Enable high, change data while enabled", test_num);
            i_oe = 1'b1;
            i_data = 8'h34;
            #1;

            check_outputs(8'h34);
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
        testcase010();
        
        
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
        input [7:0] expected_o_data;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o_data === (expected_o_data ^ o_data ^ expected_o_data)) begin
                $display("PASS");
                $display("  Outputs: o_data=%h",
                         o_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_data=%h",
                         expected_o_data);
                $display("  Got:      o_data=%h",
                         o_data);
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
