`timescale 1ns/1ps

module GPIO_Controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg [3:0] gpio_data;
    wire [3:0] gpio_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    GPIO_Controller dut (
        .clk(clk),
        .enable(enable),
        .gpio_data(gpio_data),
        .gpio_output(gpio_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            enable = 0;
            gpio_data = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Latch data 4'hA with Enable=1", test_num);
            reset_dut();

            enable = 1;
            gpio_data = 4'hA;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Hold previous data 4'hA when Enable goes Low", test_num);
            reset_dut();


            enable = 1;
            gpio_data = 4'hA;
            @(posedge clk);
            #1;


            enable = 0;
            gpio_data = 4'h5;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'hA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Change data while Enable is High", test_num);
            reset_dut();

            enable = 1;
            gpio_data = 4'h3;
            @(posedge clk);
            #1;

            gpio_data = 4'hC;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'hC);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Data changes ignored when Enable=0", test_num);
            reset_dut();


            enable = 1;
            gpio_data = 4'hF;
            @(posedge clk);
            #1;


            enable = 0;
            @(posedge clk);
            #1;


            gpio_data = 4'h1; @(posedge clk);
            gpio_data = 4'h8; @(posedge clk);
            gpio_data = 4'hE; @(posedge clk);
            #1;

            #1;


            check_outputs(4'hF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Update output after re-enabling", test_num);
            reset_dut();


            enable = 1;
            gpio_data = 4'h1;
            @(posedge clk);
            #1;


            enable = 0;
            gpio_data = 4'h9;
            @(posedge clk);
            #1;


            enable = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'h9);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("GPIO_Controller Testbench");
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
        input [3:0] expected_gpio_output;
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
        $dumpvars(0,clk, enable, gpio_data, gpio_output);
    end

endmodule
