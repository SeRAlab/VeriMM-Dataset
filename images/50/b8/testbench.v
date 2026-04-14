`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg bus2ip_cs;
    reg bus2ip_rnw;
    reg [7:0] gpio_io_t;
    reg s_axi_aclk;
    wire GPIO_xferAck_i;
    wire [7:0] gpio_io_o;
    wire ip2bus_rdack_i;
    wire ip2bus_wrack_i_D1_reg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bus2ip_cs(bus2ip_cs),
        .bus2ip_rnw(bus2ip_rnw),
        .gpio_io_t(gpio_io_t),
        .s_axi_aclk(s_axi_aclk),
        .GPIO_xferAck_i(GPIO_xferAck_i),
        .gpio_io_o(gpio_io_o),
        .ip2bus_rdack_i(ip2bus_rdack_i),
        .ip2bus_wrack_i_D1_reg(ip2bus_wrack_i_D1_reg)
    );

    // Clock generation (10ns period)
    initial begin
        s_axi_aclk = 0;
        forever #5 s_axi_aclk = ~s_axi_aclk;
    end

        task reset_dut;

    begin
        bus2ip_cs = 0;
        bus2ip_rnw = 0;
        gpio_io_t = 8'h00;
        @(posedge s_axi_aclk);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("\nRunning Testcase %03d: Basic Write Operation", test_num);

        bus2ip_cs = 1;
        bus2ip_rnw = 0;
        gpio_io_t = 8'hA5;

        @(posedge s_axi_aclk);
        #2;


        #1;



        check_outputs(1'b1, 8'hA5, 1'b0, 1'b1);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("\nRunning Testcase %03d: Basic Read Operation", test_num);


        bus2ip_cs = 1;
        bus2ip_rnw = 0;
        gpio_io_t = 8'h3C;
        @(posedge s_axi_aclk);
        #1;


        bus2ip_rnw = 1;
        gpio_io_t = 8'hFF;
        @(posedge s_axi_aclk);
        #2;


        #1;



        check_outputs(1'b1, 8'h3C, 1'b1, 1'b0);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("\nRunning Testcase %03d: Idle State (CS=0)", test_num);

        bus2ip_cs = 0;
        bus2ip_rnw = 0;
        gpio_io_t = 8'hAA;

        @(posedge s_axi_aclk);
        #2;


        #1;



        check_outputs(1'b0, 8'h00, 1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("\nRunning Testcase %03d: Consecutive Write Operations", test_num);


        bus2ip_cs = 1;
        bus2ip_rnw = 0;
        gpio_io_t = 8'h11;
        @(posedge s_axi_aclk);
        #1;


        gpio_io_t = 8'h22;
        @(posedge s_axi_aclk);
        #2;


        #1;



        check_outputs(1'b1, 8'h22, 1'b0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("\nRunning Testcase %03d: Boundary Values", test_num);


        bus2ip_cs = 1;
        bus2ip_rnw = 0;
        gpio_io_t = 8'hFF;
        @(posedge s_axi_aclk);
        #1;


        gpio_io_t = 8'h00;
        @(posedge s_axi_aclk);
        #2;

        #1;


        check_outputs(1'b1, 8'h00, 1'b0, 1'b1);
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
        input expected_GPIO_xferAck_i;
        input [7:0] expected_gpio_io_o;
        input expected_ip2bus_rdack_i;
        input expected_ip2bus_wrack_i_D1_reg;
        begin
            if (expected_GPIO_xferAck_i === (expected_GPIO_xferAck_i ^ GPIO_xferAck_i ^ expected_GPIO_xferAck_i) &&
                expected_gpio_io_o === (expected_gpio_io_o ^ gpio_io_o ^ expected_gpio_io_o) &&
                expected_ip2bus_rdack_i === (expected_ip2bus_rdack_i ^ ip2bus_rdack_i ^ expected_ip2bus_rdack_i) &&
                expected_ip2bus_wrack_i_D1_reg === (expected_ip2bus_wrack_i_D1_reg ^ ip2bus_wrack_i_D1_reg ^ expected_ip2bus_wrack_i_D1_reg)) begin
                $display("PASS");
                $display("  Outputs: GPIO_xferAck_i=%b, gpio_io_o=%h, ip2bus_rdack_i=%b, ip2bus_wrack_i_D1_reg=%b",
                         GPIO_xferAck_i, gpio_io_o, ip2bus_rdack_i, ip2bus_wrack_i_D1_reg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: GPIO_xferAck_i=%b, gpio_io_o=%h, ip2bus_rdack_i=%b, ip2bus_wrack_i_D1_reg=%b",
                         expected_GPIO_xferAck_i, expected_gpio_io_o, expected_ip2bus_rdack_i, expected_ip2bus_wrack_i_D1_reg);
                $display("  Got:      GPIO_xferAck_i=%b, gpio_io_o=%h, ip2bus_rdack_i=%b, ip2bus_wrack_i_D1_reg=%b",
                         GPIO_xferAck_i, gpio_io_o, ip2bus_rdack_i, ip2bus_wrack_i_D1_reg);
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
        $dumpvars(0,bus2ip_cs, bus2ip_rnw, gpio_io_t, s_axi_aclk, GPIO_xferAck_i, gpio_io_o, ip2bus_rdack_i, ip2bus_wrack_i_D1_reg);
    end

endmodule
