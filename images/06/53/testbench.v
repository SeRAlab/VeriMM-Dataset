`timescale 1ns/1ps

module spi_master_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg rst;
    reg start;
    wire done;
    wire mosi;
    wire sclk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    spi_master dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .start(start),
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
            data_in = 8'h00;
            #20;
            rst = 0;
            #20;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Transmitting 8'hA5 (10100101)", test_num);
            reset_dut();

            data_in = 8'hA5;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            wait(done == 1);

            #1;


            #1;



            check_outputs(1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Transmitting 8'h5A (01011010)", test_num);
            reset_dut();

            data_in = 8'h5A;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done == 1);
            #1;


            #1;



            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Transmitting 8'hFF (11111111)", test_num);
            reset_dut();

            data_in = 8'hFF;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done == 1);
            #1;


            #1;



            check_outputs(1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Transmitting 8'h00 (00000000)", test_num);
            reset_dut();

            data_in = 8'h00;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done == 1);
            #1;


            #1;



            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Transmitting 8'h80 (10000000)", test_num);
            reset_dut();

            data_in = 8'h80;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done == 1);
            #1;


            #1;



            check_outputs(1'b1, 1'b0, 1'b0);
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
        input expected_done;
        input expected_mosi;
        input expected_sclk;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_mosi === (expected_mosi ^ mosi ^ expected_mosi) &&
                expected_sclk === (expected_sclk ^ sclk ^ expected_sclk)) begin
                $display("PASS");
                $display("  Outputs: done=%b, mosi=%b, sclk=%b",
                         done, mosi, sclk);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, mosi=%b, sclk=%b",
                         expected_done, expected_mosi, expected_sclk);
                $display("  Got:      done=%b, mosi=%b, sclk=%b",
                         done, mosi, sclk);
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
        $dumpvars(0,clk, data_in, rst, start, done, mosi, sclk);
    end

endmodule
