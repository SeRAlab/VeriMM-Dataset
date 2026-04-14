`timescale 1ns/1ps

module gpio_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg [7:0] set_pins;
    wire [7:0] read_pins;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gpio_controller dut (
        .clk(clk),
        .enable(enable),
        .set_pins(set_pins),
        .read_pins(read_pins)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst_n = 0;
        enable = 0;
        set_pins = 8'h00;
        @(posedge clk);
        #1;
        rst_n = 1;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Initial Reset State", test_num);
        reset_dut();
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Basic Write (Enable=1)", test_num);
        reset_dut();
        enable = 1;
        set_pins = 8'hAA;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'hAA);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Write Inhibit (Enable=0)", test_num);
        reset_dut();

        enable = 1;
        set_pins = 8'h55;
        @(posedge clk);
        #1;

        enable = 0;
        set_pins = 8'hFF;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h55);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: All Pins High", test_num);
        reset_dut();
        enable = 1;
        set_pins = 8'hFF;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Sequential Updates", test_num);
        reset_dut();
        enable = 1;
        set_pins = 8'h01; @(posedge clk); #1;
        set_pins = 8'h02; @(posedge clk); #1;
        set_pins = 8'h04; @(posedge clk); #1;
        set_pins = 8'h08; @(posedge clk); #1;
        #1;

        check_outputs(8'h08);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Mid-operation Reset", test_num);
        reset_dut();
        enable = 1;
        set_pins = 8'hC3;
        @(posedge clk);
        #1;
        rst_n = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h00);
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
        input [7:0] expected_read_pins;
        begin
            if (expected_read_pins === (expected_read_pins ^ read_pins ^ expected_read_pins)) begin
                $display("PASS");
                $display("  Outputs: read_pins=%h",
                         read_pins);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: read_pins=%h",
                         expected_read_pins);
                $display("  Got:      read_pins=%h",
                         read_pins);
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
        $dumpvars(0,clk, enable, set_pins, read_pins);
    end

endmodule
