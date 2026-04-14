`timescale 1ns/1ps

module spi_master_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_out;
    reg miso;
    reg rst;
    reg start;
    wire cs;
    wire [7:0] data_in;
    wire done;
    wire mosi;
    wire sclk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    spi_master_controller dut (
        .clk(clk),
        .data_out(data_out),
        .miso(miso),
        .rst(rst),
        .start(start),
        .cs(cs),
        .data_in(data_in),
        .done(done),
        .mosi(mosi),
        .sclk(sclk)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        start = 0;
        data_out = 8'h00;
        miso = 0;
        #20;
        rst = 0;
        #20;
    end
        endtask
    task testcase001;

        integer i;
        reg [7:0] slave_send;
        begin
            $display("\nRunning testcase001: Send 8'hA5, Receive 8'h5A");
            reset_dut();
            test_num = 1;
            slave_send = 8'h5A;
            data_out = 8'hA5;


            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            wait(cs == 0);



            for (i = 7; i >= 0; i = i - 1) begin
                miso = slave_send[i];
                if (i > 0) @(negedge sclk);
            end


            wait(done == 1);
            #1;



            #1;




            check_outputs(1'b1, 8'h5A, 1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        integer i;
        reg [7:0] slave_send;
        begin
            $display("\nRunning testcase002: Send 8'hFF, Receive 8'h00");
            reset_dut();
            test_num = 2;
            slave_send = 8'h00;
            data_out = 8'hFF;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(cs == 0);

            for (i = 7; i >= 0; i = i - 1) begin
                miso = slave_send[i];
                if (i > 0) @(negedge sclk);
            end

            wait(done == 1);
            #1;


            #1;



            check_outputs(1'b1, 8'h00, 1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        integer i;
        reg [7:0] slave_send;
        begin
            $display("\nRunning testcase003: Send 8'h00, Receive 8'hFF");
            reset_dut();
            test_num = 3;
            slave_send = 8'hFF;
            data_out = 8'h00;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(cs == 0);

            for (i = 7; i >= 0; i = i - 1) begin
                miso = slave_send[i];
                if (i > 0) @(negedge sclk);
            end

            wait(done == 1);
            #1;


            #1;



            check_outputs(1'b1, 8'hFF, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        integer i;
        reg [7:0] slave_send;
        begin
            $display("\nRunning testcase004: Send 8'h12, Receive 8'h34");
            reset_dut();
            test_num = 4;
            slave_send = 8'h34;
            data_out = 8'h12;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(cs == 0);

            for (i = 7; i >= 0; i = i - 1) begin
                miso = slave_send[i];
                if (i > 0) @(negedge sclk);
            end

            wait(done == 1);
            #1;


            #1;



            check_outputs(1'b1, 8'h34, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        integer i;
        reg [7:0] slave_send;
        begin
            $display("\nRunning testcase005: Send 8'h81, Receive 8'hC3");
            reset_dut();
            test_num = 5;
            slave_send = 8'hC3;
            data_out = 8'h81;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(cs == 0);

            for (i = 7; i >= 0; i = i - 1) begin
                miso = slave_send[i];
                if (i > 0) @(negedge sclk);
            end

            wait(done == 1);
            #1;


            #1;



            check_outputs(1'b1, 8'hC3, 1'b1, 1'b1, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("spi_master_controller Testbench");
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
        input [7:0] expected_data_in;
        input expected_done;
        input expected_mosi;
        input expected_sclk;
        begin
            if (expected_cs === (expected_cs ^ cs ^ expected_cs) &&
                expected_data_in === (expected_data_in ^ data_in ^ expected_data_in) &&
                expected_done === (expected_done ^ done ^ expected_done) &&
                expected_mosi === (expected_mosi ^ mosi ^ expected_mosi) &&
                expected_sclk === (expected_sclk ^ sclk ^ expected_sclk)) begin
                $display("PASS");
                $display("  Outputs: cs=%b, data_in=%h, done=%b, mosi=%b, sclk=%b",
                         cs, data_in, done, mosi, sclk);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cs=%b, data_in=%h, done=%b, mosi=%b, sclk=%b",
                         expected_cs, expected_data_in, expected_done, expected_mosi, expected_sclk);
                $display("  Got:      cs=%b, data_in=%h, done=%b, mosi=%b, sclk=%b",
                         cs, data_in, done, mosi, sclk);
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
        $dumpvars(0,clk, data_out, miso, rst, start, cs, data_in, done, mosi, sclk);
    end

endmodule
