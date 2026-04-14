`timescale 1ns/1ps

module DMA_Controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] mem_address;
    reg [7:0] peripheral_data_in;
    reg rst;
    reg start;
    wire busy;
    wire done;
    wire mem_read;
    wire mem_write;
    wire [7:0] peripheral_data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DMA_Controller dut (
        .clk(clk),
        .mem_address(mem_address),
        .peripheral_data_in(peripheral_data_in),
        .rst(rst),
        .start(start),
        .busy(busy),
        .done(done),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .peripheral_data_out(peripheral_data_out)
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
            mem_address = 8'h00;
            peripheral_data_in = 8'h00;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Initial State Check", test_num);
            reset_dut();


            #1;



            check_outputs(1'b0, 1'b0, 1'b0, 1'b0, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Single Data Transfer", test_num);
            reset_dut();


            mem_address = 8'hA0;
            peripheral_data_in = 8'h55;


            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;


            wait(done == 1);



            #1;




            check_outputs(1'b0, 1'b1, 1'b0, 1'b0, 8'h55);


            repeat(1) @(posedge clk);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Consecutive Transfers", test_num);
            reset_dut();


            mem_address = 8'h11;
            peripheral_data_in = 8'hAA;
            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;
            wait(done == 1);


            repeat(2) @(posedge clk);
            mem_address = 8'h22;
            peripheral_data_in = 8'hBB;
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;
            wait(done == 1);


            #1;



            check_outputs(1'b0, 1'b1, 1'b0, 1'b0, 8'hBB);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Reset During Operation", test_num);
            reset_dut();


            mem_address = 8'hFF;
            peripheral_data_in = 8'hCC;
            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;


            wait(busy == 1);
            repeat(1) @(posedge clk);


            #1 rst = 1;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(1) @(posedge clk);


            #1;



            check_outputs(1'b0, 1'b0, 1'b0, 1'b0, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Different Address and Pattern", test_num);
            reset_dut();

            mem_address = 8'h3C;
            peripheral_data_in = 8'hF0;

            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;

            wait(done == 1);


            #1;



            check_outputs(1'b0, 1'b1, 1'b0, 1'b0, 8'hF0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("DMA_Controller Testbench");
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
        input expected_done;
        input expected_mem_read;
        input expected_mem_write;
        input [7:0] expected_peripheral_data_out;
        begin
            if (expected_busy === (expected_busy ^ busy ^ expected_busy) &&
                expected_done === (expected_done ^ done ^ expected_done) &&
                expected_mem_read === (expected_mem_read ^ mem_read ^ expected_mem_read) &&
                expected_mem_write === (expected_mem_write ^ mem_write ^ expected_mem_write) &&
                expected_peripheral_data_out === (expected_peripheral_data_out ^ peripheral_data_out ^ expected_peripheral_data_out)) begin
                $display("PASS");
                $display("  Outputs: busy=%b, done=%b, mem_read=%b, mem_write=%b, peripheral_data_out=%h",
                         busy, done, mem_read, mem_write, peripheral_data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busy=%b, done=%b, mem_read=%b, mem_write=%b, peripheral_data_out=%h",
                         expected_busy, expected_done, expected_mem_read, expected_mem_write, expected_peripheral_data_out);
                $display("  Got:      busy=%b, done=%b, mem_read=%b, mem_write=%b, peripheral_data_out=%h",
                         busy, done, mem_read, mem_write, peripheral_data_out);
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
        $dumpvars(0,clk, mem_address, peripheral_data_in, rst, start, busy, done, mem_read, mem_write, peripheral_data_out);
    end

endmodule
