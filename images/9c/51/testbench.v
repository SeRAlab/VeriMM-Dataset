`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg adc_rst;
    reg rx_clk;
    reg [63:0] rx_data;
    wire adc_clk;
    wire [31:0] adc_data_a;
    wire [31:0] adc_data_b;
    wire adc_or_a;
    wire adc_or_b;
    wire adc_status;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .adc_rst(adc_rst),
        .rx_clk(rx_clk),
        .rx_data(rx_data),
        .adc_clk(adc_clk),
        .adc_data_a(adc_data_a),
        .adc_data_b(adc_data_b),
        .adc_or_a(adc_or_a),
        .adc_or_b(adc_or_b),
        .adc_status(adc_status)
    );

    // Clock generation (10ns period)
    initial begin
        rx_clk = 0;
        forever #5 rx_clk = ~rx_clk;
    end

        task reset_dut;

        begin
            adc_rst = 1;
            rx_data = 64'h0;
            repeat(5) @(posedge rx_clk);
            #1;
            adc_rst = 0;
            repeat(2) @(posedge rx_clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Data Mapping", test_num);
            reset_dut();


            rx_data = 64'hA5A5A5A5_5A5A5A5A;

            repeat(2) @(posedge rx_clk);
            #1;


            #1;



            check_outputs(rx_clk, 32'h5A5A5A5A, 32'hA5A5A5A5, 0, 0, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternate Data Pattern", test_num);
            reset_dut();

            rx_data = 64'hFFFFFFFF_00000000;

            repeat(2) @(posedge rx_clk);
            #1;
            #1;

            check_outputs(rx_clk, 32'h00000000, 32'hFFFFFFFF, 0, 0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zeros Data Pattern", test_num);
            reset_dut();

            rx_data = 64'h00000000_00000000;

            repeat(2) @(posedge rx_clk);
            #1;
            #1;

            check_outputs(rx_clk, 32'h00000000, 32'h00000000, 0, 0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Status During Reset", test_num);

            adc_rst = 1;
            rx_data = 64'h12345678_9ABCDEF0;

            repeat(3) @(posedge rx_clk);
            #1;


            if (adc_status === 0) begin
                $display("PASS: Status is 0 during reset");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Status is %b during reset, expected 0", adc_status);
                fail_count = fail_count + 1;
            end

            adc_rst = 0;
            repeat(2) @(posedge rx_clk);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: High Speed Toggle", test_num);
            reset_dut();

            @(posedge rx_clk);
            rx_data = 64'h11111111_22222222;
            @(posedge rx_clk);
            rx_data = 32'h33333333_44444444;

            repeat(1) @(posedge rx_clk);
            #1;

            #1;


            check_outputs(rx_clk, 32'h44444444, 32'h33333333, 0, 0, 1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input expected_adc_clk;
        input [31:0] expected_adc_data_a;
        input [31:0] expected_adc_data_b;
        input expected_adc_or_a;
        input expected_adc_or_b;
        input expected_adc_status;
        begin
            if (expected_adc_clk === (expected_adc_clk ^ adc_clk ^ expected_adc_clk) &&
                expected_adc_data_a === (expected_adc_data_a ^ adc_data_a ^ expected_adc_data_a) &&
                expected_adc_data_b === (expected_adc_data_b ^ adc_data_b ^ expected_adc_data_b) &&
                expected_adc_or_a === (expected_adc_or_a ^ adc_or_a ^ expected_adc_or_a) &&
                expected_adc_or_b === (expected_adc_or_b ^ adc_or_b ^ expected_adc_or_b) &&
                expected_adc_status === (expected_adc_status ^ adc_status ^ expected_adc_status)) begin
                $display("PASS");
                $display("  Outputs: adc_clk=%b, adc_data_a=%h, adc_data_b=%h, adc_or_a=%b, adc_or_b=%b, adc_status=%b",
                         adc_clk, adc_data_a, adc_data_b, adc_or_a, adc_or_b, adc_status);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: adc_clk=%b, adc_data_a=%h, adc_data_b=%h, adc_or_a=%b, adc_or_b=%b, adc_status=%b",
                         expected_adc_clk, expected_adc_data_a, expected_adc_data_b, expected_adc_or_a, expected_adc_or_b, expected_adc_status);
                $display("  Got:      adc_clk=%b, adc_data_a=%h, adc_data_b=%h, adc_or_a=%b, adc_or_b=%b, adc_status=%b",
                         adc_clk, adc_data_a, adc_data_b, adc_or_a, adc_or_b, adc_status);
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
        $dumpvars(0,adc_rst, rx_clk, rx_data, adc_clk, adc_data_a, adc_data_b, adc_or_a, adc_or_b, adc_status);
    end

endmodule
