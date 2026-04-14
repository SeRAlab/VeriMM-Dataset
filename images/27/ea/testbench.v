`timescale 1ns/1ps

module gpio_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] gpio_pins;
    reg read_en;
    reg reset;
    wire [7:0] gpio_state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gpio_controller dut (
        .clk(clk),
        .gpio_pins(gpio_pins),
        .read_en(read_en),
        .reset(reset),
        .gpio_state(gpio_state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            read_en = 0;
            gpio_pins = 8'h00;
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
            $display("Testcase %0d: Verify reset state", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Basic read capture (8'hA5)", test_num);
            reset_dut();
            gpio_pins = 8'hA5;
            read_en = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hA5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Hold value when read_en is low", test_num);
            reset_dut();


            gpio_pins = 8'h55;
            read_en = 1;
            @(posedge clk);
            #1;


            read_en = 0;
            gpio_pins = 8'hAA;
            @(posedge clk);
            #1;


            #1;



            check_outputs(8'h55);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Sequential reads", test_num);
            reset_dut();


            gpio_pins = 8'h12;
            read_en = 1;
            @(posedge clk);
            #1;


            gpio_pins = 8'h34;
            @(posedge clk);
            #1;


            gpio_pins = 8'h78;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h78);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Toggle read_en high and low", test_num);
            reset_dut();


            gpio_pins = 8'hFF;
            read_en = 1;
            @(posedge clk);
            #1;


            read_en = 0;
            gpio_pins = 8'h00;
            @(posedge clk);
            #1;


            read_en = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Maximum and minimum values", test_num);
            reset_dut();

            gpio_pins = 8'hFF;
            read_en = 1;
            @(posedge clk);
            #1;

            gpio_pins = 8'h00;
            @(posedge clk);
            #1;

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
        input [7:0] expected_gpio_state;
        begin
            if (expected_gpio_state === (expected_gpio_state ^ gpio_state ^ expected_gpio_state)) begin
                $display("PASS");
                $display("  Outputs: gpio_state=%h",
                         gpio_state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gpio_state=%h",
                         expected_gpio_state);
                $display("  Got:      gpio_state=%h",
                         gpio_state);
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
        $dumpvars(0,clk, gpio_pins, read_en, reset, gpio_state);
    end

endmodule
