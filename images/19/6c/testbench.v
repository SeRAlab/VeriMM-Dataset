`timescale 1ns/1ps

module spi_master_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg miso;
    reg reset;
    reg start;
    wire cs;
    wire [7:0] data_out;
    wire mosi;
    wire sck;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    spi_master dut (
        .clk(clk),
        .data_in(data_in),
        .miso(miso),
        .reset(reset),
        .start(start),
        .cs(cs),
        .data_out(data_out),
        .mosi(mosi),
        .sck(sck)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data_in = 8'h00;
            miso = 0;
            start = 0;
            repeat(5) @(posedge clk);
            reset = 0;
            repeat(5) @(posedge clk);
        end
        endtask
    task testcase001;

        reg [7:0] slave_data;
        integer i;
        begin
            test_num = 1;
            $display("Test Case 001: Send 0xA5, Receive 0x3C");
            reset_dut();

            slave_data = 8'h3C;
            data_in = 8'hA5;


            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            wait(cs == 0);



            for (i = 7; i >= 0; i = i - 1) begin
                miso = slave_data[i];
                @(posedge sck);
            end


            wait(cs == 1);
            repeat(5) @(posedge clk);




            #1;





            check_outputs(1'b1, 8'h3C, mosi, 1'b0);
        end
        endtask

    task testcase002;

        reg [7:0] slave_data;
        integer i;
        begin
            test_num = 2;
            $display("Test Case 002: Send 0x00, Receive 0xFF");
            reset_dut();

            slave_data = 8'hFF;
            data_in = 8'h00;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(cs == 0);

            for (i = 7; i >= 0; i = i - 1) begin
                miso = slave_data[i];
                @(posedge sck);
            end

            wait(cs == 1);
            repeat(5) @(posedge clk);

            #1;


            check_outputs(1'b1, 8'hFF, mosi, 1'b0);
        end
        endtask

    task testcase003;

        reg [7:0] slave_data;
        integer i;
        begin
            test_num = 3;
            $display("Test Case 003: Send 0xFF, Receive 0x00");
            reset_dut();

            slave_data = 8'h00;
            data_in = 8'hFF;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(cs == 0);

            for (i = 7; i >= 0; i = i - 1) begin
                miso = slave_data[i];
                @(posedge sck);
            end

            wait(cs == 1);
            repeat(5) @(posedge clk);

            #1;


            check_outputs(1'b1, 8'h00, mosi, 1'b0);
        end
        endtask

    task testcase004;

        reg [7:0] slave_data;
        integer i;
        begin
            test_num = 4;
            $display("Test Case 004: Send 0x55, Receive 0xAA");
            reset_dut();

            slave_data = 8'hAA;
            data_in = 8'h55;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(cs == 0);

            for (i = 7; i >= 0; i = i - 1) begin
                miso = slave_data[i];
                @(posedge sck);
            end

            wait(cs == 1);
            repeat(5) @(posedge clk);

            #1;


            check_outputs(1'b1, 8'hAA, mosi, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("spi_master Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input expected_cs;
        input [7:0] expected_data_out;
        input expected_mosi;
        input expected_sck;
        begin
            if (expected_cs === (expected_cs ^ cs ^ expected_cs) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_mosi === (expected_mosi ^ mosi ^ expected_mosi) &&
                expected_sck === (expected_sck ^ sck ^ expected_sck)) begin
                $display("PASS");
                $display("  Outputs: cs=%b, data_out=%h, mosi=%b, sck=%b",
                         cs, data_out, mosi, sck);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cs=%b, data_out=%h, mosi=%b, sck=%b",
                         expected_cs, expected_data_out, expected_mosi, expected_sck);
                $display("  Got:      cs=%b, data_out=%h, mosi=%b, sck=%b",
                         cs, data_out, mosi, sck);
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
        $dumpvars(0,clk, data_in, miso, reset, start, cs, data_out, mosi, sck);
    end

endmodule
