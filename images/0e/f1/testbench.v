`timescale 1ns/1ps

module spi_master_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg mosi_data;
    reg start;
    wire cs;
    wire [7:0] data_out;
    wire miso_data;
    wire sclk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    spi_master dut (
        .clk(clk),
        .data_in(data_in),
        .mosi_data(mosi_data),
        .start(start),
        .cs(cs),
        .data_out(data_out),
        .miso_data(miso_data),
        .sclk(sclk)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            start = 0;
            data_in = 8'h00;
            mosi_data = 0;
            #20;
        end
        endtask
    task testcase001;

        integer i;
        reg [7:0] send_val;
        reg [7:0] recv_val;
        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Send 0xA5, Receive 0x3C", test_num);
            reset_dut();

            send_val = 8'hA5;
            recv_val = 8'h3C;
            data_in = send_val;


            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            wait(cs == 0);



            for (i = 7; i >= 0; i = i - 1) begin
                mosi_data = recv_val[i];
                @(negedge sclk);
            end


            wait(cs == 1);
            #20;


            #1;



            check_outputs(1'b1, 8'h3C, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Send 0x00, Receive 0xFF", test_num);
            reset_dut();

            data_in = 8'h00;
            start = 1;
            #10 start = 0;

            wait(cs == 0);
            for (i = 7; i >= 0; i = i - 1) begin
                mosi_data = 1'b1;
                @(negedge sclk);
            end

            wait(cs == 1);
            #20;

            #1;


            check_outputs(1'b1, 8'hFF, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Send 0xFF, Receive 0x00", test_num);
            reset_dut();

            data_in = 8'hFF;
            start = 1;
            #10 start = 0;

            wait(cs == 0);
            for (i = 7; i >= 0; i = i - 1) begin
                mosi_data = 1'b0;
                @(negedge sclk);
            end

            wait(cs == 1);
            #20;

            #1;


            check_outputs(1'b1, 8'h00, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        integer i;
        reg [7:0] recv_val;
        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Send 0x55, Receive 0xAA", test_num);
            reset_dut();

            data_in = 8'h55;
            recv_val = 8'hAA;
            start = 1;
            #10 start = 0;

            wait(cs == 0);
            for (i = 7; i >= 0; i = i - 1) begin
                mosi_data = recv_val[i];
                @(negedge sclk);
            end

            wait(cs == 1);
            #20;

            #1;


            check_outputs(1'b1, 8'hAA, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Send 0x81, Receive 0x18", test_num);
            reset_dut();

            data_in = 8'h81;
            start = 1;
            #10 start = 0;

            wait(cs == 0);
            for (i = 7; i >= 0; i = i - 1) begin
                mosi_data = 8'h18[i];
                @(negedge sclk);
            end

            wait(cs == 1);
            #20;

            #1;


            check_outputs(1'b1, 8'h18, 1'b1, 1'b0);
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
        input expected_cs;
        input [7:0] expected_data_out;
        input expected_miso_data;
        input expected_sclk;
        begin
            if (expected_cs === (expected_cs ^ cs ^ expected_cs) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_miso_data === (expected_miso_data ^ miso_data ^ expected_miso_data) &&
                expected_sclk === (expected_sclk ^ sclk ^ expected_sclk)) begin
                $display("PASS");
                $display("  Outputs: cs=%b, data_out=%h, miso_data=%b, sclk=%b",
                         cs, data_out, miso_data, sclk);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cs=%b, data_out=%h, miso_data=%b, sclk=%b",
                         expected_cs, expected_data_out, expected_miso_data, expected_sclk);
                $display("  Got:      cs=%b, data_out=%h, miso_data=%b, sclk=%b",
                         cs, data_out, miso_data, sclk);
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
        $dumpvars(0,clk, data_in, mosi_data, start, cs, data_out, miso_data, sclk);
    end

endmodule
