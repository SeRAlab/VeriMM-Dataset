`timescale 1ns/1ps

module gpio_controller_tb;

    // Testbench signals (sequential circuit)
    reg enable;
    reg [3:0] gpio_in;
    wire [3:0] gpio_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gpio_controller dut (
        .enable(enable),
        .gpio_in(gpio_in),
        .gpio_out(gpio_out)
    );

    // Clock generation (10ns period)
    initial begin
        enable = 0;
        forever #5 enable = ~enable;
    end

        task reset_dut;

        begin
            gpio_in = 4'b0000;

            @(posedge enable);
            #1;
            @(negedge enable);
            #1;
            $display("Reset Task: gpio_in initialized to 0 and captured.");
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Read - Enable High", test_num);
            reset_dut();


            gpio_in = 4'b1010;
            wait(enable == 1);
            #2;

            #1;


            check_outputs(4'b1010);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Hold Value - Enable Low", test_num);
            reset_dut();


            gpio_in = 4'b0101;
            wait(enable == 1);
            #1;


            wait(enable == 0);
            #1;


            gpio_in = 4'b1111;
            #2;


            #1;



            check_outputs(4'b0101);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All Pins High", test_num);
            reset_dut();

            gpio_in = 4'b1111;
            wait(enable == 1);
            #2;

            #1;


            check_outputs(4'b1111);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Transition from High to Low", test_num);
            reset_dut();


            gpio_in = 4'b1111;
            @(posedge enable);
            #1;
            @(negedge enable);


            gpio_in = 4'b0000;
            @(posedge enable);
            #2;

            #1;


            check_outputs(4'b0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Transparency Check (Change while Enable is High)", test_num);
            reset_dut();

            wait(enable == 1);
            #1;
            gpio_in = 4'b0011;
            #1;
            gpio_in = 4'b1100;
            #1;


            #1;



            check_outputs(4'b1100);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Long Term Retention", test_num);
            reset_dut();


            gpio_in = 4'h9;
            wait(enable == 1);
            #1;
            wait(enable == 0);


            gpio_in = 4'h0;
            #10;
            gpio_in = 4'hF;
            #10;
            gpio_in = 4'h5;
            #5;


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
        $dumpvars(0,enable, gpio_in, gpio_out);
    end

endmodule
