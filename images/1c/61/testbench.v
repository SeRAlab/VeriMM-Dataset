`timescale 1ns/1ps

module gpio_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg reset;
    reg set;
    wire gpio_pin;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gpio_controller dut (
        .clk(clk),
        .enable(enable),
        .reset(reset),
        .set(set),
        .gpio_pin(gpio_pin)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            enable = 0;
            reset = 0;
            set = 0;
            @(posedge clk);

            enable = 1;
            reset = 1;
            @(posedge clk);
            #1;
            enable = 0;
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase001: Initial state after reset");
            reset_dut();

            @(posedge clk);
            #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase002: Set signal when enabled");
            reset_dut();
            enable = 1;
            set = 1;
            reset = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase003: Reset signal when enabled");
            reset_dut();

            enable = 1;
            set = 1;
            @(posedge clk);

            set = 0;
            reset = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase004: Priority check (Reset vs Set)");
            reset_dut();
            enable = 1;
            set = 1;
            reset = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase005: Enable gate blocking inputs");
            reset_dut();

            enable = 0;
            set = 1;
            reset = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase006: Maintaining state when disabled");
            reset_dut();

            enable = 1;
            set = 1;
            @(posedge clk);

            enable = 0;
            set = 0;
            reset = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase007: Hold last value with no active signals");
            reset_dut();
            enable = 1;
            set = 1;
            @(posedge clk);
            set = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1);
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
        input expected_gpio_pin;
        begin
            if (expected_gpio_pin === (expected_gpio_pin ^ gpio_pin ^ expected_gpio_pin)) begin
                $display("PASS");
                $display("  Outputs: gpio_pin=%b",
                         gpio_pin);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gpio_pin=%b",
                         expected_gpio_pin);
                $display("  Got:      gpio_pin=%b",
                         gpio_pin);
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
        $dumpvars(0,clk, enable, reset, set, gpio_pin);
    end

endmodule
