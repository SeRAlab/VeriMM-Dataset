`timescale 1ns/1ps

module gpio_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] gpio_dir;
    reg [4:0] gpio_in;
    reg gpio_write_en;
    reg rst;
    wire [4:0] gpio_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gpio_controller dut (
        .clk(clk),
        .gpio_dir(gpio_dir),
        .gpio_in(gpio_in),
        .gpio_write_en(gpio_write_en),
        .rst(rst),
        .gpio_data(gpio_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        gpio_dir = 5'b0;
        gpio_in = 5'b0;
        gpio_write_en = 0;
        @(posedge clk);
        #2 rst = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: All Inputs", test_num);
        reset_dut();


        gpio_dir = 5'b00000;
        gpio_in = 5'b10101;
        gpio_write_en = 0;

        @(posedge clk);
        #1;

        #1;


        check_outputs(5'b10101);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: All Outputs Write/Read", test_num);
        reset_dut();


        gpio_dir = 5'b11111;

        gpio_in = 5'b11011;
        gpio_write_en = 1;

        @(posedge clk);
        #1;
        gpio_write_en = 0;
        gpio_in = 5'b00000;

        #1;
        #1;

        check_outputs(5'b11011);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Mixed Directions", test_num);
        reset_dut();


        gpio_dir = 5'b10101;


        gpio_in = 5'b11111;
        gpio_write_en = 1;
        @(posedge clk);
        #1;


        gpio_write_en = 0;
        gpio_in = 5'b00000;

        #1;


        #1;



        check_outputs(5'b10101);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Write Enable Check", test_num);
        reset_dut();

        gpio_dir = 5'b11111;
        gpio_in = 5'b11111;
        gpio_write_en = 0;

        @(posedge clk);
        #1;

        #1;


        check_outputs(5'b00000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Dynamic Direction Change", test_num);
        reset_dut();


        gpio_dir = 5'b11111;
        gpio_in = 5'b10101;
        gpio_write_en = 1;
        @(posedge clk);
        #1;
        gpio_write_en = 0;


        gpio_dir = 5'b00000;
        gpio_in = 5'b01010;

        #1;

        #1;


        check_outputs(5'b01010);
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
        input [4:0] expected_gpio_data;
        begin
            if (expected_gpio_data === (expected_gpio_data ^ gpio_data ^ expected_gpio_data)) begin
                $display("PASS");
                $display("  Outputs: gpio_data=%h",
                         gpio_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gpio_data=%h",
                         expected_gpio_data);
                $display("  Got:      gpio_data=%h",
                         gpio_data);
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
        $dumpvars(0,clk, gpio_dir, gpio_in, gpio_write_en, rst, gpio_data);
    end

endmodule
