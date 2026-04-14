`timescale 1ns/1ps

module gpio_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] gpio_in;
    reg rst;
    reg write_enable;
    wire [4:0] gpio_out;
    wire write_success;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gpio_controller dut (
        .clk(clk),
        .gpio_in(gpio_in),
        .rst(rst),
        .write_enable(write_enable),
        .gpio_out(gpio_out),
        .write_success(write_success)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        write_enable = 0;
        gpio_in = 5'b0;
        @(posedge clk);
        #1;
        rst = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Verify Reset State", test_num);
        reset_dut();

        #1;


        check_outputs(5'b00000, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Basic Write Operation", test_num);
        reset_dut();

        gpio_in = 5'h15;
        write_enable = 1;
        @(posedge clk);
        #2;

        #1;


        check_outputs(5'h15, 1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Write Enable Low Verification", test_num);
        reset_dut();

        gpio_in = 5'h1F;
        write_enable = 0;
        @(posedge clk);
        #2;


        #1;



        check_outputs(5'h00, 0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Successive Writes", test_num);
        reset_dut();


        gpio_in = 5'h0A;
        write_enable = 1;
        @(posedge clk);
        #1;


        gpio_in = 5'h12;
        write_enable = 1;
        @(posedge clk);
        #2;

        #1;


        check_outputs(5'h12, 1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Boundary Value Write (All 1s)", test_num);
        reset_dut();

        gpio_in = 5'b11111;
        write_enable = 1;
        @(posedge clk);
        #2;

        #1;


        check_outputs(5'b11111, 1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Write and Hold", test_num);
        reset_dut();


        gpio_in = 5'h0E;
        write_enable = 1;
        @(posedge clk);
        #1;


        gpio_in = 5'h00;
        write_enable = 0;
        @(posedge clk);
        #2;


        #1;



        check_outputs(5'h0E, 0);
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
        input [4:0] expected_gpio_out;
        input expected_write_success;
        begin
            if (expected_gpio_out === (expected_gpio_out ^ gpio_out ^ expected_gpio_out) &&
                expected_write_success === (expected_write_success ^ write_success ^ expected_write_success)) begin
                $display("PASS");
                $display("  Outputs: gpio_out=%h, write_success=%b",
                         gpio_out, write_success);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gpio_out=%h, write_success=%b",
                         expected_gpio_out, expected_write_success);
                $display("  Got:      gpio_out=%h, write_success=%b",
                         gpio_out, write_success);
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
        $dumpvars(0,clk, gpio_in, rst, write_enable, gpio_out, write_success);
    end

endmodule
