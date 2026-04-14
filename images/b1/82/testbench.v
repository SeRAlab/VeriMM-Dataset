`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] w_bus_mux_in_0;
    reg [1:0] w_bus_mux_in_1;
    reg [1:0] w_bus_mux_in_2;
    reg [1:0] w_bus_mux_in_3;
    reg [1:0] w_channel;
    wire [1:0] w_bus_mux_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .w_bus_mux_in_0(w_bus_mux_in_0),
        .w_bus_mux_in_1(w_bus_mux_in_1),
        .w_bus_mux_in_2(w_bus_mux_in_2),
        .w_bus_mux_in_3(w_bus_mux_in_3),
        .w_channel(w_channel),
        .w_bus_mux_out(w_bus_mux_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Select Channel 0", test_num);
            w_bus_mux_in_0 = 2'b11;
            w_bus_mux_in_1 = 2'b00;
            w_bus_mux_in_2 = 2'b00;
            w_bus_mux_in_3 = 2'b00;
            w_channel = 2'b00;
            #10;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Select Channel 1", test_num);
            w_bus_mux_in_0 = 2'b00;
            w_bus_mux_in_1 = 2'b10;
            w_bus_mux_in_2 = 2'b00;
            w_bus_mux_in_3 = 2'b00;
            w_channel = 2'b01;
            #10;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Select Channel 2", test_num);
            w_bus_mux_in_0 = 2'b00;
            w_bus_mux_in_1 = 2'b00;
            w_bus_mux_in_2 = 2'b01;
            w_bus_mux_in_3 = 2'b00;
            w_channel = 2'b10;
            #10;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Select Channel 3", test_num);
            w_bus_mux_in_0 = 2'b11;
            w_bus_mux_in_1 = 2'b10;
            w_bus_mux_in_2 = 2'b01;
            w_bus_mux_in_3 = 2'b00;
            w_channel = 2'b11;
            #10;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Verify isolation (Channel 0 selected, others changing)", test_num);
            w_bus_mux_in_0 = 2'b10;
            w_bus_mux_in_1 = 2'b11;
            w_bus_mux_in_2 = 2'b11;
            w_bus_mux_in_3 = 2'b11;
            w_channel = 2'b00;
            #5;

            w_bus_mux_in_1 = 2'b00;
            w_bus_mux_in_2 = 2'b01;
            w_bus_mux_in_3 = 2'b10;
            #5;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All inputs identical", test_num);
            w_bus_mux_in_0 = 2'b11;
            w_bus_mux_in_1 = 2'b11;
            w_bus_mux_in_2 = 2'b11;
            w_bus_mux_in_3 = 2'b11;
            w_channel = 2'b10;
            #10;
            #1;

            check_outputs(2'b11);
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
        input [1:0] expected_w_bus_mux_out;
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
