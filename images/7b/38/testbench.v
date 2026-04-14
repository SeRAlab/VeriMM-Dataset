`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [5:0] addr_i;
    reg clk;
    reg [23:0] data_i;
    reg rst;
    reg we_i;
    wire [23:0] data_o;
    wire [5:0] unread_ff;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr_i(addr_i),
        .clk(clk),
        .data_i(data_i),
        .rst(rst),
        .we_i(we_i),
        .data_o(data_o),
        .unread_ff(unread_ff)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            we_i = 0;
            data_i = 0;
            addr_i = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Reset State Verification");
            reset_dut();

            #1;


            check_outputs(24'h0, 6'd0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Single Write Operation");
            reset_dut();

            addr_i = 6'd0;
            data_i = 24'hABCDEF;
            we_i = 1;
            @(posedge clk);
            #1 we_i = 0;



            #1;




            check_outputs(24'hABCDEF, 6'd1);
        end
        endtask

    task testcase003;

        integer i;
        begin
            $display("Running testcase003: Multiple Writes");
            reset_dut();

            for (i = 0; i < 10; i = i + 1) begin
                addr_i = i;
                data_i = 24'h1000 + i;
                we_i = 1;
                @(posedge clk);
            end
            #1 we_i = 0;



            #1;




            check_outputs(24'h1000, 6'd10);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Specific Address Write");
            reset_dut();

            addr_i = 6'd32;
            data_i = 24'h55AAAA;
            we_i = 1;
            @(posedge clk);
            #1 we_i = 0;



            #1;




            check_outputs(24'h000000, 6'd1);
        end
        endtask

    task testcase005;

        integer i;
        begin
            $display("Running testcase005: Maximum Capacity / Wrap Check");
            reset_dut();


            for (i = 0; i < 63; i = i + 1) begin
                addr_i = i;
                data_i = i;
                we_i = 1;
                @(posedge clk);
            end
            #1 we_i = 0;

            #1;


            check_outputs(24'h0, 6'd63);
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
        input [23:0] expected_data_o;
        input [5:0] expected_unread_ff;
        begin
            if (expected_data_o === (expected_data_o ^ data_o ^ expected_data_o) &&
                expected_unread_ff === (expected_unread_ff ^ unread_ff ^ expected_unread_ff)) begin
                $display("PASS");
                $display("  Outputs: data_o=%h, unread_ff=%h",
                         data_o, unread_ff);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_o=%h, unread_ff=%h",
                         expected_data_o, expected_unread_ff);
                $display("  Got:      data_o=%h, unread_ff=%h",
                         data_o, unread_ff);
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
        $dumpvars(0,addr_i, clk, data_i, rst, we_i, data_o, unread_ff);
    end

endmodule
