`timescale 1ns/1ps

module gpio_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] direction;
    reg [4:0] read_enable;
    reg reset;
    reg [4:0] state;
    wire [4:0] gpio_in;
    wire [4:0] gpio_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gpio_controller dut (
        .clk(clk),
        .direction(direction),
        .read_enable(read_enable),
        .reset(reset),
        .state(state),
        .gpio_in(gpio_in),
        .gpio_out(gpio_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            direction = 5'b0;
            state = 5'b0;
            read_enable = 5'b0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset State Verification", test_num);
            reset_dut();

            #1;


            check_outputs(5'b00000, 5'b00000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: All Pins as Outputs High", test_num);
            reset_dut();
            direction = 5'b11111;
            state = 5'b11111;
            @(posedge clk);
            #2;

            #1;


            check_outputs(5'b00000, 5'b11111);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: All Pins as Outputs Low", test_num);
            reset_dut();
            direction = 5'b11111;
            state = 5'b10101;
            @(posedge clk);
            state = 5'b00000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(5'b00000, 5'b00000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Mixed Direction (Output: 0,2,4 | Input: 1,3)", test_num);
            reset_dut();
            direction = 5'b10101;
            state = 5'b11111;
            @(posedge clk);
            #2;


            #1;



            check_outputs(5'b00000, 5'b10101);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Read Enable Capture Test", test_num);
            reset_dut();
            direction = 5'b11111;
            state = 5'b01011;
            @(posedge clk);
            read_enable = 5'b11111;
            @(posedge clk);
            #2;

            #1;


            check_outputs(5'b01011, 5'b01011);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Partial Read Enable Test", test_num);
            reset_dut();
            direction = 5'b11111;
            state = 5'b11111;
            @(posedge clk);
            read_enable = 5'b00111;
            @(posedge clk);
            #2;

            #1;


            check_outputs(5'b00111, 5'b11111);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Dynamic Direction Change", test_num);
            reset_dut();
            direction = 5'b11111;
            state = 5'b11111;
            @(posedge clk);
            #2;
            direction = 5'b00000;
            @(posedge clk);
            #2;

            #1;


            check_outputs(5'b00000, 5'b00000);
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
        input [4:0] expected_gpio_in;
        input [4:0] expected_gpio_out;
        begin
            if (expected_gpio_in === (expected_gpio_in ^ gpio_in ^ expected_gpio_in) &&
                expected_gpio_out === (expected_gpio_out ^ gpio_out ^ expected_gpio_out)) begin
                $display("PASS");
                $display("  Outputs: gpio_in=%h, gpio_out=%h",
                         gpio_in, gpio_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gpio_in=%h, gpio_out=%h",
                         expected_gpio_in, expected_gpio_out);
                $display("  Got:      gpio_in=%h, gpio_out=%h",
                         gpio_in, gpio_out);
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
        $dumpvars(0,clk, direction, read_enable, reset, state, gpio_in, gpio_out);
    end

endmodule
