`timescale 1ns/1ps

module gpio_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] gpio_in;
    reg latch;
    reg update;
    wire [3:0] gpio_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gpio_controller dut (
        .clk(clk),
        .gpio_in(gpio_in),
        .latch(latch),
        .update(update),
        .gpio_out(gpio_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            test_num = test_num + 1;
            gpio_in = 4'b0;
            latch = 1'b0;
            update = 1'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            $display("Running Testcase 001: Basic Latch and Update...");


            gpio_in = 4'hA;
            latch = 1'b1;
            @(posedge clk);
            #1 latch = 1'b0;


            @(posedge clk);
            #1 update = 1'b1;
            @(posedge clk);
            #1 update = 1'b0;

            #1;


            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            $display("Running Testcase 002: Latch persistence...");


            gpio_in = 4'h5;
            latch = 1'b1;
            @(posedge clk);
            #1 latch = 1'b0;


            gpio_in = 4'hF;
            @(posedge clk);


            #1 update = 1'b1;
            @(posedge clk);
            #1 update = 1'b0;

            #1;


            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            $display("Running Testcase 003: Output Hold...");


            gpio_in = 4'h3;
            latch = 1'b1;
            @(posedge clk);
            #1 latch = 1'b0;
            update = 1'b1;
            @(posedge clk);
            #1 update = 1'b0;


            gpio_in = 4'hE;
            repeat(3) @(posedge clk);

            #1;


            check_outputs(4'h3);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            $display("Running Testcase 004: Simultaneous Latch and Update...");

            gpio_in = 4'hC;
            latch = 1'b1;
            update = 1'b1;
            @(posedge clk);
            #1;
            latch = 1'b0;
            update = 1'b0;

            #1;


            check_outputs(4'hC);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            $display("Running Testcase 005: Multiple Latches before Update...");


            gpio_in = 4'h1;
            latch = 1'b1;
            @(posedge clk);
            #1 latch = 1'b0;


            gpio_in = 4'h2;
            latch = 1'b1;
            @(posedge clk);
            #1 latch = 1'b0;


            update = 1'b1;
            @(posedge clk);
            #1 update = 1'b0;

            #1;


            check_outputs(4'h2);
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
        $dumpvars(0,clk, gpio_in, latch, update, gpio_out);
    end

endmodule
