`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] gpio_sel;
    reg scl_o_in;
    reg scl_t_in;
    reg sda_o_in;
    reg sda_t_in;
    reg tri_i_out;
    reg tri_o_in;
    reg tri_t_in;
    wire scl_i_in;
    wire sda_i_in;
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
        .scl_o_in(scl_o_in),
        .scl_t_in(scl_t_in),
        .sda_o_in(sda_o_in),
        .sda_t_in(sda_t_in),
        .tri_i_out(tri_i_out),
        .tri_o_in(tri_o_in),
        .tri_t_in(tri_t_in),
        .scl_i_in(scl_i_in),
        .sda_i_in(sda_i_in),
        .tri_i_in(tri_i_in),
        .tri_o_out(tri_o_out),
        .tri_t_out(tri_t_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: GPIO Mode (00) - Select GPIO, Drive Pin High", test_num);

            gpio_sel = 2'b00;
            tri_o_in = 1'b1;
            tri_t_in = 1'b0;
            tri_i_out = 1'b1;

            sda_o_in = 1'b0; sda_t_in = 1'b1;
            scl_o_in = 1'b0; scl_t_in = 1'b1;

            #10;

            #1;


            check_outputs(1'b1, 1'b1, 1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: GPIO Mode (01) - Select GPIO, High-Z Mode", test_num);
            gpio_sel = 2'b01;
            tri_o_in = 1'b0;
            tri_t_in = 1'b1;
            tri_i_out = 1'b0;

            sda_o_in = 1'b1; sda_t_in = 1'b0;
            scl_o_in = 1'b1; scl_t_in = 1'b0;

            #10;

            #1;


            check_outputs(1'b1, 1'b1, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: SDA Mode (10) - Drive I2C Data Low", test_num);
            gpio_sel = 2'b10;
            sda_o_in = 1'b0;
            sda_t_in = 1'b0;
            tri_i_out = 1'b0;

            tri_o_in = 1'b1; tri_t_in = 1'b0;
            scl_o_in = 1'b1; scl_t_in = 1'b1;

            #10;

            #1;


            check_outputs(1'b1, 1'b0, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: SDA Mode (10) - High-Z Pin Monitor High", test_num);
            gpio_sel = 2'b10;
            sda_o_in = 1'b1;
            sda_t_in = 1'b1;
            tri_i_out = 1'b1;

            #10;

            #1;


            check_outputs(1'b1, 1'b1, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: SCL Mode (11) - Drive I2C Clock Low", test_num);
            gpio_sel = 2'b11;
            scl_o_in = 1'b0;
            scl_t_in = 1'b0;
            tri_i_out = 1'b0;

            tri_o_in = 1'b1; tri_t_in = 1'b0;
            sda_o_in = 1'b1; sda_t_in = 1'b0;

            #10;

            #1;


            check_outputs(1'b0, 1'b1, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: SCL Mode (11) - Verify SDA/GPIO inputs don't affect Pin Output", test_num);
            gpio_sel = 2'b11;
            scl_o_in = 1'b1;
            scl_t_in = 1'b0;
            tri_i_out = 1'b1;


            tri_o_in = 1'b0; tri_t_in = 1'b1;
            sda_o_in = 1'b0; sda_t_in = 1'b1;

            #10;

            #1;


            check_outputs(1'b1, 1'b1, 1'b1, 1'b1, 1'b0);
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
        input expected_scl_i_in;
        input expected_sda_i_in;
        input expected_tri_i_in;
        input expected_tri_o_out;
        input expected_tri_t_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_scl_i_in === (expected_scl_i_in ^ scl_i_in ^ expected_scl_i_in) &&
                expected_sda_i_in === (expected_sda_i_in ^ sda_i_in ^ expected_sda_i_in) &&
                expected_tri_i_in === (expected_tri_i_in ^ tri_i_in ^ expected_tri_i_in) &&
                expected_tri_o_out === (expected_tri_o_out ^ tri_o_out ^ expected_tri_o_out) &&
                expected_tri_t_out === (expected_tri_t_out ^ tri_t_out ^ expected_tri_t_out)) begin
                $display("PASS");
                $display("  Outputs: scl_i_in=%b, sda_i_in=%b, tri_i_in=%b, tri_o_out=%b, tri_t_out=%b",
                         scl_i_in, sda_i_in, tri_i_in, tri_o_out, tri_t_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: scl_i_in=%b, sda_i_in=%b, tri_i_in=%b, tri_o_out=%b, tri_t_out=%b",
                         expected_scl_i_in, expected_sda_i_in, expected_tri_i_in, expected_tri_o_out, expected_tri_t_out);
                $display("  Got:      scl_i_in=%b, sda_i_in=%b, tri_i_in=%b, tri_o_out=%b, tri_t_out=%b",
                         scl_i_in, sda_i_in, tri_i_in, tri_o_out, tri_t_out);
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
