`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg bus2ip_reset;
    reg bus2ip_rnw;
    reg [1:0] gpio_io_i;
    reg rst_reg;
    reg rst_reg_0;
    reg s_axi_aclk;
    reg [3:0] s_axi_wdata;
    wire GPIO_xferAck_i;
    wire [1:0] gpio_io_o;
    wire gpio_io_t_0;
    wire gpio_io_t_1;
    wire gpio_xferAck_Reg;
    wire ip2bus_rdack_i;
    wire ip2bus_wrack_i_D1_reg;
    wire [1:0] reg1;
    wire [1:0] reg2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bus2ip_reset(bus2ip_reset),
        .bus2ip_rnw(bus2ip_rnw),
        .gpio_io_i(gpio_io_i),
        .rst_reg(rst_reg),
        .rst_reg_0(rst_reg_0),
        .s_axi_aclk(s_axi_aclk),
        .s_axi_wdata(s_axi_wdata),
        .GPIO_xferAck_i(GPIO_xferAck_i),
        .gpio_io_o(gpio_io_o),
        .gpio_io_t_0(gpio_io_t_0),
        .gpio_io_t_1(gpio_io_t_1),
        .gpio_xferAck_Reg(gpio_xferAck_Reg),
        .ip2bus_rdack_i(ip2bus_rdack_i),
        .ip2bus_wrack_i_D1_reg(ip2bus_wrack_i_D1_reg),
        .reg1(reg1),
        .reg2(reg2)
    );

    // Clock generation (10ns period)
    initial begin
        s_axi_aclk = 0;
        forever #5 s_axi_aclk = ~s_axi_aclk;
    end

        task reset_dut;

        begin
            bus2ip_reset = 1;
            bus2ip_rnw = 0;
            gpio_io_i = 2'b00;
            rst_reg = 0;
            rst_reg_0 = 0;
            s_axi_wdata = 4'h0;
            @(posedge s_axi_aclk);
            #1;
            bus2ip_reset = 0;
            @(posedge s_axi_aclk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Initial Reset State Check");
            test_num = 1;
            reset_dut();


            #1;



            check_outputs(1'b0, 2'b00, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 2'b00, 2'b00);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Write Operation to GPIO Output");
            test_num = 2;
            reset_dut();

            bus2ip_rnw = 0;
            s_axi_wdata = 4'b0011;
            @(posedge s_axi_aclk);
            #2;


            #1;



            check_outputs(1'b1, 2'b11, 1'b0, 1'b0, 1'b1, 1'b0, 1'b1, 2'b00, 2'b00);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Read Operation from GPIO Input");
            test_num = 3;
            reset_dut();

            gpio_io_i = 2'b10;
            bus2ip_rnw = 1;
            @(posedge s_axi_aclk);
            #2;


            #1;



            check_outputs(1'b1, 2'b00, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 2'b10, 2'b10);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Local Register Reset (rst_reg)");
            test_num = 4;
            reset_dut();


            bus2ip_rnw = 0;
            s_axi_wdata = 4'b0010;
            @(posedge s_axi_aclk);
            #1;


            rst_reg = 1;
            @(posedge s_axi_aclk);
            #2;


            #1;



            check_outputs(1'b0, 2'b00, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 2'b00, 2'b00);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Tri-state Control Update");
            test_num = 5;
            reset_dut();

            bus2ip_rnw = 0;
            s_axi_wdata = 4'b1100;
            @(posedge s_axi_aclk);
            #2;


            #1;



            check_outputs(1'b1, 2'b00, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 2'b00, 2'b00);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Interleaved Read/Write Transaction");
            test_num = 6;
            reset_dut();


            bus2ip_rnw = 0;
            s_axi_wdata = 4'b0001;
            @(posedge s_axi_aclk);
            #1;


            bus2ip_rnw = 1;
            gpio_io_i = 2'b11;
            @(posedge s_axi_aclk);
            #2;


            #1;



            check_outputs(1'b1, 2'b01, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 2'b11, 2'b11);
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
        input expected_GPIO_xferAck_i;
        input [1:0] expected_gpio_io_o;
        input expected_gpio_io_t_0;
        input expected_gpio_io_t_1;
        input expected_gpio_xferAck_Reg;
        input expected_ip2bus_rdack_i;
        input expected_ip2bus_wrack_i_D1_reg;
        input [1:0] expected_reg1;
        input [1:0] expected_reg2;
        begin
            if (expected_GPIO_xferAck_i === (expected_GPIO_xferAck_i ^ GPIO_xferAck_i ^ expected_GPIO_xferAck_i) &&
                expected_gpio_io_o === (expected_gpio_io_o ^ gpio_io_o ^ expected_gpio_io_o) &&
                expected_gpio_io_t_0 === (expected_gpio_io_t_0 ^ gpio_io_t_0 ^ expected_gpio_io_t_0) &&
                expected_gpio_io_t_1 === (expected_gpio_io_t_1 ^ gpio_io_t_1 ^ expected_gpio_io_t_1) &&
                expected_gpio_xferAck_Reg === (expected_gpio_xferAck_Reg ^ gpio_xferAck_Reg ^ expected_gpio_xferAck_Reg) &&
                expected_ip2bus_rdack_i === (expected_ip2bus_rdack_i ^ ip2bus_rdack_i ^ expected_ip2bus_rdack_i) &&
                expected_ip2bus_wrack_i_D1_reg === (expected_ip2bus_wrack_i_D1_reg ^ ip2bus_wrack_i_D1_reg ^ expected_ip2bus_wrack_i_D1_reg) &&
                expected_reg1 === (expected_reg1 ^ reg1 ^ expected_reg1) &&
                expected_reg2 === (expected_reg2 ^ reg2 ^ expected_reg2)) begin
                $display("PASS");
                $display("  Outputs: GPIO_xferAck_i=%b, gpio_io_o=%h, gpio_io_t_0=%b, gpio_io_t_1=%b, gpio_xferAck_Reg=%b, ip2bus_rdack_i=%b, ip2bus_wrack_i_D1_reg=%b, reg1=%h, reg2=%h",
                         GPIO_xferAck_i, gpio_io_o, gpio_io_t_0, gpio_io_t_1, gpio_xferAck_Reg, ip2bus_rdack_i, ip2bus_wrack_i_D1_reg, reg1, reg2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: GPIO_xferAck_i=%b, gpio_io_o=%h, gpio_io_t_0=%b, gpio_io_t_1=%b, gpio_xferAck_Reg=%b, ip2bus_rdack_i=%b, ip2bus_wrack_i_D1_reg=%b, reg1=%h, reg2=%h",
                         expected_GPIO_xferAck_i, expected_gpio_io_o, expected_gpio_io_t_0, expected_gpio_io_t_1, expected_gpio_xferAck_Reg, expected_ip2bus_rdack_i, expected_ip2bus_wrack_i_D1_reg, expected_reg1, expected_reg2);
                $display("  Got:      GPIO_xferAck_i=%b, gpio_io_o=%h, gpio_io_t_0=%b, gpio_io_t_1=%b, gpio_xferAck_Reg=%b, ip2bus_rdack_i=%b, ip2bus_wrack_i_D1_reg=%b, reg1=%h, reg2=%h",
                         GPIO_xferAck_i, gpio_io_o, gpio_io_t_0, gpio_io_t_1, gpio_xferAck_Reg, ip2bus_rdack_i, ip2bus_wrack_i_D1_reg, reg1, reg2);
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
        $dumpvars(0,bus2ip_reset, bus2ip_rnw, gpio_io_i, rst_reg, rst_reg_0, s_axi_aclk, s_axi_wdata, GPIO_xferAck_i, gpio_io_o, gpio_io_t_0, gpio_io_t_1, gpio_xferAck_Reg, ip2bus_rdack_i, ip2bus_wrack_i_D1_reg, reg1, reg2);
    end

endmodule
