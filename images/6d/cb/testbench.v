`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] w_bus_mux_in_0;
    reg [7:0] w_bus_mux_in_1;
    reg w_channel;
    wire [7:0] w_bus_mux_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .w_bus_mux_in_0(w_bus_mux_in_0),
        .w_bus_mux_in_1(w_bus_mux_in_1),
        .w_channel(w_channel),
        .w_bus_mux_out(w_bus_mux_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select Channel 0", test_num);
            w_bus_mux_in_0 = 8'hAA;
            w_bus_mux_in_1 = 8'h55;
            w_channel = 0;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select Channel 1", test_num);
            w_bus_mux_in_0 = 8'hAA;
            w_bus_mux_in_1 = 8'h55;
            w_channel = 1;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Zeros Selection", test_num);
            w_bus_mux_in_0 = 8'h00;
            w_bus_mux_in_1 = 8'hFF;
            w_channel = 0;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Ones Selection", test_num);
            w_bus_mux_in_0 = 8'h00;
            w_bus_mux_in_1 = 8'hFF;
            w_channel = 1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mixed bits Selection (0)", test_num);
            w_bus_mux_in_0 = 8'hF0;
            w_bus_mux_in_1 = 8'h0F;
            w_channel = 0;
            #1;

            check_outputs(8'hF0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mixed bits Selection (1)", test_num);
            w_bus_mux_in_0 = 8'h12;
            w_bus_mux_in_1 = 8'h34;
            w_channel = 1;
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
        input [7:0] expected_w_bus_mux_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_w_bus_mux_out === (expected_w_bus_mux_out ^ w_bus_mux_out ^ expected_w_bus_mux_out)) begin
                $display("PASS");
                $display("  Outputs: w_bus_mux_out=%h",
                         w_bus_mux_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: w_bus_mux_out=%h",
                         expected_w_bus_mux_out);
                $display("  Got:      w_bus_mux_out=%h",
                         w_bus_mux_out);
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
