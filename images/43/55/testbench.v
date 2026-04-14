`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] haddr;
    reg hsel;
    reg [31:0] hwdata;
    reg hwrite;
    reg rst;
    reg spi_busy;
    reg [7:0] spi_data_out;
    wire [31:0] hrdata;
    wire [7:0] spi_data_in;
    wire spi_ready_send;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .haddr(haddr),
        .hsel(hsel),
        .hwdata(hwdata),
        .hwrite(hwrite),
        .rst(rst),
        .spi_busy(spi_busy),
        .spi_data_out(spi_data_out),
        .hrdata(hrdata),
        .spi_data_in(spi_data_in),
        .spi_ready_send(spi_ready_send)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            hsel = 0;
            hwrite = 0;
            haddr = 0;
            hwdata = 0;
            spi_busy = 0;
            spi_data_out = 0;
            #20;
            rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset State Verification", test_num);
            reset_dut();

            #1;


            check_outputs(32'h0, 8'h0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: SPI Write Transfer", test_num);
            reset_dut();

            @(posedge clk);
            hsel = 1;
            hwrite = 1;
            haddr = 32'h0;
            hwdata = 32'hA5;

            @(posedge clk);
            hsel = 0;
            hwrite = 0;



            #1;




            check_outputs(32'h0, 8'hA5, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: SPI Read Transfer", test_num);
            reset_dut();

            spi_data_out = 8'h5A;

            @(posedge clk);
            hsel = 1;
            hwrite = 0;
            haddr = 32'h0;

            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h5A, 8'h0, 1'b0);
            hsel = 0;
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: SPI Status Read (Busy)", test_num);
            reset_dut();

            spi_busy = 1;

            @(posedge clk);
            hsel = 1;
            hwrite = 0;
            haddr = 32'h4;

            @(posedge clk);
            #1;


            #1;



            check_outputs(32'h1, 8'h0, 1'b0);
            hsel = 0;
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Ready Send Pulse De-assertion", test_num);
            reset_dut();

            @(posedge clk);
            hsel = 1;
            hwrite = 1;
            haddr = 32'h0;
            hwdata = 32'hFF;

            @(posedge clk);

            hsel = 0;
            hwrite = 0;

            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h0, 8'hFF, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Sequential Writes", test_num);
            reset_dut();

            @(posedge clk);
            hsel = 1;
            hwrite = 1;
            haddr = 32'h0;
            hwdata = 32'h12;
            @(posedge clk);
            haddr = 32'h0;
            hwdata = 32'h34;
            @(posedge clk);
            hsel = 0;

            #1;

            #1;


            check_outputs(32'h0, 8'h34, 1'b0);
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
        input [31:0] expected_hrdata;
        input [7:0] expected_spi_data_in;
        input expected_spi_ready_send;
        begin
            if (expected_hrdata === (expected_hrdata ^ hrdata ^ expected_hrdata) &&
                expected_spi_data_in === (expected_spi_data_in ^ spi_data_in ^ expected_spi_data_in) &&
                expected_spi_ready_send === (expected_spi_ready_send ^ spi_ready_send ^ expected_spi_ready_send)) begin
                $display("PASS");
                $display("  Outputs: hrdata=%h, spi_data_in=%h, spi_ready_send=%b",
                         hrdata, spi_data_in, spi_ready_send);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hrdata=%h, spi_data_in=%h, spi_ready_send=%b",
                         expected_hrdata, expected_spi_data_in, expected_spi_ready_send);
                $display("  Got:      hrdata=%h, spi_data_in=%h, spi_ready_send=%b",
                         hrdata, spi_data_in, spi_ready_send);
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
        $dumpvars(0,clk, haddr, hsel, hwdata, hwrite, rst, spi_busy, spi_data_out, hrdata, spi_data_in, spi_ready_send);
    end

endmodule
