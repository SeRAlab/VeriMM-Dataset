`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] MEM_DECODE_GEN_0_cs_out_i_reg_0;
    reg bus2ip_rnw_i_reg;
    reg [3:0] gpio_io_i;
    reg s_axi_aclk;
    wire [3:0] D;
    wire GPIO_xferAck_i;
    wire [3:0] Q;
    wire bus2ip_cs;
    wire bus2ip_rnw;
    wire [3:0] gpio_io_o;
    wire [3:0] gpio_io_t;
    wire gpio_xferAck_Reg;
    wire ip2bus_rdack_i;
    wire ip2bus_wrack_i_D1_reg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .MEM_DECODE_GEN_0_cs_out_i_reg_0(MEM_DECODE_GEN_0_cs_out_i_reg_0),
        .bus2ip_rnw_i_reg(bus2ip_rnw_i_reg),
        .gpio_io_i(gpio_io_i),
        .s_axi_aclk(s_axi_aclk),
        .D(D),
        .GPIO_xferAck_i(GPIO_xferAck_i),
        .Q(Q),
        .bus2ip_cs(bus2ip_cs),
        .bus2ip_rnw(bus2ip_rnw),
        .gpio_io_o(gpio_io_o),
        .gpio_io_t(gpio_io_t),
        .gpio_xferAck_Reg(gpio_xferAck_Reg),
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
            MEM_DECODE_GEN_0_cs_out_i_reg_0 = 4'b0000;
            bus2ip_rnw_i_reg = 1'b0;
            gpio_io_i = 4'b0000;
            @(posedge s_axi_aclk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();

            @(posedge s_axi_aclk);
            #1;
            #1;

            check_outputs(
                4'h0,
                1'b0,
                4'h0,
                1'b0,
                1'b0,
                4'h0,
                4'h0,
                1'b0,
                1'b0,
                1'b0
            );
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();

            gpio_io_i = 4'hA;
            bus2ip_rnw_i_reg = 1'b1;
            MEM_DECODE_GEN_0_cs_out_i_reg_0 = 4'b0001;

            @(posedge s_axi_aclk);
            #1;


            #1;



            check_outputs(
                4'hA,
                1'b1,
                4'h0,
                1'b1,
                1'b1,
                4'h0,
                4'h0,
                1'b1,
                1'b1,
                1'b0
            );
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();

            bus2ip_rnw_i_reg = 1'b0;
            MEM_DECODE_GEN_0_cs_out_i_reg_0 = 4'b0001;

            @(posedge s_axi_aclk);
            #1;


            #1;



            check_outputs(
                4'h0,
                1'b1,
                4'h0,
                1'b1,
                1'b0,
                4'h0,
                4'h0,
                1'b1,
                1'b0,
                1'b1
            );
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();

            MEM_DECODE_GEN_0_cs_out_i_reg_0 = 4'b0001;
            @(posedge s_axi_aclk);
            #1;
            MEM_DECODE_GEN_0_cs_out_i_reg_0 = 4'b0000;
            @(posedge s_axi_aclk);
            #1;


            #1;



            check_outputs(
                4'h0, 1'b0, 4'h0, 1'b0, 1'b0, 4'h0, 4'h0, 1'b0, 1'b0, 1'b0
            );
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            gpio_io_i = 4'h5;
            bus2ip_rnw_i_reg = 1'b1;
            MEM_DECODE_GEN_0_cs_out_i_reg_0 = 4'b0001;

            @(posedge s_axi_aclk);
            #1;
            #1;

            check_outputs(
                4'h5,
                1'b1, 4'h0, 1'b1, 1'b1, 4'h0, 4'h0, 1'b1, 1'b1, 1'b0
            );
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
        input [3:0] expected_D;
        input expected_GPIO_xferAck_i;
        input [3:0] expected_Q;
        input expected_bus2ip_cs;
        input expected_bus2ip_rnw;
        input [3:0] expected_gpio_io_o;
        input [3:0] expected_gpio_io_t;
        input expected_gpio_xferAck_Reg;
        input expected_ip2bus_rdack_i;
        input expected_ip2bus_wrack_i_D1_reg;
        begin
            if (expected_D === (expected_D ^ D ^ expected_D) &&
                expected_GPIO_xferAck_i === (expected_GPIO_xferAck_i ^ GPIO_xferAck_i ^ expected_GPIO_xferAck_i) &&
                expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_bus2ip_cs === (expected_bus2ip_cs ^ bus2ip_cs ^ expected_bus2ip_cs) &&
                expected_bus2ip_rnw === (expected_bus2ip_rnw ^ bus2ip_rnw ^ expected_bus2ip_rnw) &&
                expected_gpio_io_o === (expected_gpio_io_o ^ gpio_io_o ^ expected_gpio_io_o) &&
                expected_gpio_io_t === (expected_gpio_io_t ^ gpio_io_t ^ expected_gpio_io_t) &&
                expected_gpio_xferAck_Reg === (expected_gpio_xferAck_Reg ^ gpio_xferAck_Reg ^ expected_gpio_xferAck_Reg) &&
                expected_ip2bus_rdack_i === (expected_ip2bus_rdack_i ^ ip2bus_rdack_i ^ expected_ip2bus_rdack_i) &&
                expected_ip2bus_wrack_i_D1_reg === (expected_ip2bus_wrack_i_D1_reg ^ ip2bus_wrack_i_D1_reg ^ expected_ip2bus_wrack_i_D1_reg)) begin
                $display("PASS");
                $display("  Outputs: D=%h, GPIO_xferAck_i=%b, Q=%h, bus2ip_cs=%b, bus2ip_rnw=%b, gpio_io_o=%h, gpio_io_t=%h, gpio_xferAck_Reg=%b, ip2bus_rdack_i=%b, ip2bus_wrack_i_D1_reg=%b",
                         D, GPIO_xferAck_i, Q, bus2ip_cs, bus2ip_rnw, gpio_io_o, gpio_io_t, gpio_xferAck_Reg, ip2bus_rdack_i, ip2bus_wrack_i_D1_reg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: D=%h, GPIO_xferAck_i=%b, Q=%h, bus2ip_cs=%b, bus2ip_rnw=%b, gpio_io_o=%h, gpio_io_t=%h, gpio_xferAck_Reg=%b, ip2bus_rdack_i=%b, ip2bus_wrack_i_D1_reg=%b",
                         expected_D, expected_GPIO_xferAck_i, expected_Q, expected_bus2ip_cs, expected_bus2ip_rnw, expected_gpio_io_o, expected_gpio_io_t, expected_gpio_xferAck_Reg, expected_ip2bus_rdack_i, expected_ip2bus_wrack_i_D1_reg);
                $display("  Got:      D=%h, GPIO_xferAck_i=%b, Q=%h, bus2ip_cs=%b, bus2ip_rnw=%b, gpio_io_o=%h, gpio_io_t=%h, gpio_xferAck_Reg=%b, ip2bus_rdack_i=%b, ip2bus_wrack_i_D1_reg=%b",
                         D, GPIO_xferAck_i, Q, bus2ip_cs, bus2ip_rnw, gpio_io_o, gpio_io_t, gpio_xferAck_Reg, ip2bus_rdack_i, ip2bus_wrack_i_D1_reg);
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
        $dumpvars(0,MEM_DECODE_GEN_0_cs_out_i_reg_0, bus2ip_rnw_i_reg, gpio_io_i, s_axi_aclk, D, GPIO_xferAck_i, Q, bus2ip_cs, bus2ip_rnw, gpio_io_o, gpio_io_t, gpio_xferAck_Reg, ip2bus_rdack_i, ip2bus_wrack_i_D1_reg);
    end

endmodule
