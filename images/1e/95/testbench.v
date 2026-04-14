`timescale 1ns/1ps

module spi_master_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg miso;
    reg reset_n;
    reg start;
    wire [7:0] data_out;
    wire done;
    wire mosi;
    wire sck;
    wire ss;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    spi_master dut (
        .clk(clk),
        .data_in(data_in),
        .miso(miso),
        .reset_n(reset_n),
        .start(start),
        .data_out(data_out),
        .done(done),
        .mosi(mosi),
        .sck(sck),
        .ss(ss)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset_n = 0;
        start = 0;
        data_in = 0;
        miso = 0;
        repeat(5) @(posedge clk);
        reset_n = 1;
        repeat(2) @(posedge clk);
    end
        endtask
    task simulate_slave_response;

        input [7:0] data_to_send;
        integer i;
        begin

            wait(ss == 0);


            for (i = 7; i >= 0; i = i - 1) begin

                @(negedge sck);
                miso = data_to_send[i];
            end
        end
        endtask

    task testcase001;

    begin
        $display("\nRunning testcase001: Basic transaction (A5 -> 3C)");
        reset_dut();
        test_num = 1;

        data_in = 8'hA5;
        start = 1;
        @(posedge clk);
        start = 0;


        fork
            simulate_slave_response(8'h3C);
        join_none


        wait(done == 1);
        repeat(2) @(posedge clk);



        #1;




        check_outputs(8'h3C, 1'b1, mosi, 1'b0, 1'b1);
    end
        endtask

    task testcase002;

    begin
        $display("\nRunning testcase002: All Zeros (00 -> 00)");
        reset_dut();
        test_num = 2;

        data_in = 8'h00;
        start = 1;
        @(posedge clk);
        start = 0;

        fork
            simulate_slave_response(8'h00);
        join_none

        wait(done == 1);
        repeat(2) @(posedge clk);

        #1;


        check_outputs(8'h00, 1'b1, mosi, 1'b0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        $display("\nRunning testcase003: All Ones (FF -> FF)");
        reset_dut();
        test_num = 3;

        data_in = 8'hFF;
        start = 1;
        @(posedge clk);
        start = 0;

        fork
            simulate_slave_response(8'hFF);
        join_none

        wait(done == 1);
        repeat(2) @(posedge clk);

        #1;


        check_outputs(8'hFF, 1'b1, mosi, 1'b0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        $display("\nRunning testcase004: Alternating Bits (55 -> AA)");
        reset_dut();
        test_num = 4;

        data_in = 8'h55;
        start = 1;
        @(posedge clk);
        start = 0;

        fork
            simulate_slave_response(8'hAA);
        join_none

        wait(done == 1);
        repeat(2) @(posedge clk);

        #1;


        check_outputs(8'hAA, 1'b1, mosi, 1'b0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        $display("\nRunning testcase005: Reset mid-operation");
        reset_dut();
        test_num = 5;

        data_in = 8'hAA;
        start = 1;
        @(posedge clk);
        start = 0;


        repeat(4) @(posedge sck);


        reset_n = 0;
        #20;
        reset_n = 1;
        #10;




        #1;





        check_outputs(8'h00, 1'b0, 1'b0, 1'b0, 1'b1);
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
        input [7:0] expected_data_out;
        input expected_done;
        input expected_mosi;
        input expected_sck;
        input expected_ss;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_done === (expected_done ^ done ^ expected_done) &&
                expected_mosi === (expected_mosi ^ mosi ^ expected_mosi) &&
                expected_sck === (expected_sck ^ sck ^ expected_sck) &&
                expected_ss === (expected_ss ^ ss ^ expected_ss)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, done=%b, mosi=%b, sck=%b, ss=%b",
                         data_out, done, mosi, sck, ss);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, done=%b, mosi=%b, sck=%b, ss=%b",
                         expected_data_out, expected_done, expected_mosi, expected_sck, expected_ss);
                $display("  Got:      data_out=%h, done=%b, mosi=%b, sck=%b, ss=%b",
                         data_out, done, mosi, sck, ss);
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
        $dumpvars(0,clk, data_in, miso, reset_n, start, data_out, done, mosi, sck, ss);
    end

endmodule
