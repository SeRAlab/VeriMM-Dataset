`timescale 1ns/1ps

module gpio_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] gpio_input;
    reg [3:0] gpio_out;
    wire [3:0] gpio_state_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gpio_controller dut (
        .clk(clk),
        .gpio_input(gpio_input),
        .gpio_out(gpio_out),
        .gpio_state_out(gpio_state_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            gpio_input = 4'b0000;
            gpio_out = 4'b0000;

            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Setting output to 4'hA", test_num);
            reset_dut();

            gpio_out = 4'hA;

            @(posedge clk);
            #1;

            #1;


            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Setting output to 4'h5", test_num);
            reset_dut();

            gpio_out = 4'h5;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Setting output to 4'hF", test_num);
            reset_dut();

            gpio_out = 4'hF;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'hF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Setting output to 4'h0", test_num);
            reset_dut();


            gpio_out = 4'hF;
            @(posedge clk);
            #1;

            gpio_out = 4'h0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Sequential output changes", test_num);
            reset_dut();

            gpio_out = 4'h1;
            @(posedge clk);
            #1;

            gpio_out = 4'h2;
            @(posedge clk);
            #1;

            gpio_out = 4'h4;
            @(posedge clk);
            #1;

            gpio_out = 4'h8;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'h8);
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
        input [3:0] expected_gpio_state_out;
        begin
            if (expected_gpio_state_out === (expected_gpio_state_out ^ gpio_state_out ^ expected_gpio_state_out)) begin
                $display("PASS");
                $display("  Outputs: gpio_state_out=%h",
                         gpio_state_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gpio_state_out=%h",
                         expected_gpio_state_out);
                $display("  Got:      gpio_state_out=%h",
                         gpio_state_out);
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
        $dumpvars(0,clk, gpio_input, gpio_out, gpio_state_out);
    end

endmodule
