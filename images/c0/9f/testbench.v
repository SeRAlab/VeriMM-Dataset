`timescale 1ns/1ps

module wbgpio_tb;

    // Testbench signals (sequential circuit)
    reg i_clk;
    reg [15:0] i_gpio;
    reg i_wb_cyc;
    reg [31:0] i_wb_data;
    reg i_wb_stb;
    reg i_wb_we;
    wire [15:0] o_gpio;
    wire o_int;
    wire [31:0] o_wb_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    wbgpio dut (
        .i_clk(i_clk),
        .i_gpio(i_gpio),
        .i_wb_cyc(i_wb_cyc),
        .i_wb_data(i_wb_data),
        .i_wb_stb(i_wb_stb),
        .i_wb_we(i_wb_we),
        .o_gpio(o_gpio),
        .o_int(o_int),
        .o_wb_data(o_wb_data)
    );

    // Clock generation (10ns period)
    initial begin
        i_clk = 0;
        forever #5 i_clk = ~i_clk;
    end

    task reset_dut;
    //define reset task
    endtask
    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("wbgpio Testbench");
        $display("========================================");


        
        
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
        input [15:0] expected_o_gpio;
        input expected_o_int;
        input [31:0] expected_o_wb_data;
        begin
            if (expected_o_gpio === (expected_o_gpio ^ o_gpio ^ expected_o_gpio) &&
                expected_o_int === (expected_o_int ^ o_int ^ expected_o_int) &&
                expected_o_wb_data === (expected_o_wb_data ^ o_wb_data ^ expected_o_wb_data)) begin
                $display("PASS");
                $display("  Outputs: o_gpio=%h, o_int=%b, o_wb_data=%h",
                         o_gpio, o_int, o_wb_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_gpio=%h, o_int=%b, o_wb_data=%h",
                         expected_o_gpio, expected_o_int, expected_o_wb_data);
                $display("  Got:      o_gpio=%h, o_int=%b, o_wb_data=%h",
                         o_gpio, o_int, o_wb_data);
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
        $dumpvars(0,i_clk, i_gpio, i_wb_cyc, i_wb_data, i_wb_stb, i_wb_we, o_gpio, o_int, o_wb_data);
    end

endmodule
