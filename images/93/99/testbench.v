`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] gpio_io_i;
    reg s_axi_aclk;
    wire [3:0] scndry_vect_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .gpio_io_i(gpio_io_i),
        .s_axi_aclk(s_axi_aclk),
        .scndry_vect_out(scndry_vect_out)
    );

    // Clock generation (10ns period)
    initial begin
        s_axi_aclk = 0;
        forever #5 s_axi_aclk = ~s_axi_aclk;
    end

        task reset_dut;

        begin
            gpio_io_i = 4'b0000;
            repeat(5) @(posedge s_axi_aclk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running testcase%03d: Input 4'hA", test_num);
            reset_dut();
            @(negedge s_axi_aclk);
            gpio_io_i = 4'hA;

            repeat(3) @(posedge s_axi_aclk);
            #2;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running testcase%03d: Input 4'h5", test_num);
            reset_dut();
            @(negedge s_axi_aclk);
            gpio_io_i = 4'h5;
            repeat(3) @(posedge s_axi_aclk);
            #2;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running testcase%03d: Input 4'hF", test_num);
            reset_dut();
            @(negedge s_axi_aclk);
            gpio_io_i = 4'hF;
            repeat(3) @(posedge s_axi_aclk);
            #2;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running testcase%03d: Input 4'h0", test_num);

            gpio_io_i = 4'hF;
            repeat(5) @(posedge s_axi_aclk);
            @(negedge s_axi_aclk);
            gpio_io_i = 4'h0;
            repeat(3) @(posedge s_axi_aclk);
            #2;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running testcase%03d: Walking Bit 4'h8", test_num);
            reset_dut();
            @(negedge s_axi_aclk);
            gpio_io_i = 4'h8;
            repeat(3) @(posedge s_axi_aclk);
            #2;
            #1;

            check_outputs(4'h8);
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
        input [3:0] expected_scndry_vect_out;
        begin
            if (expected_scndry_vect_out === (expected_scndry_vect_out ^ scndry_vect_out ^ expected_scndry_vect_out)) begin
                $display("PASS");
                $display("  Outputs: scndry_vect_out=%h",
                         scndry_vect_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: scndry_vect_out=%h",
                         expected_scndry_vect_out);
                $display("  Got:      scndry_vect_out=%h",
                         scndry_vect_out);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,gpio_io_i, s_axi_aclk, scndry_vect_out);
    end

endmodule
