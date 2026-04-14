`timescale 1ns/1ps

module spi_master_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg mosi;
    reg rst;
    reg start;
    wire [7:0] data_out;
    wire sclk;
    wire ss;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    spi_master dut (
        .clk(clk),
        .data_in(data_in),
        .mosi(mosi),
        .rst(rst),
        .start(start),
        .data_out(data_out),
        .sclk(sclk),
        .ss(ss)
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
            data_in = 8'h00;
            mosi = 0;
            #20;
            rst = 0;
            #20;
        end
        endtask
    task simulate_slave_response;

        input [7:0] slave_data;
        integer i;
        begin

            wait(ss == 0);


            mosi = slave_data[7];


            for (i = 6; i >= 0; i = i - 1) begin
                @(negedge sclk);
                mosi = slave_data[i];
            end


            wait(ss == 1);
            #20;
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Communication - Receive 0x55", test_num);
            reset_dut();

            data_in = 8'hA5;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            simulate_slave_response(8'h55);



            #1;




            check_outputs(8'h55, 1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Communication with Alternative Pattern - Receive 0xAA", test_num);
            reset_dut();

            data_in = 8'h00;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            simulate_slave_response(8'hAA);

            #1;


            check_outputs(8'hAA, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Edge Case - Receive 0xFF", test_num);
            reset_dut();

            data_in = 8'h33;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            simulate_slave_response(8'hFF);

            #1;


            check_outputs(8'hFF, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Edge Case - Receive 0x00", test_num);
            reset_dut();

            data_in = 8'hCC;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            simulate_slave_response(8'h00);

            #1;


            check_outputs(8'h00, 1'b0, 1'b1);
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
        input [7:0] expected_data_out;
        input expected_sclk;
        input expected_ss;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_sclk === (expected_sclk ^ sclk ^ expected_sclk) &&
                expected_ss === (expected_ss ^ ss ^ expected_ss)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, sclk=%b, ss=%b",
                         data_out, sclk, ss);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, sclk=%b, ss=%b",
                         expected_data_out, expected_sclk, expected_ss);
                $display("  Got:      data_out=%h, sclk=%b, ss=%b",
                         data_out, sclk, ss);
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
        $dumpvars(0,clk, data_in, mosi, rst, start, data_out, sclk, ss);
    end

endmodule
