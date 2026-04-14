`timescale 1ns/1ps

module gpio_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg control;
    reg [4:0] gpio_input;
    reg reset;
    wire [4:0] gpio_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gpio_controller dut (
        .clk(clk),
        .control(control),
        .gpio_input(gpio_input),
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
            control = 0;
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
            test_num = 1;
            $display("Testcase %0d: Check state after reset", test_num);
            reset_dut();

            #1;


            check_outputs(5'b00000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Set all bits", test_num);
            reset_dut();
            control = 1;
            gpio_input = 5'b11111;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'b11111);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Set individual bits (0 and 4)", test_num);
            reset_dut();
            control = 1;
            gpio_input = 5'b10001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'b10001);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Set all then Clear bits 1 and 2", test_num);
            reset_dut();

            control = 1;
            gpio_input = 5'b11111;
            @(posedge clk);
            #1;

            control = 0;
            gpio_input = 5'b00110;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'b11001);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Cumulative Set operations", test_num);
            reset_dut();

            control = 1;
            gpio_input = 5'b00001;
            @(posedge clk);
            #1;

            control = 1;
            gpio_input = 5'b00100;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'b00101);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Clear bits that are already low", test_num);
            reset_dut();
            control = 0;
            gpio_input = 5'b11111;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Set then clear the same bits", test_num);
            reset_dut();

            control = 1;
            gpio_input = 5'b01010;
            @(posedge clk);
            #1;

            control = 0;
            gpio_input = 5'b01010;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Control 1 with 0 input", test_num);
            reset_dut();

            control = 1;
            gpio_input = 5'b11000;
            @(posedge clk);
            #1;

            control = 1;
            gpio_input = 5'b00000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'b11000);
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
        testcase008();
        
        
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
        $dumpvars(0,clk, control, gpio_input, reset, gpio_output);
    end

endmodule
