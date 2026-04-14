`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] mem_addr;
    reg mem_en;
    reg mem_rd_wr;
    reg [7:0] mem_wdata;
    reg reset_b;
    wire [7:0] address_port_0;
    wire [7:0] address_port_1;
    wire [7:0] address_port_2;
    wire [7:0] address_port_3;
    wire [7:0] mem_rdata;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .mem_addr(mem_addr),
        .mem_en(mem_en),
        .mem_rd_wr(mem_rd_wr),
        .mem_wdata(mem_wdata),
        .reset_b(reset_b),
        .address_port_0(address_port_0),
        .address_port_1(address_port_1),
        .address_port_2(address_port_2),
        .address_port_3(address_port_3),
        .mem_rdata(mem_rdata)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset_b = 0;
            mem_en = 0;
            mem_rd_wr = 0;
            mem_addr = 0;
            mem_wdata = 0;
            @(posedge clk);
            #1;
            reset_b = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset State Check", test_num);
            reset_dut();
            #1;

            check_outputs(8'h00, 8'h00, 8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Write to Port 0", test_num);
            reset_dut();
            @(posedge clk);
            mem_en = 1;
            mem_rd_wr = 0;
            mem_addr = 2'b00;
            mem_wdata = 8'hA1;
            @(posedge clk);
            mem_en = 0;
            #1;

            check_outputs(8'hA1, 8'h00, 8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Write to Port 1", test_num);
            reset_dut();
            @(posedge clk);
            mem_en = 1;
            mem_rd_wr = 0;
            mem_addr = 2'b01;
            mem_wdata = 8'hB2;
            @(posedge clk);
            mem_en = 0;
            #1;

            check_outputs(8'h00, 8'hB2, 8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Write to Port 2", test_num);
            reset_dut();
            @(posedge clk);
            mem_en = 1;
            mem_rd_wr = 0;
            mem_addr = 2'b10;
            mem_wdata = 8'hC3;
            @(posedge clk);
            mem_en = 0;
            #1;

            check_outputs(8'h00, 8'h00, 8'hC3, 8'h00, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Write to Port 3", test_num);
            reset_dut();
            @(posedge clk);
            mem_en = 1;
            mem_rd_wr = 0;
            mem_addr = 2'b11;
            mem_wdata = 8'hD4;
            @(posedge clk);
            mem_en = 0;
            #1;

            check_outputs(8'h00, 8'h00, 8'h00, 8'hD4, 8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Write/Read Port 0", test_num);
            reset_dut();
            @(posedge clk);
            mem_en = 1; mem_rd_wr = 0; mem_addr = 2'b00; mem_wdata = 8'h55;
            @(posedge clk);
            mem_rd_wr = 1;
            @(posedge clk);
            mem_en = 0;
            #1;

            check_outputs(8'h55, 8'h00, 8'h00, 8'h00, 8'h55);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Write/Read Port 1", test_num);
            reset_dut();
            @(posedge clk);
            mem_en = 1; mem_rd_wr = 0; mem_addr = 2'b01; mem_wdata = 8'h66;
            @(posedge clk);
            mem_rd_wr = 1;
            @(posedge clk);
            mem_en = 0;
            #1;

            check_outputs(8'h00, 8'h66, 8'h00, 8'h00, 8'h66);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Write/Read Port 2", test_num);
            reset_dut();
            @(posedge clk);
            mem_en = 1; mem_rd_wr = 0; mem_addr = 2'b10; mem_wdata = 8'h77;
            @(posedge clk);
            mem_rd_wr = 1;
            @(posedge clk);
            mem_en = 0;
            #1;

            check_outputs(8'h00, 8'h00, 8'h77, 8'h00, 8'h77);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Write/Read Port 3", test_num);
            reset_dut();
            @(posedge clk);
            mem_en = 1; mem_rd_wr = 0; mem_addr = 2'b11; mem_wdata = 8'h88;
            @(posedge clk);
            mem_rd_wr = 1;
            @(posedge clk);
            mem_en = 0;
            #1;

            check_outputs(8'h00, 8'h00, 8'h00, 8'h88, 8'h88);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: Write Enable Disable", test_num);
            reset_dut();

            @(posedge clk);
            mem_en = 1; mem_rd_wr = 0; mem_addr = 2'b00; mem_wdata = 8'h99;
            @(posedge clk);

            mem_en = 0; mem_rd_wr = 0; mem_addr = 2'b00; mem_wdata = 8'hAA;
            @(posedge clk);
            #1;

            check_outputs(8'h99, 8'h00, 8'h00, 8'h00, 8'h00);
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
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [7:0] expected_address_port_0;
        input [7:0] expected_address_port_1;
        input [7:0] expected_address_port_2;
        input [7:0] expected_address_port_3;
        input [7:0] expected_mem_rdata;
        begin
            if (expected_address_port_0 === (expected_address_port_0 ^ address_port_0 ^ expected_address_port_0) &&
                expected_address_port_1 === (expected_address_port_1 ^ address_port_1 ^ expected_address_port_1) &&
                expected_address_port_2 === (expected_address_port_2 ^ address_port_2 ^ expected_address_port_2) &&
                expected_address_port_3 === (expected_address_port_3 ^ address_port_3 ^ expected_address_port_3) &&
                expected_mem_rdata === (expected_mem_rdata ^ mem_rdata ^ expected_mem_rdata)) begin
                $display("PASS");
                $display("  Outputs: address_port_0=%h, address_port_1=%h, address_port_2=%h, address_port_3=%h, mem_rdata=%h",
                         address_port_0, address_port_1, address_port_2, address_port_3, mem_rdata);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: address_port_0=%h, address_port_1=%h, address_port_2=%h, address_port_3=%h, mem_rdata=%h",
                         expected_address_port_0, expected_address_port_1, expected_address_port_2, expected_address_port_3, expected_mem_rdata);
                $display("  Got:      address_port_0=%h, address_port_1=%h, address_port_2=%h, address_port_3=%h, mem_rdata=%h",
                         address_port_0, address_port_1, address_port_2, address_port_3, mem_rdata);
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
        $dumpvars(0,clk, mem_addr, mem_en, mem_rd_wr, mem_wdata, reset_b, address_port_0, address_port_1, address_port_2, address_port_3, mem_rdata);
    end

endmodule
