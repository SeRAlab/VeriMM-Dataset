`timescale 1ns/1ps

module spi_master_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg rst;
    reg start;
    wire data_valid;
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
        .rst(rst),
        .start(start),
        .data_valid(data_valid),
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
            rst = 1;
            start = 0;
            data_in = 8'h00;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Transmitting 8'hA5", test_num);
            reset_dut();

            data_in = 8'hA5;
            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;


            wait(data_valid == 1);
            wait(data_valid == 0);


            repeat(2) @(posedge clk);



            #1;




            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Transmitting 8'h5A", test_num);
            reset_dut();

            data_in = 8'h5A;
            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;

            wait(data_valid == 1);
            wait(data_valid == 0);

            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Transmitting 8'hFF", test_num);
            reset_dut();

            data_in = 8'hFF;
            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;

            wait(data_valid == 1);
            wait(data_valid == 0);

            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Transmitting 8'h00", test_num);
            reset_dut();

            data_in = 8'h00;
            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;

            wait(data_valid == 1);
            wait(data_valid == 0);

            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b0, 1'b0, 1'b0);
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
        input expected_data_valid;
        input expected_mosi;
        input expected_sck;
        begin
            if (expected_data_valid === (expected_data_valid ^ data_valid ^ expected_data_valid) &&
                expected_mosi === (expected_mosi ^ mosi ^ expected_mosi) &&
                expected_sck === (expected_sck ^ sck ^ expected_sck)) begin
                $display("PASS");
                $display("  Outputs: data_valid=%b, mosi=%b, sck=%b",
                         data_valid, mosi, sck);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_valid=%b, mosi=%b, sck=%b",
                         expected_data_valid, expected_mosi, expected_sck);
                $display("  Got:      data_valid=%b, mosi=%b, sck=%b",
                         data_valid, mosi, sck);
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
        $dumpvars(0,clk, data_in, rst, start, data_valid, mosi, sck);
    end

endmodule
