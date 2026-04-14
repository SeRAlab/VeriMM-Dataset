`timescale 1ns/1ps

module spi_master_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg mosi;
    reg reset;
    reg ss;
    reg start;
    wire busy;
    wire [7:0] data_out;
    wire miso;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    spi_master dut (
        .clk(clk),
        .data_in(data_in),
        .mosi(mosi),
        .reset(reset),
        .ss(ss),
        .start(start),
        .busy(busy),
        .data_out(data_out),
        .miso(miso)
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
            mosi = 0;
            ss = 1;
            #20;
            reset = 0;
            #20;
        end
        endtask
    task testcase001;

        integer i;
        reg [7:0] t_data;
        reg [7:0] r_data;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Transmit 0xA5, Receive 0x5A", test_num);
            reset_dut();
            t_data = 8'hA5;
            r_data = 8'h5A;
            data_in = t_data;
            ss = 0;
            #10 start = 1;
            @(posedge clk);
            #2 start = 0;



            for (i = 7; i >= 0; i = i - 1) begin
                mosi = r_data[i];
                @(posedge clk);
                #2;
            end


            while (busy) @(posedge clk);
            #10;


            #1;



            check_outputs(1'b0, r_data, t_data[0]);
        end
        endtask

    task testcase002;

        integer i;
        reg [7:0] t_data;
        reg [7:0] r_data;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Transmit 0xFF, Receive 0x00", test_num);
            reset_dut();
            t_data = 8'hFF;
            r_data = 8'h00;
            data_in = t_data;
            ss = 0;
            #10 start = 1;
            @(posedge clk);
            #2 start = 0;

            for (i = 7; i >= 0; i = i - 1) begin
                mosi = r_data[i];
                @(posedge clk);
                #2;
            end

            while (busy) @(posedge clk);
            #10;

            #1;


            check_outputs(1'b0, r_data, t_data[0]);
        end
        endtask

    task testcase003;

        integer i;
        reg [7:0] t_data;
        reg [7:0] r_data;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Transmit 0x00, Receive 0xFF", test_num);
            reset_dut();
            t_data = 8'h00;
            r_data = 8'hFF;
            data_in = t_data;
            ss = 0;
            #10 start = 1;
            @(posedge clk);
            #2 start = 0;

            for (i = 7; i >= 0; i = i - 1) begin
                mosi = r_data[i];
                @(posedge clk);
                #2;
            end

            while (busy) @(posedge clk);
            #10;

            #1;


            check_outputs(1'b0, r_data, t_data[0]);
        end
        endtask

    task testcase004;

        integer i;
        reg [7:0] t_data;
        reg [7:0] r_data;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Transmit 0x12, Receive 0x34", test_num);
            reset_dut();
            t_data = 8'h12;
            r_data = 8'h34;
            data_in = t_data;
            ss = 0;
            #10 start = 1;
            @(posedge clk);
            #2 start = 0;

            for (i = 7; i >= 0; i = i - 1) begin
                mosi = r_data[i];
                @(posedge clk);
                #2;
            end

            while (busy) @(posedge clk);
            #10;

            #1;


            check_outputs(1'b0, r_data, t_data[0]);
        end
        endtask

    task testcase005;

        integer i;
        reg [7:0] t_data;
        reg [7:0] r_data;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Transmit 0xAA, Receive 0x55", test_num);
            reset_dut();
            t_data = 8'hAA;
            r_data = 8'h55;
            data_in = t_data;
            ss = 0;
            #10 start = 1;
            @(posedge clk);
            #2 start = 0;

            for (i = 7; i >= 0; i = i - 1) begin
                mosi = r_data[i];
                @(posedge clk);
                #2;
            end

            while (busy) @(posedge clk);
            #10;

            #1;


            check_outputs(1'b0, r_data, t_data[0]);
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
        input expected_busy;
        input [7:0] expected_data_out;
        input expected_miso;
        begin
            if (expected_busy === (expected_busy ^ busy ^ expected_busy) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_miso === (expected_miso ^ miso ^ expected_miso)) begin
                $display("PASS");
                $display("  Outputs: busy=%b, data_out=%h, miso=%b",
                         busy, data_out, miso);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busy=%b, data_out=%h, miso=%b",
                         expected_busy, expected_data_out, expected_miso);
                $display("  Got:      busy=%b, data_out=%h, miso=%b",
                         busy, data_out, miso);
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
        $dumpvars(0,clk, data_in, mosi, reset, ss, start, busy, data_out, miso);
    end

endmodule
