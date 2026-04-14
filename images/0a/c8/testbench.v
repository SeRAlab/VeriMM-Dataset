`timescale 1ns/1ps

module spi_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg reset;
    reg start;
    wire [7:0] data_out;
    wire miso;
    wire mosi;
    wire ss;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    spi_controller dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .start(start),
        .data_out(data_out),
        .miso(miso),
        .mosi(mosi),
        .ss(ss)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            start = 0;
            data_in = 8'h00;
            miso_drive = 0;
            #20;
            reset = 0;
            #20;
        end
        endtask
    task testcase001;

        reg [7:0] tx_data;
        reg [7:0] rx_data;
        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Sending 0xAA, Receiving 0x55", test_num);
            reset_dut();

            tx_data = 8'hAA;
            rx_data = 8'h55;
            data_in = tx_data;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            wait(ss == 0);



            for (i = 7; i >= 0; i = i - 1) begin
                miso_drive = rx_data[i];
                @(posedge clk);
            end


            wait(ss == 1);
            #20;


            #1;



            check_outputs(rx_data, rx_data[0], tx_data[0], 1'b1);
        end
        endtask

    task testcase002;

        reg [7:0] tx_data;
        reg [7:0] rx_data;
        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Sending 0x00, Receiving 0xFF", test_num);
            reset_dut();

            tx_data = 8'h00;
            rx_data = 8'hFF;
            data_in = tx_data;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(ss == 0);
            for (i = 7; i >= 0; i = i - 1) begin
                miso_drive = rx_data[i];
                @(posedge clk);
            end

            wait(ss == 1);
            #20;

            #1;


            check_outputs(rx_data, rx_data[0], tx_data[0], 1'b1);
        end
        endtask

    task testcase003;

        reg [7:0] tx_data;
        reg [7:0] rx_data;
        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Sending 0xF0, Receiving 0x0F", test_num);
            reset_dut();

            tx_data = 8'hF0;
            rx_data = 8'h0F;
            data_in = tx_data;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(ss == 0);
            for (i = 7; i >= 0; i = i - 1) begin
                miso_drive = rx_data[i];
                @(posedge clk);
            end

            wait(ss == 1);
            #20;

            #1;


            check_outputs(rx_data, rx_data[0], tx_data[0], 1'b1);
        end
        endtask

    task testcase004;

        reg [7:0] tx_data;
        reg [7:0] rx_data;
        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Sending 0x12, Receiving 0x34", test_num);
            reset_dut();

            tx_data = 8'h12;
            rx_data = 8'h34;
            data_in = tx_data;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(ss == 0);
            for (i = 7; i >= 0; i = i - 1) begin
                miso_drive = rx_data[i];
                @(posedge clk);
            end

            wait(ss == 1);
            #20;

            #1;


            check_outputs(rx_data, rx_data[0], tx_data[0], 1'b1);
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
        input expected_mosi;
        input expected_ss;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_miso === (expected_miso ^ miso ^ expected_miso) &&
                expected_mosi === (expected_mosi ^ mosi ^ expected_mosi) &&
                expected_ss === (expected_ss ^ ss ^ expected_ss)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, miso=%b, mosi=%b, ss=%b",
                         data_out, miso, mosi, ss);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, miso=%b, mosi=%b, ss=%b",
                         expected_data_out, expected_miso, expected_mosi, expected_ss);
                $display("  Got:      data_out=%h, miso=%b, mosi=%b, ss=%b",
                         data_out, miso, mosi, ss);
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
        $dumpvars(0,clk, data_in, reset, start, data_out, miso, mosi, ss);
    end

endmodule
