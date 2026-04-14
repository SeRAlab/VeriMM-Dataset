`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] height;
    reg mode;
    reg on_off;
    reg [8:0] ram_address;
    reg rst;
    wire [47:0] ram_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .height(height),
        .mode(mode),
        .on_off(on_off),
        .ram_address(ram_address),
        .rst(rst),
        .ram_data(ram_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            height = 0;
            mode = 0;
            on_off = 0;
            ram_address = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            mode = 0;
            on_off = 0;
            ram_address = 9'h0A;

            #1;


            check_outputs(48'h0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            mode = 0;
            on_off = 1;
            ram_address = 9'h1FF;


            #1;



            check_outputs(48'hFFFFFFFFFFFF);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            mode = 1;
            height = 4'h8;
            ram_address = 9'h005;


            #1;



            check_outputs(dut.ram_data);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            mode = 1;
            height = 4'h4;
            ram_address = 9'h0F0;
            #1;

            check_outputs(dut.ram_data);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            mode = 1;
            height = 4'hF;
            ram_address = 9'h1AA;
            #1;

            check_outputs(dut.ram_data);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            mode = 1;
            height = 4'h2;
            ram_address = 9'h001;
            @(posedge clk);
            mode = 0;
            on_off = 0;
            #1;

            check_outputs(48'h0);
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
        input [47:0] expected_ram_data;
        begin
            if (expected_ram_data === (expected_ram_data ^ ram_data ^ expected_ram_data)) begin
                $display("PASS");
                $display("  Outputs: ram_data=%h",
                         ram_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ram_data=%h",
                         expected_ram_data);
                $display("  Got:      ram_data=%h",
                         ram_data);
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
        $dumpvars(0,clk, height, mode, on_off, ram_address, rst, ram_data);
    end

endmodule
