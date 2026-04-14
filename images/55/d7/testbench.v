`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] din;
    reg [5:0] id;
    reg read;
    reg write;
    wire [15:0] dout;
    wire gpio_pin1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .din(din),
        .id(id),
        .read(read),
        .write(write),
        .dout(dout),
        .gpio_pin1(gpio_pin1)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            read = 0;
            write = 0;
            id = 0;
            din = 0;
            @(posedge clk);

            write = 1;
            id = 6'd0;
            din = 16'h0000;
            @(posedge clk);
            write = 0;
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            @(posedge clk);
            write = 1;
            id = 6'd0;
            din = 16'hA5A5;
            @(posedge clk);
            write = 0;

            read = 1;
            id = 6'd0;
            @(posedge clk);
            #1;

            check_outputs(16'hA5A5, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();

            @(posedge clk);
            write = 1;
            id = 6'd5;
            din = 16'h1234;
            @(posedge clk);
            write = 0;

            read = 1;
            id = 6'd5;
            @(posedge clk);

            #1;


            check_outputs(16'h1234, 1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();

            @(posedge clk);
            write = 1;
            id = 6'd0;
            din = 16'h0001;
            @(posedge clk);
            write = 0;

            read = 0;
            #1;

            check_outputs(dout, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();

            @(posedge clk);
            write = 1;
            id = 6'd10;
            din = 16'hFFFF;
            @(posedge clk);
            write = 0;

            read = 0;
            id = 6'd10;
            @(posedge clk);


            #1;



            check_outputs(16'h0000, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();

            @(posedge clk);
            write = 0;
            id = 6'd1;
            din = 16'hEEEE;
            @(posedge clk);

            read = 1;
            id = 6'd1;
            @(posedge clk);

            #1;


            check_outputs(16'h0000, 1'b0);
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
        input [15:0] expected_dout;
        input expected_gpio_pin1;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_gpio_pin1 === (expected_gpio_pin1 ^ gpio_pin1 ^ expected_gpio_pin1)) begin
                $display("PASS");
                $display("  Outputs: dout=%h, gpio_pin1=%b",
                         dout, gpio_pin1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h, gpio_pin1=%b",
                         expected_dout, expected_gpio_pin1);
                $display("  Got:      dout=%h, gpio_pin1=%b",
                         dout, gpio_pin1);
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
        $dumpvars(0,clk, din, id, read, write, dout, gpio_pin1);
    end

endmodule
