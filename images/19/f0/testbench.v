`timescale 1ns/1ps

module gpio_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg [2:0] mode;
    reg shift_enable;
    wire [7:0] gpio_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gpio_controller dut (
        .clk(clk),
        .data_in(data_in),
        .mode(mode),
        .shift_enable(shift_enable),
        .gpio_out(gpio_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        mode = 3'b000;
        data_in = 8'h00;
        shift_enable = 0;

        repeat(2) @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Running Testcase 001: Mode 000 (All Low)");
        mode = 3'b000;
        data_in = 8'hFF;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Running Testcase 002: Mode 001 (All High)");
        mode = 3'b001;
        data_in = 8'h00;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Running Testcase 003: Mode 010 (Data Pass-through)");
        mode = 3'b010;
        data_in = 8'hA5;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Running Testcase 004: Mode 011 (Inverted Data)");
        mode = 3'b011;
        data_in = 8'h5A;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase005;

    integer i;
    reg [7:0] shift_data;
    begin
        reset_dut();
        test_num = 5;
        $display("Running Testcase 005: Mode 100 (Shift Register 8 bits)");
        mode = 3'b100;
        shift_enable = 1;
        shift_data = 8'hD2;


        for (i = 7; i >= 0; i = i - 1) begin
            data_in[0] = shift_data[i];
            @(posedge clk);
            #1;
        end


        #1;



        check_outputs(8'hD2);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        $display("Running Testcase 006: Mode 100 (Shift Enable Gating)");
        mode = 3'b100;


        shift_enable = 1;
        data_in[0] = 1; @(posedge clk); #1;
        data_in[0] = 1; @(posedge clk); #1;
        data_in[0] = 0; @(posedge clk); #1;
        data_in[0] = 0; @(posedge clk); #1;


        shift_enable = 0;
        data_in[0] = 1; @(posedge clk); #1;
        data_in[0] = 1; @(posedge clk); #1;


        shift_enable = 1;
        data_in[0] = 0; @(posedge clk); #1;
        data_in[0] = 0; @(posedge clk); #1;
        data_in[0] = 1; @(posedge clk); #1;
        data_in[0] = 1; @(posedge clk); #1;



        #1;




        check_outputs(8'hC3);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("gpio_controller Testbench");
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
        input [7:0] expected_gpio_out;
        begin
            if (expected_gpio_out === (expected_gpio_out ^ gpio_out ^ expected_gpio_out)) begin
                $display("PASS");
                $display("  Outputs: gpio_out=%h",
                         gpio_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gpio_out=%h",
                         expected_gpio_out);
                $display("  Got:      gpio_out=%h",
                         gpio_out);
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
        $dumpvars(0,clk, data_in, mode, shift_enable, gpio_out);
    end

endmodule
