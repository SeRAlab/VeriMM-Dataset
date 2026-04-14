`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] cd3;
    reg clk3;
    reg enable;
    reg [15:0] maxval;
    wire [31:0] addr_temp;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cd3(cd3),
        .clk3(clk3),
        .enable(enable),
        .maxval(maxval),
        .addr_temp(addr_temp)
    );

    // Clock generation (10ns period)
    initial begin
        clk3 = 0;
        forever #5 clk3 = ~clk3;
    end

        task reset_dut;

        begin
            enable = 0;
            cd3 = 0;
            maxval = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            enable = 1;
            maxval = 16'd100;
            cd3 = 16'd200;
            @(posedge clk3);
            #1;
            #1;

            check_outputs(32'd8);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            enable = 1;
            maxval = 16'd200;
            cd3 = 16'd100;
            @(posedge clk3);
            #1;
            #1;

            check_outputs(32'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            enable = 0;
            maxval = 16'd10;
            cd3 = 16'd50;
            repeat(5) @(posedge clk3);
            #1;
            #1;

            check_outputs(32'd0);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            reset_dut();
            enable = 1;
            maxval = 16'd10;
            cd3 = 16'd50;



            for (i = 0; i < 12; i = i + 1) begin
                @(posedge clk3);
            end
            #1;
            #1;

            check_outputs(32'd96);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            reset_dut();
            enable = 1;
            maxval = 16'd10;
            cd3 = 16'd50;
            for (i = 0; i < 5; i = i + 1) begin
                @(posedge clk3);
            end
            #1;
            #1;

            check_outputs(32'd8);
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
        input [31:0] expected_addr_temp;
        begin
            if (expected_addr_temp === (expected_addr_temp ^ addr_temp ^ expected_addr_temp)) begin
                $display("PASS");
                $display("  Outputs: addr_temp=%h",
                         addr_temp);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: addr_temp=%h",
                         expected_addr_temp);
                $display("  Got:      addr_temp=%h",
                         addr_temp);
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
        $dumpvars(0,cd3, clk3, enable, maxval, addr_temp);
    end

endmodule
