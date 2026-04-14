`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg gpio_sel;
    reg tri_i_out;
    reg tri_o_in;
    reg tri_t_in;
    reg tx_o_in;
    reg tx_t_in;
    wire rx_i_in;
    wire tri_i_in;
    wire tri_o_out;
    wire tri_t_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .gpio_sel(gpio_sel),
        .tri_i_out(tri_i_out),
        .tri_o_in(tri_o_in),
        .tri_t_in(tri_t_in),
        .tx_o_in(tx_o_in),
        .tx_t_in(tx_t_in),
        .rx_i_in(rx_i_in),
        .tri_i_in(tri_i_in),
        .tri_o_out(tri_o_out),
        .tri_t_out(tri_t_out)
    );
    task testcase001;

        begin
            $display("Testcase 001: GPIO Mode (gpio_sel=1) - Routing high signals");

            gpio_sel = 0; tri_i_out = 1; tri_o_in = 0; tri_t_in = 0; tx_o_in = 0; tx_t_in = 0;
            #10;

            gpio_sel = 1;
            tri_o_in = 1;
            tri_t_in = 1;
            tri_i_out = 0;
            tx_o_in = 0;
            tx_t_in = 0;


            #1;



            check_outputs(1'b1, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: GPIO Mode (gpio_sel=1) - Routing low signals");

            gpio_sel = 0; tri_i_out = 1; tri_o_in = 1; tri_t_in = 1; tx_o_in = 1; tx_t_in = 1;
            #10;

            gpio_sel = 1;
            tri_o_in = 0;
            tri_t_in = 0;
            tri_i_out = 1;


            #1;



            check_outputs(1'b1, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: UART Mode (gpio_sel=0) - Routing high signals");

            gpio_sel = 1; tri_i_out = 1; tri_o_in = 0; tri_t_in = 0; tx_o_in = 0; tx_t_in = 0;
            #10;

            gpio_sel = 0;
            tx_o_in = 1;
            tx_t_in = 1;
            tri_i_out = 0;
            tri_o_in = 0;
            tri_t_in = 0;


            #1;



            check_outputs(1'b0, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: UART Mode (gpio_sel=0) - Routing low signals");

            gpio_sel = 1; tri_i_out = 1; tri_o_in = 1; tri_t_in = 1; tx_o_in = 1; tx_t_in = 1;
            #10;

            gpio_sel = 0;
            tx_o_in = 0;
            tx_t_in = 0;
            tri_i_out = 1;


            #1;



            check_outputs(1'b1, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: GPIO Mode - Verifying Isolation");

            gpio_sel = 1; tri_o_in = 1; tri_t_in = 0; tri_i_out = 1;
            #10;

            tx_o_in = 0;
            tx_t_in = 1;
            #5;



            #1;




            check_outputs(1'b1, 1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: UART Mode - Verifying Isolation");

            gpio_sel = 0; tx_o_in = 1; tx_t_in = 0; tri_i_out = 0;
            #10;

            tri_o_in = 0;
            tri_t_in = 1;
            #5;



            #1;




            check_outputs(1'b0, 1'b1, 1'b1, 1'b0);
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
        input expected_rx_i_in;
        input expected_tri_i_in;
        input expected_tri_o_out;
        input expected_tri_t_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_rx_i_in === (expected_rx_i_in ^ rx_i_in ^ expected_rx_i_in) &&
                expected_tri_i_in === (expected_tri_i_in ^ tri_i_in ^ expected_tri_i_in) &&
                expected_tri_o_out === (expected_tri_o_out ^ tri_o_out ^ expected_tri_o_out) &&
                expected_tri_t_out === (expected_tri_t_out ^ tri_t_out ^ expected_tri_t_out)) begin
                $display("PASS");
                $display("  Outputs: rx_i_in=%b, tri_i_in=%b, tri_o_out=%b, tri_t_out=%b",
                         rx_i_in, tri_i_in, tri_o_out, tri_t_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rx_i_in=%b, tri_i_in=%b, tri_o_out=%b, tri_t_out=%b",
                         expected_rx_i_in, expected_tri_i_in, expected_tri_o_out, expected_tri_t_out);
                $display("  Got:      rx_i_in=%b, tri_i_in=%b, tri_o_out=%b, tri_t_out=%b",
                         rx_i_in, tri_i_in, tri_o_out, tri_t_out);
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
