`timescale 1ns/1ps

module SPI_Controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg cs;
    reg mosi;
    reg rst;
    wire [7:0] data_out;
    wire done;
    wire miso;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SPI_Controller dut (
        .clk(clk),
        .cs(cs),
        .mosi(mosi),
        .rst(rst),
        .data_out(data_out),
        .done(done),
        .miso(miso)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        cs = 1;
        mosi = 0;
        #20;
        rst = 0;
        #20;
    end
        endtask
    task testcase001;

        integer i;
        reg [7:0] data_to_send;
        begin
            test_num = 1;
            $display("\nTestcase %0d: Sending 0x55", test_num);
            reset_dut();
            data_to_send = 8'h55;

            @(negedge clk);
            cs = 0;

            for (i = 7; i >= 0; i = i - 1) begin
                mosi = data_to_send[i];
                @(posedge clk);
            end

            @(negedge clk);
            cs = 1;
            mosi = 0;


            wait(done == 1);
            @(posedge clk);



            #1;




            check_outputs(8'h55, 1, miso);
        end
        endtask

    task testcase002;

        integer i;
        reg [7:0] data_to_send;
        begin
            test_num = 2;
            $display("\nTestcase %0d: Sending 0xAA", test_num);
            reset_dut();
            data_to_send = 8'hAA;

            @(negedge clk);
            cs = 0;

            for (i = 7; i >= 0; i = i - 1) begin
                mosi = data_to_send[i];
                @(posedge clk);
            end

            @(negedge clk);
            cs = 1;
            mosi = 0;

            wait(done == 1);
            @(posedge clk);

            #1;


            check_outputs(8'hAA, 1, miso);
        end
        endtask

    task testcase003;

        integer i;
        reg [7:0] data_to_send;
        begin
            test_num = 3;
            $display("\nTestcase %0d: Sending 0x00", test_num);
            reset_dut();
            data_to_send = 8'h00;

            @(negedge clk);
            cs = 0;

            for (i = 7; i >= 0; i = i - 1) begin
                mosi = data_to_send[i];
                @(posedge clk);
            end

            @(negedge clk);
            cs = 1;

            wait(done == 1);
            @(posedge clk);

            #1;


            check_outputs(8'h00, 1, miso);
        end
        endtask

    task testcase004;

        integer i;
        reg [7:0] data_to_send;
        begin
            test_num = 4;
            $display("\nTestcase %0d: Sending 0xFF", test_num);
            reset_dut();
            data_to_send = 8'hFF;

            @(negedge clk);
            cs = 0;

            for (i = 7; i >= 0; i = i - 1) begin
                mosi = data_to_send[i];
                @(posedge clk);
            end

            @(negedge clk);
            cs = 1;

            wait(done == 1);
            @(posedge clk);

            #1;


            check_outputs(8'hFF, 1, miso);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            $display("\nTestcase %0d: CS high (Idle) check", test_num);
            reset_dut();

            @(negedge clk);
            cs = 1;
            mosi = 1;

            repeat(8) @(posedge clk);

            #20;

            #1;


            check_outputs(8'h00, 0, miso);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SPI_Controller Testbench");
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
        input expected_miso;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_done === (expected_done ^ done ^ expected_done) &&
                expected_miso === (expected_miso ^ miso ^ expected_miso)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, done=%b, miso=%b",
                         data_out, done, miso);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, done=%b, miso=%b",
                         expected_data_out, expected_done, expected_miso);
                $display("  Got:      data_out=%h, done=%b, miso=%b",
                         data_out, done, miso);
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
        $dumpvars(0,clk, cs, mosi, rst, data_out, done, miso);
    end

endmodule
