`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [5:0] bpldata;
    reg clk;
    reg clk28m;
    reg [11:0] data_in;
    reg [7:0] reg_address_in;
    wire [11:0] rgb;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bpldata(bpldata),
        .clk(clk),
        .clk28m(clk28m),
        .data_in(data_in),
        .reg_address_in(reg_address_in),
        .rgb(rgb)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            bpldata = 6'b0;
            data_in = 12'b0;
            reg_address_in = 8'h0;
            repeat(5) @(posedge clk);
        end
        endtask
    task write_color_reg;

        input [3:0] index;
        input [11:0] color;
        begin
            @(posedge clk);
            reg_address_in = 8'hC0 + index;
            data_in = color;
            @(posedge clk);
            reg_address_in = 8'h00;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            write_color_reg(4'h1, 12'hF00);

            bpldata = 6'b00_0001;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(12'hF00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            write_color_reg(4'h0, 12'h888);
            bpldata = 6'b00_0000;
            @(posedge clk);


            bpldata = 6'b01_1111;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(12'h88F);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            write_color_reg(4'h0, 12'h888);
            bpldata = 6'b00_0000;
            @(posedge clk);


            bpldata = 6'b10_0010;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(12'h288);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            write_color_reg(4'h0, 12'h888);
            bpldata = 6'b00_0000;
            @(posedge clk);


            bpldata = 6'b11_1010;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(12'h8A8);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            write_color_reg(4'h0, 12'h000);
            bpldata = 6'b00_0000; @(posedge clk);


            bpldata = 6'b10_1111; @(posedge clk);


            bpldata = 6'b11_1111; @(posedge clk);


            bpldata = 6'b01_1111;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(12'hFFF);
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
        input [11:0] expected_rgb;
        begin
            if (expected_rgb === (expected_rgb ^ rgb ^ expected_rgb)) begin
                $display("PASS");
                $display("  Outputs: rgb=%h",
                         rgb);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rgb=%h",
                         expected_rgb);
                $display("  Got:      rgb=%h",
                         rgb);
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
        $dumpvars(0,bpldata, clk, clk28m, data_in, reg_address_in, rgb);
    end

endmodule
