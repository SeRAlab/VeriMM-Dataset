`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] bus_addr;
    reg [3:0] bus_be;
    reg bus_req;
    reg [31:0] bus_wdata;
    reg bus_we;
    reg clk_i;
    reg [15:0] gpio_bi;
    reg rst_i;
    wire bus_ack;
    wire [31:0] bus_rdata;
    wire bus_resp;
    wire [15:0] gpio_bo;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bus_addr(bus_addr),
        .bus_be(bus_be),
        .bus_req(bus_req),
        .bus_wdata(bus_wdata),
        .bus_we(bus_we),
        .clk_i(clk_i),
        .gpio_bi(gpio_bi),
        .rst_i(rst_i),
        .bus_ack(bus_ack),
        .bus_rdata(bus_rdata),
        .bus_resp(bus_resp),
        .gpio_bo(gpio_bo)
    );

    // Clock generation (10ns period)
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

        task reset_dut;

        begin
            rst_i = 1;
            bus_req = 0;
            bus_we = 0;
            bus_addr = 0;
            bus_wdata = 0;
            bus_be = 0;
            gpio_bi = 0;
            repeat (5) @(posedge clk_i);
            rst_i = 0;
            repeat (2) @(posedge clk_i);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset check", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 32'h0, 1'b0, 16'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Write to LED register", test_num);
            reset_dut();
            bus_write(32'h0, 32'hAAAA);

            #1;


            check_outputs(1'b0, 32'h0, 1'b0, 16'hAAAA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Read back LED register", test_num);
            reset_dut();
            bus_write(32'h0, 32'h5555);
            bus_read(32'h0);

            #1;


            check_outputs(1'b0, 32'h5555, 1'b0, 16'h5555);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Read physical input pins", test_num);
            reset_dut();
            gpio_bi = 16'h1234;
            bus_read(32'h4);

            #1;


            check_outputs(1'b0, 32'h1234, 1'b0, 16'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Multi-register write access", test_num);
            reset_dut();
            bus_write(32'hC, 32'hF0F0);

            #1;


            check_outputs(1'b0, 32'h0, 1'b0, 16'hF0F0);
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
        input expected_bus_ack;
        input [31:0] expected_bus_rdata;
        input expected_bus_resp;
        input [15:0] expected_gpio_bo;
        begin
            if (expected_bus_ack === (expected_bus_ack ^ bus_ack ^ expected_bus_ack) &&
                expected_bus_rdata === (expected_bus_rdata ^ bus_rdata ^ expected_bus_rdata) &&
                expected_bus_resp === (expected_bus_resp ^ bus_resp ^ expected_bus_resp) &&
                expected_gpio_bo === (expected_gpio_bo ^ gpio_bo ^ expected_gpio_bo)) begin
                $display("PASS");
                $display("  Outputs: bus_ack=%b, bus_rdata=%h, bus_resp=%b, gpio_bo=%h",
                         bus_ack, bus_rdata, bus_resp, gpio_bo);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bus_ack=%b, bus_rdata=%h, bus_resp=%b, gpio_bo=%h",
                         expected_bus_ack, expected_bus_rdata, expected_bus_resp, expected_gpio_bo);
                $display("  Got:      bus_ack=%b, bus_rdata=%h, bus_resp=%b, gpio_bo=%h",
                         bus_ack, bus_rdata, bus_resp, gpio_bo);
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
        $dumpvars(0,bus_addr, bus_be, bus_req, bus_wdata, bus_we, clk_i, gpio_bi, rst_i, bus_ack, bus_rdata, bus_resp, gpio_bo);
    end

endmodule
