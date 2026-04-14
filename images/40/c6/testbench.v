`timescale 1ns/1ps

module gpio_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] gpio_input;
    reg mode;
    reg reset;
    wire [4:0] gpio_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gpio_controller dut (
        .clk(clk),
        .gpio_input(gpio_input),
        .mode(mode),
        .reset(reset),
        .gpio_output(gpio_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            mode = 0;
            gpio_input = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Initial Reset State");
            reset_dut();
            mode = 0;
            #5;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Basic Read and Write");
            reset_dut();

            mode = 1;
            gpio_input = 5'h15;
            @(posedge clk);
            #1;

            mode = 0;
            #5;
            #1;

            check_outputs(5'h15);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Output Mode Persistence");
            reset_dut();

            mode = 1;
            gpio_input = 5'h0A;
            @(posedge clk);
            #1;

            mode = 0;
            gpio_input = 5'h1F;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'h0A);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Successive Read Updates");
            reset_dut();
            mode = 1;
            gpio_input = 5'h01;
            @(posedge clk);
            #1;
            gpio_input = 5'h1E;
            @(posedge clk);
            #1;
            mode = 0;
            #5;
            #1;

            check_outputs(5'h1E);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: All High Pattern");
            reset_dut();
            mode = 1;
            gpio_input = 5'b11111;
            @(posedge clk);
            #1;
            mode = 0;
            #5;
            #1;

            check_outputs(5'b11111);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Async-style Reset during Load");
            reset_dut();
            mode = 1;
            gpio_input = 5'h12;
            @(posedge clk);
            #1;

            mode = 0;
            #2;

            reset = 1;
            #10;
            reset = 0;
            #5;
            #1;

            check_outputs(5'b00000);
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
        input [4:0] expected_gpio_output;
        begin
            if (expected_gpio_output === (expected_gpio_output ^ gpio_output ^ expected_gpio_output)) begin
                $display("PASS");
                $display("  Outputs: gpio_output=%h",
                         gpio_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gpio_output=%h",
                         expected_gpio_output);
                $display("  Got:      gpio_output=%h",
                         gpio_output);
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
        $dumpvars(0,clk, gpio_input, mode, reset, gpio_output);
    end

endmodule
