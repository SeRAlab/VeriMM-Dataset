`timescale 1ns/1ps

module spi_master_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] mosi;
    reg rst;
    reg start;
    wire cs;
    wire miso;
    wire sclk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    spi_master dut (
        .clk(clk),
        .mosi(mosi),
        .rst(rst),
        .start(start),
        .cs(cs),
        .miso(miso),
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
            mosi = 8'h00;
            #20;
            rst = 0;
            #20;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("testcase%03d: Reset and Idle State Check", test_num);
            reset_dut();

            #1;


            check_outputs(1'b1, miso, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("testcase%03d: Transmit 0x55", test_num);
            reset_dut();
            mosi = 8'h55;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            #1000;


            #1;



            check_outputs(1'b1, miso, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("testcase%03d: Transmit 0xAA", test_num);
            reset_dut();
            mosi = 8'hAA;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            #1000;
            #1;

            check_outputs(1'b1, miso, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("testcase%03d: Transmit 0xFF", test_num);
            reset_dut();
            mosi = 8'hFF;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            #1000;
            #1;

            check_outputs(1'b1, miso, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("testcase%03d: Transmit 0x00", test_num);
            reset_dut();
            mosi = 8'h00;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            #1000;
            #1;

            check_outputs(1'b1, miso, 1'b0);
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
        input expected_miso;
        input expected_sclk;
        begin
            if (expected_cs === (expected_cs ^ cs ^ expected_cs) &&
                expected_miso === (expected_miso ^ miso ^ expected_miso) &&
                expected_sclk === (expected_sclk ^ sclk ^ expected_sclk)) begin
                $display("PASS");
                $display("  Outputs: cs=%b, miso=%b, sclk=%b",
                         cs, miso, sclk);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cs=%b, miso=%b, sclk=%b",
                         expected_cs, expected_miso, expected_sclk);
                $display("  Got:      cs=%b, miso=%b, sclk=%b",
                         cs, miso, sclk);
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
        $dumpvars(0,clk, mosi, rst, start, cs, miso, sclk);
    end

endmodule
