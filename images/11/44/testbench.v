`timescale 1ns/1ps

module gpio_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg control;
    reg [7:0] gpio_in;
    wire [7:0] gpio_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gpio_controller dut (
        .clk(clk),
        .control(control),
        .gpio_in(gpio_in),
        .gpio_out(gpio_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            control = 0;
            gpio_in = 8'h00;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running Testcase %03d: Basic Latch 0xAA", test_num);
            reset_dut();
            gpio_in = 8'hAA;
            @(posedge clk);
            control = 1;
            @(posedge clk);
            control = 0;
            @(posedge clk);
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Testcase %03d: Data Persistence (Control Low)", test_num);
            reset_dut();

            gpio_in = 8'h55;
            @(posedge clk);
            control = 1;
            @(posedge clk);
            control = 0;

            gpio_in = 8'hFF;
            @(posedge clk);
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Testcase %03d: Re-latching new value 0xF0", test_num);
            reset_dut();

            gpio_in = 8'h0F;
            @(posedge clk);
            control = 1;
            @(posedge clk);
            control = 0;

            gpio_in = 8'hF0;
            @(posedge clk);
            control = 1;
            @(posedge clk);
            control = 0;
            @(posedge clk);
            #1;

            check_outputs(8'hF0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Testcase %03d: Latching 0xFF", test_num);
            reset_dut();
            gpio_in = 8'hFF;
            @(posedge clk);
            control = 1;
            @(posedge clk);
            control = 0;
            @(posedge clk);
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Running Testcase %03d: Latching 0x00", test_num);
            reset_dut();

            gpio_in = 8'hEE;
            @(posedge clk);
            control = 1;
            @(posedge clk);

            gpio_in = 8'h00;
            @(posedge clk);
            control = 1;
            @(posedge clk);
            control = 0;
            @(posedge clk);
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
        $dumpvars(0,clk, control, gpio_in, gpio_out);
    end

endmodule
