`timescale 1ns/1ps

module crc8_calculator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg reset;
    reg start;
    wire [7:0] crc_out;
    wire ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    crc8_calculator dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .start(start),
        .crc_out(crc_out),
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
            data_in = 8'h00;
            start = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Input 0x00", test_num);
            reset_dut();
            data_in = 8'h00;
            start = 1;
            @(posedge clk);
            start = 0;


            wait(ready == 1);
            @(posedge clk);
            #1;

            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Input 0x01", test_num);
            reset_dut();
            data_in = 8'h01;
            start = 1;
            @(posedge clk);
            start = 0;

            wait(ready == 1);
            @(posedge clk);
            #1;

            check_outputs(8'h31, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Input 0xFF", test_num);
            reset_dut();
            data_in = 8'hFF;
            start = 1;
            @(posedge clk);
            start = 0;

            wait(ready == 1);
            @(posedge clk);
            #1;

            check_outputs(8'hAC, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Input 0x55", test_num);
            reset_dut();
            data_in = 8'h55;
            start = 1;
            @(posedge clk);
            start = 0;

            wait(ready == 1);
            @(posedge clk);
            #1;

            check_outputs(8'hA0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Input 0x12", test_num);
            reset_dut();
            data_in = 8'h12;
            start = 1;
            @(posedge clk);
            start = 0;

            wait(ready == 1);
            @(posedge clk);
            #1;

            check_outputs(8'h42, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Check Reset Functionality", test_num);


            reset_dut();
            data_in = 8'hFF;
            start = 1;
            @(posedge clk);
            start = 0;
            wait(ready == 1);


            reset = 1;
            @(posedge clk);
            reset = 0;
            @(posedge clk);



            #1;




            check_outputs(8'h00, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("crc8_calculator Testbench");
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
        input [7:0] expected_crc_out;
        input expected_ready;
        begin
            if (expected_crc_out === (expected_crc_out ^ crc_out ^ expected_crc_out) &&
                expected_ready === (expected_ready ^ ready ^ expected_ready)) begin
                $display("PASS");
                $display("  Outputs: crc_out=%h, ready=%b",
                         crc_out, ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: crc_out=%h, ready=%b",
                         expected_crc_out, expected_ready);
                $display("  Got:      crc_out=%h, ready=%b",
                         crc_out, ready);
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
        $dumpvars(0,clk, data_in, reset, start, crc_out, ready);
    end

endmodule
