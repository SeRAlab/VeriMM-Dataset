`timescale 1ns/1ps

module gpio_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg pin_value;
    reg reset;
    reg set_pin;
    wire gpio_pin;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gpio_controller dut (
        .clk(clk),
        .pin_value(pin_value),
        .reset(reset),
        .set_pin(set_pin),
        .gpio_pin(gpio_pin)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            pin_value = 0;
            set_pin = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Set Pin High", test_num);
            reset_dut();
            pin_value = 1;
            set_pin = 1;
            @(posedge clk);
            #1;
            set_pin = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Set Pin Low", test_num);
            reset_dut();

            pin_value = 1;
            set_pin = 1;
            @(posedge clk);
            #1;

            pin_value = 0;
            set_pin = 1;
            @(posedge clk);
            #1;
            set_pin = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Value Retention (set_pin=0)", test_num);
            reset_dut();

            pin_value = 1;
            set_pin = 1;
            @(posedge clk);
            #1;

            pin_value = 0;
            set_pin = 0;
            @(posedge clk);
            #1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Toggle Behavior", test_num);
            reset_dut();

            pin_value = 1; set_pin = 1; @(posedge clk); #1;
            pin_value = 0; set_pin = 1; @(posedge clk); #1;
            pin_value = 1; set_pin = 1; @(posedge clk); #1;
            set_pin = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Asynchronous Reset During Operation", test_num);
            reset_dut();
            pin_value = 1;
            set_pin = 1;
            @(posedge clk);
            #1;

            reset = 1;
            #2;
            reset = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0);
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
        $dumpvars(0,clk, pin_value, reset, set_pin, gpio_pin);
    end

endmodule
