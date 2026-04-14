`timescale 1ns/1ps

module gpio_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] data_out;
    reg mode;
    reg rst;
    wire [4:0] data_in;
    wire [4:0] gpio_pins;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gpio_controller dut (
        .clk(clk),
        .data_out(data_out),
        .mode(mode),
        .rst(rst),
        .data_in(data_in),
        .gpio_pins(gpio_pins)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            mode = 0;
            data_out = 5'b0;
            tb_gpio_drive = 5'bz;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset Verification", test_num);
            reset_dut();

            tb_gpio_drive = 5'b00000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'b00000, 5'b00000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Output Mode - Writing 0x1F", test_num);
            reset_dut();
            mode = 1;
            data_out = 5'h1F;
            tb_gpio_drive = 5'bz;
            @(posedge clk);
            #1;

            #1;


            check_outputs(5'h1F, 5'h1F);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input Mode - Reading 0x0A", test_num);
            reset_dut();
            mode = 0;
            tb_gpio_drive = 5'h0A;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'h0A, 5'h0A);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Output Mode - Writing 0x15", test_num);
            reset_dut();
            mode = 1;
            data_out = 5'h15;
            tb_gpio_drive = 5'bz;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'h15, 5'h15);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mode Switching (Output -> Input)", test_num);
            reset_dut();


            mode = 1;
            data_out = 5'h0F;
            @(posedge clk);


            #1 mode = 0;
            tb_gpio_drive = 5'h10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'h10, 5'h10);
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
        input [4:0] expected_data_in;
        input [4:0] expected_gpio_pins;
        begin
            if (expected_data_in === (expected_data_in ^ data_in ^ expected_data_in) &&
                expected_gpio_pins === (expected_gpio_pins ^ gpio_pins ^ expected_gpio_pins)) begin
                $display("PASS");
                $display("  Outputs: data_in=%h, gpio_pins=%h",
                         data_in, gpio_pins);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_in=%h, gpio_pins=%h",
                         expected_data_in, expected_gpio_pins);
                $display("  Got:      data_in=%h, gpio_pins=%h",
                         data_in, gpio_pins);
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
        $dumpvars(0,clk, data_out, mode, rst, data_in, gpio_pins);
    end

endmodule
