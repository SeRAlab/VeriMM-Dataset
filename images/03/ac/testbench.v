`timescale 1ns/1ps

module gpio_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] gpio_cmd;
    reg [3:0] gpio_in;
    reg reset;
    wire [3:0] gpio_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gpio_controller dut (
        .clk(clk),
        .gpio_cmd(gpio_cmd),
        .gpio_in(gpio_in),
        .reset(reset),
        .gpio_out(gpio_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        gpio_cmd = CMD_IDLE;
        gpio_in = 4'h0;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase 001: Initial Reset State");
        reset_dut();
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase 002: Set Operation");
        reset_dut();
        gpio_cmd = CMD_SET;
        gpio_in  = 4'b1010;
        @(posedge clk);
        #1 gpio_cmd = CMD_IDLE;
        #1;

        check_outputs(4'b1010);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase 003: Clear Operation");
        reset_dut();

        gpio_cmd = CMD_WRITE;
        gpio_in  = 4'b1111;
        @(posedge clk);

        #1 gpio_cmd = CMD_CLEAR;
        gpio_in  = 4'b0011;
        @(posedge clk);
        #1 gpio_cmd = CMD_IDLE;
        #1;

        check_outputs(4'b1100);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase 004: Toggle Operation");
        reset_dut();

        gpio_cmd = CMD_WRITE;
        gpio_in  = 4'b1010;
        @(posedge clk);

        #1 gpio_cmd = CMD_TOGGLE;
        gpio_in  = 4'b1111;
        @(posedge clk);
        #1 gpio_cmd = CMD_IDLE;
        #1;

        check_outputs(4'b0101);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase 005: Direct Write Operation");
        reset_dut();
        gpio_cmd = CMD_WRITE;
        gpio_in  = 4'h7;
        @(posedge clk);
        #1 gpio_cmd = CMD_IDLE;
        #1;

        check_outputs(4'h7);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase 006: Bitwise Independence");
        reset_dut();

        gpio_cmd = CMD_SET;
        gpio_in  = 4'b0001;
        @(posedge clk);

        #1 gpio_cmd = CMD_SET;
        gpio_in  = 4'b0100;
        @(posedge clk);

        #1 gpio_cmd = CMD_TOGGLE;
        gpio_in  = 4'b0001;
        @(posedge clk);
        #1 gpio_cmd = CMD_IDLE;
        #1;

        check_outputs(4'b0100);
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
        input [3:0] expected_gpio_out;
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
        $dumpvars(0,clk, gpio_cmd, gpio_in, reset, gpio_out);
    end

endmodule
