`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] ToSPI;
    reg clk;
    reg enable;
    reg reset;
    wire MOSI;
    wire SPI_CS;
    wire sClk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ToSPI(ToSPI),
        .clk(clk),
        .enable(enable),
        .reset(reset),
        .MOSI(MOSI),
        .SPI_CS(SPI_CS),
        .sClk(sClk)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            enable = 0;
            ToSPI = 32'h0;
            repeat(2) @(posedge clk);
            reset = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Transmitting 0x00000000", test_num);
            reset_dut();
            ToSPI = 32'h00000000;
            enable = 1;
            @(posedge clk);
            enable = 0;



            repeat(100) @(posedge clk);


            #1;



            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Transmitting 0xFFFFFFFF", test_num);
            reset_dut();
            ToSPI = 32'hFFFFFFFF;
            enable = 1;
            @(posedge clk);
            enable = 0;

            repeat(100) @(posedge clk);


            #1;



            check_outputs(1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Transmitting 0xAAAAAAAA", test_num);
            reset_dut();
            ToSPI = 32'hAAAAAAAA;
            enable = 1;
            @(posedge clk);
            enable = 0;

            repeat(100) @(posedge clk);


            #1;



            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Transmitting 0x55555555", test_num);
            reset_dut();
            ToSPI = 32'h55555555;
            enable = 1;
            @(posedge clk);
            enable = 0;

            repeat(100) @(posedge clk);


            #1;



            check_outputs(1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Transmitting 0x12345678", test_num);
            reset_dut();
            ToSPI = 32'h12345678;
            enable = 1;
            @(posedge clk);
            enable = 0;

            repeat(100) @(posedge clk);


            #1;



            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input expected_MOSI;
        input expected_SPI_CS;
        input expected_sClk;
        begin
            if (expected_MOSI === (expected_MOSI ^ MOSI ^ expected_MOSI) &&
                expected_SPI_CS === (expected_SPI_CS ^ SPI_CS ^ expected_SPI_CS) &&
                expected_sClk === (expected_sClk ^ sClk ^ expected_sClk)) begin
                $display("PASS");
                $display("  Outputs: MOSI=%b, SPI_CS=%b, sClk=%b",
                         MOSI, SPI_CS, sClk);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: MOSI=%b, SPI_CS=%b, sClk=%b",
                         expected_MOSI, expected_SPI_CS, expected_sClk);
                $display("  Got:      MOSI=%b, SPI_CS=%b, sClk=%b",
                         MOSI, SPI_CS, sClk);
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
        $dumpvars(0,ToSPI, clk, enable, reset, MOSI, SPI_CS, sClk);
    end

endmodule
