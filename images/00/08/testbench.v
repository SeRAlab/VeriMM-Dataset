`timescale 1ns/1ps

module gpio_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg ctrl;
    reg [7:0] data_in;
    reg [7:0] data_out;
    reg rst;
    wire [7:0] gpio;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gpio_controller dut (
        .clk(clk),
        .ctrl(ctrl),
        .data_in(data_in),
        .data_out(data_out),
        .rst(rst),
        .gpio(gpio)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            ctrl = 0;
            data_in = 8'h00;
            data_out = 8'h00;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Checking Reset State");
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Output Mode - Pattern 0xAA");
            reset_dut();
            ctrl = 1;
            data_out = 8'hAA;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Output Mode - Pattern 0x55");
            reset_dut();
            ctrl = 1;
            data_out = 8'h55;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Input Mode - Pattern 0xF0");
            reset_dut();
            ctrl = 0;
            data_in = 8'hF0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hF0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Input Mode - Pattern 0x0F");
            reset_dut();
            ctrl = 0;
            data_in = 8'h0F;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h0F);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase 006: Switching from Output to Input Mode");
            reset_dut();


            ctrl = 1;
            data_out = 8'hCC;
            @(posedge clk);


            ctrl = 0;
            data_in = 8'h33;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h33);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase 007: Verifying Reset overrides active signals");
            reset_dut();

            ctrl = 1;
            data_out = 8'hFF;
            @(posedge clk);

            rst = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase 008: Verifying data_in doesn't affect pins in Output mode");
            reset_dut();

            ctrl = 1;
            data_out = 8'h88;
            data_in = 8'h77;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h88);
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
        input [7:0] expected_gpio;
        begin
            if (expected_gpio === (expected_gpio ^ gpio ^ expected_gpio)) begin
                $display("PASS");
                $display("  Outputs: gpio=%h",
                         gpio);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gpio=%h",
                         expected_gpio);
                $display("  Got:      gpio=%h",
                         gpio);
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
        $dumpvars(0,clk, ctrl, data_in, data_out, rst, gpio);
    end

endmodule
