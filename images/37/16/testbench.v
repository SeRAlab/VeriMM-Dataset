`timescale 1ns/1ps

module spi_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg start;
    wire mosi;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    spi_controller dut (
        .clk(clk),
        .data_in(data_in),
        .start(start),
        .mosi(mosi)
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
    task run_spi_transaction;

        input [7:0] value;
        integer i;
        begin
            data_in = value;
            start = 1;
            @(posedge clk);
            start = 0;

            for (i = 7; i >= 0; i = i - 1) begin
                #1;
                #1;

                check_outputs(value[i]);
                @(posedge clk);
            end
            #1;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %03d: Sending 8'b10101010 (0xAA)", test_num);
            reset_dut();
            run_spi_transaction(8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %03d: Sending 8'b01010101 (0x55)", test_num);
            reset_dut();
            run_spi_transaction(8'h55);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %03d: Sending 8'b11111111 (0xFF)", test_num);
            reset_dut();
            run_spi_transaction(8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %03d: Sending 8'b00000000 (0x00)", test_num);
            reset_dut();
            run_spi_transaction(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %03d: Sending 8'b10110011 (0xB3) and Checking Idle", test_num);
            reset_dut();
            run_spi_transaction(8'hB3);

            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
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
        input expected_mosi;
        begin
            if (expected_mosi === (expected_mosi ^ mosi ^ expected_mosi)) begin
                $display("PASS");
                $display("  Outputs: mosi=%b",
                         mosi);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mosi=%b",
                         expected_mosi);
                $display("  Got:      mosi=%b",
                         mosi);
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
        $dumpvars(0,clk, data_in, start, mosi);
    end

endmodule
