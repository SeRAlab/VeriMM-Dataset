`timescale 1ns/1ps

module spi_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg cs;
    reg [7:0] data_in;
    reg mosi;
    reg reset;
    wire [7:0] data_out;
    wire miso;
    wire ready;
    wire sclk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    spi_controller dut (
        .clk(clk),
        .cs(cs),
        .data_in(data_in),
        .mosi(mosi),
        .reset(reset),
        .data_out(data_out),
        .miso(miso),
        .ready(ready),
        .sclk(sclk)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            cs = 1;
            data_in = 8'h00;
            mosi = 0;
            #20;
            reset = 0;
            #20;
        end
        endtask
    task testcase001;

        integer i;
        reg [7:0] tb_send;
        begin
            $display("\nTest Case 001: DUT sends 0xA5, TB sends 0x3C");
            reset_dut();
            tb_send = 8'h3C;
            data_in = 8'hA5;
            #10;
            cs = 0;



            mosi = tb_send[7];
            for (i = 6; i >= 0; i = i - 1) begin
                @(negedge sclk);
                mosi = tb_send[i];
            end


            wait(ready === 1'b1);
            @(posedge clk);


            #1;



            check_outputs(8'h3C, 1'b1, 1'b1, 1'b0);
            cs = 1;
            #20;
        end
        endtask

    task testcase002;

        integer i;
        reg [7:0] tb_send;
        begin
            $display("\nTest Case 002: DUT sends 0x00, TB sends 0xFF");
            reset_dut();
            tb_send = 8'hFF;
            data_in = 8'h00;
            #10;
            cs = 0;

            mosi = tb_send[7];
            for (i = 6; i >= 0; i = i - 1) begin
                @(negedge sclk);
                mosi = tb_send[i];
            end

            wait(ready === 1'b1);
            @(posedge clk);


            #1;



            check_outputs(8'hFF, 1'b0, 1'b1, 1'b0);
            cs = 1;
            #20;
        end
        endtask

    task testcase003;

        integer i;
        reg [7:0] tb_send;
        begin
            $display("\nTest Case 003: DUT sends 0xFF, TB sends 0x00");
            reset_dut();
            tb_send = 8'h00;
            data_in = 8'hFF;
            #10;
            cs = 0;

            mosi = tb_send[7];
            for (i = 6; i >= 0; i = i - 1) begin
                @(negedge sclk);
                mosi = tb_send[i];
            end

            wait(ready === 1'b1);
            @(posedge clk);


            #1;



            check_outputs(8'h00, 1'b1, 1'b1, 1'b0);
            cs = 1;
            #20;
        end
        endtask

    task testcase004;

        integer i;
        reg [7:0] tb_send;
        begin
            $display("\nTest Case 004: DUT sends 0x55, TB sends 0xAA");
            reset_dut();
            tb_send = 8'hAA;
            data_in = 8'h55;
            #10;
            cs = 0;

            mosi = tb_send[7];
            for (i = 6; i >= 0; i = i - 1) begin
                @(negedge sclk);
                mosi = tb_send[i];
            end

            wait(ready === 1'b1);
            @(posedge clk);


            #1;



            check_outputs(8'hAA, 1'b1, 1'b1, 1'b0);
            cs = 1;
            #20;
        end
        endtask

    task testcase005;

        integer i;
        reg [7:0] tb_send;
        begin
            $display("\nTest Case 005: DUT sends 0xAA, TB sends 0x55");
            reset_dut();
            tb_send = 8'h55;
            data_in = 8'hAA;
            #10;
            cs = 0;

            mosi = tb_send[7];
            for (i = 6; i >= 0; i = i - 1) begin
                @(negedge sclk);
                mosi = tb_send[i];
            end

            wait(ready === 1'b1);
            @(posedge clk);


            #1;



            check_outputs(8'h55, 1'b0, 1'b1, 1'b0);
            cs = 1;
            #20;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("spi_controller Testbench");
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
        input [7:0] expected_data_out;
        input expected_miso;
        input expected_ready;
        input expected_sclk;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_miso === (expected_miso ^ miso ^ expected_miso) &&
                expected_ready === (expected_ready ^ ready ^ expected_ready) &&
                expected_sclk === (expected_sclk ^ sclk ^ expected_sclk)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, miso=%b, ready=%b, sclk=%b",
                         data_out, miso, ready, sclk);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, miso=%b, ready=%b, sclk=%b",
                         expected_data_out, expected_miso, expected_ready, expected_sclk);
                $display("  Got:      data_out=%h, miso=%b, ready=%b, sclk=%b",
                         data_out, miso, ready, sclk);
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
        $dumpvars(0,clk, cs, data_in, mosi, reset, data_out, miso, ready, sclk);
    end

endmodule
