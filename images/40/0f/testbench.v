`timescale 1ns/1ps

module spi_controller_tb;

    // Testbench signals (sequential circuit)
    reg MISO;
    reg clk;
    reg [3:0] data_in;
    reg reset;
    reg start;
    wire MOSI;
    wire [3:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    spi_controller dut (
        .MISO(MISO),
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .start(start),
        .MOSI(MOSI),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            start = 0;
            data_in = 0;
            MISO = 0;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTest Case %0d: Data In 4'b1010, MISO stream 1101", test_num);

            data_in = 4'b1010;
            start = 1;
            @(posedge clk);
            #1 start = 0;


            MISO = 1; @(posedge clk);

            MISO = 1; @(posedge clk);

            MISO = 0; @(posedge clk);

            MISO = 1; @(posedge clk);

            #1;
            #1;

            check_outputs(1'b0, 4'b1101);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTest Case %0d: Data In 4'b0101, MISO stream 0011", test_num);

            data_in = 4'b0101;
            start = 1;
            @(posedge clk);
            #1 start = 0;

            MISO = 0; @(posedge clk);
            MISO = 0; @(posedge clk);
            MISO = 1; @(posedge clk);
            MISO = 1; @(posedge clk);

            #1;
            #1;

            check_outputs(1'b1, 4'b0011);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTest Case %0d: Data In 4'b1111, MISO stream 0000", test_num);

            data_in = 4'b1111;
            start = 1;
            @(posedge clk);
            #1 start = 0;

            MISO = 0; @(posedge clk);
            MISO = 0; @(posedge clk);
            MISO = 0; @(posedge clk);
            MISO = 0; @(posedge clk);

            #1;
            #1;

            check_outputs(1'b1, 4'b0000);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTest Case %0d: Data In 4'b0000, MISO stream 1111", test_num);

            data_in = 4'b0000;
            start = 1;
            @(posedge clk);
            #1 start = 0;

            MISO = 1; @(posedge clk);
            MISO = 1; @(posedge clk);
            MISO = 1; @(posedge clk);
            MISO = 1; @(posedge clk);

            #1;
            #1;

            check_outputs(1'b0, 4'b1111);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTest Case %0d: Data In 4'b1100, MISO stream 1010", test_num);

            data_in = 4'b1100;
            start = 1;
            @(posedge clk);
            #1 start = 0;

            MISO = 1; @(posedge clk);
            MISO = 0; @(posedge clk);
            MISO = 1; @(posedge clk);
            MISO = 0; @(posedge clk);

            #1;
            #1;

            check_outputs(1'b0, 4'b1010);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("spi_controller Testbench");
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
        input [3:0] expected_data_out;
        begin
            if (expected_MOSI === (expected_MOSI ^ MOSI ^ expected_MOSI) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: MOSI=%b, data_out=%h",
                         MOSI, data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: MOSI=%b, data_out=%h",
                         expected_MOSI, expected_data_out);
                $display("  Got:      MOSI=%b, data_out=%h",
                         MOSI, data_out);
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
        $dumpvars(0,MISO, clk, data_in, reset, start, MOSI, data_out);
    end

endmodule
