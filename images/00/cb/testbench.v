`timescale 1ns/1ps

module gpio_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] gpio_in;
    reg latch;
    reg reset;
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
            @(posedge clk);
            reset = 1;
            gpio_in = 4'b0000;
            latch = 0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Synchronous Reset Check");
            test_num = 1;
            reset = 1;
            gpio_in = 4'hA;
            latch = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Normal Input Propagation");
            test_num = 2;
            reset_dut();

            gpio_in = 4'h5;
            latch = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Latch Mechanism");
            test_num = 3;
            reset_dut();


            gpio_in = 4'hC;
            latch = 0;
            @(posedge clk);


            #1;
            latch = 1;
            gpio_in = 4'hF;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'hC);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Latch Release");
            test_num = 4;
            reset_dut();


            gpio_in = 4'h3;
            latch = 1;
            @(posedge clk);


            #1;
            latch = 0;
            gpio_in = 4'h7;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'h7);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Reset Priority Over Latch");
            test_num = 5;
            reset_dut();


            gpio_in = 4'hB;
            latch = 0;
            @(posedge clk);


            #1;
            latch = 1;
            reset = 1;
            gpio_in = 4'hF;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'h0);
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
        $dumpvars(0,clk, gpio_in, latch, reset, gpio_out);
    end

endmodule
