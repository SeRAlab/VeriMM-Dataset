`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] BTN;
    reg [31:0] Cpu_data2bus;
    reg [7:0] SW;
    reg [31:0] addr_bus;
    reg clk;
    reg counter0_out;
    reg counter1_out;
    reg counter2_out;
    reg [31:0] counter_out;
    reg [7:0] led_out;
    reg mem_w;
    reg [31:0] ram_data_out;
    reg rst;
    wire [31:0] Cpu_data4bus;
    wire GPIOe0000000_we;
    wire GPIOf0000000_we;
    wire [31:0] Peripheral_in;
    wire counter_we;
    wire data_ram_we;
    wire [9:0] ram_addr;
    wire [31:0] ram_data_in;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .BTN(BTN),
        .Cpu_data2bus(Cpu_data2bus),
        .SW(SW),
        .addr_bus(addr_bus),
        .clk(clk),
        .counter0_out(counter0_out),
        .counter1_out(counter1_out),
        .counter2_out(counter2_out),
        .counter_out(counter_out),
        .led_out(led_out),
        .mem_w(mem_w),
        .ram_data_out(ram_data_out),
        .rst(rst),
        .Cpu_data4bus(Cpu_data4bus),
        .GPIOe0000000_we(GPIOe0000000_we),
        .GPIOf0000000_we(GPIOf0000000_we),
        .Peripheral_in(Peripheral_in),
        .counter_we(counter_we),
        .data_ram_we(data_ram_we),
        .ram_addr(ram_addr),
        .ram_data_in(ram_data_in)
    );
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            addr_bus = 32'h0000_0008;
            mem_w = 1;
            Cpu_data2bus = 32'hABCD_1234;

            #1;


            check_outputs(32'h0, 0, 0, 32'hABCD_1234, 0, 1, 10'h002, 32'hABCD_1234);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            addr_bus = 32'h0000_000C;
            mem_w = 0;
            ram_data_out = 32'h55AA_55AA;

            #1;


            check_outputs(32'h55AA_55AA, 0, 0, 32'h0, 0, 0, 10'h003, 32'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            addr_bus = 32'hE000_0000;
            mem_w = 1;
            Cpu_data2bus = 32'h0000_00FF;

            #1;


            check_outputs(32'h0, 1, 0, 32'h0000_00FF, 0, 0, 10'h0, 32'h0000_00FF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            addr_bus = 32'hD000_0000;
            mem_w = 1;
            Cpu_data2bus = 32'h0000_FFFF;

            #1;


            check_outputs(32'h0, 0, 0, 32'h0000_FFFF, 1, 0, 10'h0, 32'h0000_FFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            addr_bus = 32'hD000_0000;
            mem_w = 0;
            counter_out = 32'h1234_5678;

            #1;


            check_outputs(32'h1234_5678, 0, 0, 32'h0, 0, 0, 10'h0, 32'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            addr_bus = 32'hF000_0000;
            mem_w = 1;
            Cpu_data2bus = 32'h7777_8888;

            #1;


            check_outputs(32'h0, 0, 1, 32'h7777_8888, 0, 0, 10'h0, 32'h7777_8888);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            addr_bus = 32'hF000_0000;
            mem_w = 0;
            SW = 8'hA5;
            BTN = 4'h9;


            #5;
            if (Cpu_data4bus[11:0] == {SW, BTN}) begin
                $display("TC007 Read Peripheral: PASS");
                pass_count++;
            end else begin
                $display("TC007 Read Peripheral: FAIL (Got %h)", Cpu_data4bus);
                fail_count++;
            end
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
        testcase007();
        
        
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
        input [31:0] expected_Cpu_data4bus;
        input expected_GPIOe0000000_we;
        input expected_GPIOf0000000_we;
        input [31:0] expected_Peripheral_in;
        input expected_counter_we;
        input expected_data_ram_we;
        input [9:0] expected_ram_addr;
        input [31:0] expected_ram_data_in;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Cpu_data4bus === (expected_Cpu_data4bus ^ Cpu_data4bus ^ expected_Cpu_data4bus) &&
                expected_GPIOe0000000_we === (expected_GPIOe0000000_we ^ GPIOe0000000_we ^ expected_GPIOe0000000_we) &&
                expected_GPIOf0000000_we === (expected_GPIOf0000000_we ^ GPIOf0000000_we ^ expected_GPIOf0000000_we) &&
                expected_Peripheral_in === (expected_Peripheral_in ^ Peripheral_in ^ expected_Peripheral_in) &&
                expected_counter_we === (expected_counter_we ^ counter_we ^ expected_counter_we) &&
                expected_data_ram_we === (expected_data_ram_we ^ data_ram_we ^ expected_data_ram_we) &&
                expected_ram_addr === (expected_ram_addr ^ ram_addr ^ expected_ram_addr) &&
                expected_ram_data_in === (expected_ram_data_in ^ ram_data_in ^ expected_ram_data_in)) begin
                $display("PASS");
                $display("  Outputs: Cpu_data4bus=%h, GPIOe0000000_we=%b, GPIOf0000000_we=%b, Peripheral_in=%h, counter_we=%b, data_ram_we=%b, ram_addr=%h, ram_data_in=%h",
                         Cpu_data4bus, GPIOe0000000_we, GPIOf0000000_we, Peripheral_in, counter_we, data_ram_we, ram_addr, ram_data_in);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Cpu_data4bus=%h, GPIOe0000000_we=%b, GPIOf0000000_we=%b, Peripheral_in=%h, counter_we=%b, data_ram_we=%b, ram_addr=%h, ram_data_in=%h",
                         expected_Cpu_data4bus, expected_GPIOe0000000_we, expected_GPIOf0000000_we, expected_Peripheral_in, expected_counter_we, expected_data_ram_we, expected_ram_addr, expected_ram_data_in);
                $display("  Got:      Cpu_data4bus=%h, GPIOe0000000_we=%b, GPIOf0000000_we=%b, Peripheral_in=%h, counter_we=%b, data_ram_we=%b, ram_addr=%h, ram_data_in=%h",
                         Cpu_data4bus, GPIOe0000000_we, GPIOf0000000_we, Peripheral_in, counter_we, data_ram_we, ram_addr, ram_data_in);
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
