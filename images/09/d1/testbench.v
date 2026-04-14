`timescale 1ns/1ps

module spi_master_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg start;
    wire cs;
    wire mosi;
    wire spi_clk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    spi_master dut (
        .clk(clk),
        .data_in(data_in),
        .start(start),
        .cs(cs),
        .mosi(mosi),
        .spi_clk(spi_clk)
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
            repeat(2) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Sending 0x00", test_num);
            reset_dut();

            data_in = 8'h00;
            start = 1;
            @(posedge clk);
            #1 start = 0;



            repeat(200) @(posedge clk);



            #1;




            check_outputs(1, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Sending 0xFF", test_num);
            reset_dut();

            data_in = 8'hFF;
            start = 1;
            @(posedge clk);
            #1 start = 0;

            repeat(200) @(posedge clk);

            #1;


            check_outputs(1, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Sending 0x55", test_num);
            reset_dut();

            data_in = 8'h55;
            start = 1;
            @(posedge clk);
            #1 start = 0;

            repeat(200) @(posedge clk);

            #1;


            check_outputs(1, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Sending 0xAA", test_num);
            reset_dut();

            data_in = 8'hAA;
            start = 1;
            @(posedge clk);
            #1 start = 0;

            repeat(200) @(posedge clk);

            #1;


            check_outputs(1, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Sending 0xA5", test_num);
            reset_dut();

            data_in = 8'hA5;
            start = 1;
            @(posedge clk);
            #1 start = 0;

            repeat(200) @(posedge clk);

            #1;


            check_outputs(1, 0, 0);
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
        input expected_mosi;
        input expected_spi_clk;
        begin
            if (expected_cs === (expected_cs ^ cs ^ expected_cs) &&
                expected_mosi === (expected_mosi ^ mosi ^ expected_mosi) &&
                expected_spi_clk === (expected_spi_clk ^ spi_clk ^ expected_spi_clk)) begin
                $display("PASS");
                $display("  Outputs: cs=%b, mosi=%b, spi_clk=%b",
                         cs, mosi, spi_clk);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cs=%b, mosi=%b, spi_clk=%b",
                         expected_cs, expected_mosi, expected_spi_clk);
                $display("  Got:      cs=%b, mosi=%b, spi_clk=%b",
                         cs, mosi, spi_clk);
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
        $dumpvars(0,clk, data_in, start, cs, mosi, spi_clk);
    end

endmodule
