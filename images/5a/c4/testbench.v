`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] addr_b;
    reg clk;
    reg [31:0] data_b_in;
    reg [31:0] data_b_we;
    reg rst;
    wire [7:0] LED;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr_b(addr_b),
        .clk(clk),
        .data_b_in(data_b_in),
        .data_b_we(data_b_we),
        .rst(rst),
        .LED(LED)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            addr_b = 32'b0;
            data_b_in = 32'b0;
            data_b_we = 32'b0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Checking LED state after reset", test_num);
            reset_dut();
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Writing 0xA5 to LED address 0x0", test_num);
            reset_dut();

            addr_b = 32'h00000000;
            data_b_in = 32'h000000A5;
            data_b_we = 32'hFFFFFFFF;
            @(posedge clk);
            #2;


            addr_b = 32'h0;
            data_b_in = 32'h0;
            data_b_we = 32'h0;

            #1;


            check_outputs(8'hA5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Writing 0xFF to LED address 0x0", test_num);
            reset_dut();

            addr_b = 32'h00000000;
            data_b_in = 32'hFFFFFFFF;
            data_b_we = 32'hFFFFFFFF;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Writing to invalid address 0x100 (LEDs should stay 0)", test_num);
            reset_dut();

            addr_b = 32'h00000100;
            data_b_in = 32'h000000FF;
            data_b_we = 32'hFFFFFFFF;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Writing to address 0x0 with WE = 0 (LEDs should stay 0)", test_num);
            reset_dut();

            addr_b = 32'h00000000;
            data_b_in = 32'h000000AA;
            data_b_we = 32'h00000000;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Partial write using WE mask (lower bits 0x55, mask 0x0F)", test_num);
            reset_dut();


            addr_b = 32'h0;
            data_b_in = 32'h0;
            data_b_we = 32'hFFFFFFFF;
            @(posedge clk);
            #2;


            addr_b = 32'h0;
            data_b_in = 32'h000000FF;
            data_b_we = 32'h0000000F;
            @(posedge clk);
            #2;




            #1;





            check_outputs(8'h0F);
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
        input [7:0] expected_LED;
        begin
            if (expected_LED === (expected_LED ^ LED ^ expected_LED)) begin
                $display("PASS");
                $display("  Outputs: LED=%h",
                         LED);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: LED=%h",
                         expected_LED);
                $display("  Got:      LED=%h",
                         LED);
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
        $dumpvars(0,addr_b, clk, data_b_in, data_b_we, rst, LED);
    end

endmodule
