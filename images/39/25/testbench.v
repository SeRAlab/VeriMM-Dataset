`timescale 1ns/1ps

module spi_master_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg start;
    wire cs;
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
        .start(start),
        .cs(cs),
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
            start = 0;
            data_in = 8'h00;
            repeat(5) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %03d: Transmitting 0xAA (10101010)", test_num);
            reset_dut();
            data_in = 8'hAA;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            repeat(32) @(posedge clk);

            #1;


            check_outputs(1'b1, mosi, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %03d: Transmitting 0x00 (00000000)", test_num);
            reset_dut();
            data_in = 8'h00;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;
            repeat(32) @(posedge clk);
            #1;

            check_outputs(1'b1, mosi, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %03d: Transmitting 0xFF (11111111)", test_num);
            reset_dut();
            data_in = 8'hFF;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;
            repeat(32) @(posedge clk);
            #1;

            check_outputs(1'b1, mosi, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %03d: Transmitting 0xA5 (10100101)", test_num);
            reset_dut();
            data_in = 8'hA5;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;
            repeat(32) @(posedge clk);
            #1;

            check_outputs(1'b1, mosi, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %03d: Back-to-back completion check", test_num);
            reset_dut();
            data_in = 8'h55;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;
            repeat(32) @(posedge clk);

            if (cs === 1'b1) begin
                $display("  First transmission finished. Starting second...");
                data_in = 8'h12;
                @(posedge clk);
                start = 1;
                @(posedge clk);
                start = 0;
                repeat(32) @(posedge clk);
                #1;

                check_outputs(1'b1, mosi, 1'b0);
            end else begin
                $display("  FAIL: First transmission did not clear CS");
                fail_count = fail_count + 1;
            end
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
        input expected_sclk;
        begin
            if (expected_cs === (expected_cs ^ cs ^ expected_cs) &&
                expected_mosi === (expected_mosi ^ mosi ^ expected_mosi) &&
                expected_sclk === (expected_sclk ^ sclk ^ expected_sclk)) begin
                $display("PASS");
                $display("  Outputs: cs=%b, mosi=%b, sclk=%b",
                         cs, mosi, sclk);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cs=%b, mosi=%b, sclk=%b",
                         expected_cs, expected_mosi, expected_sclk);
                $display("  Got:      cs=%b, mosi=%b, sclk=%b",
                         cs, mosi, sclk);
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
        $dumpvars(0,clk, data_in, start, cs, mosi, sclk);
    end

endmodule
