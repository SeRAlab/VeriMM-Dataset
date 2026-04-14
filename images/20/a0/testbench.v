`timescale 1ns/1ps

module spi_master_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg reset;
    reg start;
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
        .reset(reset),
        .start(start),
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
            reset = 1;
            data_in = 8'b0;
            start = 0;
            repeat(5) @(posedge clk);
            reset = 0;
            repeat(5) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Sending 0xA5 (10100101)", test_num);
            reset_dut();

            data_in = 8'hA5;
            start = 1;
            @(posedge clk);
            start = 0;


            wait(ss == 0);

            wait(ss == 1);
            repeat(2) @(posedge clk);


            #1;



            check_outputs(1, 0, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Sending 0x00 (00000000)", test_num);
            reset_dut();

            data_in = 8'h00;
            start = 1;
            @(posedge clk);
            start = 0;

            wait(ss == 0);
            wait(ss == 1);
            repeat(2) @(posedge clk);


            #1;



            check_outputs(0, 0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Sending 0xFF (11111111)", test_num);
            reset_dut();

            data_in = 8'hFF;
            start = 1;
            @(posedge clk);
            start = 0;

            wait(ss == 0);
            wait(ss == 1);
            repeat(2) @(posedge clk);


            #1;



            check_outputs(1, 0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Sending 0x80 (10000000)", test_num);
            reset_dut();

            data_in = 8'h80;
            start = 1;
            @(posedge clk);
            start = 0;

            wait(ss == 0);
            wait(ss == 1);
            repeat(2) @(posedge clk);


            #1;



            check_outputs(0, 0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Sending 0x01 (00000001)", test_num);
            reset_dut();

            data_in = 8'h01;
            start = 1;
            @(posedge clk);
            start = 0;

            wait(ss == 0);
            wait(ss == 1);
            repeat(2) @(posedge clk);


            #1;



            check_outputs(1, 0, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Reset Mid-Transmission", test_num);
            reset_dut();

            data_in = 8'hAA;
            start = 1;
            @(posedge clk);
            start = 0;


            wait(ss == 0);
            repeat(10) @(posedge clk);

            reset = 1;
            repeat(2) @(posedge clk);
            reset = 0;


            #1;



            check_outputs(0, 0, 1);
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
        testcase006();
        
        
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
        input expected_mosi;
        input expected_sck;
        input expected_ss;
        begin
            if (expected_mosi === (expected_mosi ^ mosi ^ expected_mosi) &&
                expected_sck === (expected_sck ^ sck ^ expected_sck) &&
                expected_ss === (expected_ss ^ ss ^ expected_ss)) begin
                $display("PASS");
                $display("  Outputs: mosi=%b, sck=%b, ss=%b",
                         mosi, sck, ss);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mosi=%b, sck=%b, ss=%b",
                         expected_mosi, expected_sck, expected_ss);
                $display("  Got:      mosi=%b, sck=%b, ss=%b",
                         mosi, sck, ss);
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
        $dumpvars(0,clk, data_in, reset, start, mosi, sck, ss);
    end

endmodule
