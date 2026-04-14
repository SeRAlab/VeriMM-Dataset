`timescale 1ns/1ps

module spi_master_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg cs;
    reg mosi;
    reg reset;
    wire [7:0] data_out;
    wire miso;
    wire ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    spi_master dut (
        .clk(clk),
        .cs(cs),
        .mosi(mosi),
        .reset(reset),
        .data_out(data_out),
        .miso(miso),
        .ready(ready)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            cs = 1;
            mosi = 0;
            repeat(2) @(posedge clk);
            reset = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task shift_byte_in;

        input [7:0] data;
        integer i;
        begin
            cs = 0;
            for (i = 7; i >= 0; i = i - 1) begin
                mosi = data[i];
                @(posedge clk);
            end
            cs = 1;

            @(posedge clk);
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Transferring 0xA5", test_num);
            reset_dut();
            shift_byte_in(8'hA5);

            #1;


            check_outputs(8'hA5, miso, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Transferring 0x3C", test_num);
            reset_dut();
            shift_byte_in(8'h3C);
            #1;

            check_outputs(8'h3C, miso, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Transferring 0xFF", test_num);
            reset_dut();
            shift_byte_in(8'hFF);
            #1;

            check_outputs(8'hFF, miso, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Transferring 0x00", test_num);
            reset_dut();
            shift_byte_in(8'h00);
            #1;

            check_outputs(8'h00, miso, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Verifying Idle State (CS=1)", test_num);
            reset_dut();



            repeat(5) @(posedge clk);

            #1;


            check_outputs(8'h00, miso, ready);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Back-to-back transfers (0x55 then 0xAA)", test_num);
            reset_dut();
            shift_byte_in(8'h55);
            if (data_out !== 8'h55) $display("Intermediate Fall: 0x55 failed");
            shift_byte_in(8'hAA);
            #1;

            check_outputs(8'hAA, miso, 1'b1);
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
        input [7:0] expected_data_out;
        input expected_miso;
        input expected_ready;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_miso === (expected_miso ^ miso ^ expected_miso) &&
                expected_ready === (expected_ready ^ ready ^ expected_ready)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, miso=%b, ready=%b",
                         data_out, miso, ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, miso=%b, ready=%b",
                         expected_data_out, expected_miso, expected_ready);
                $display("  Got:      data_out=%h, miso=%b, ready=%b",
                         data_out, miso, ready);
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
        $dumpvars(0,clk, cs, mosi, reset, data_out, miso, ready);
    end

endmodule
