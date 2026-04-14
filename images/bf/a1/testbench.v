`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [6:0] addr;
    reg clk;
    reg sample;
    reg shiftIn;
    wire dataOut;
    wire shiftOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .sample(sample),
        .shiftIn(shiftIn),
        .dataOut(dataOut),
        .shiftOut(shiftOut)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            addr = 0;
            sample = 0;
            shiftIn = 0;

            repeat(128) begin
                @(posedge clk);
                shiftIn = 0;
            end

            @(posedge clk);
            sample = 1;
            @(posedge clk);
            sample = 0;
            $display("DUT Reset: Internal state cleared.");
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %03d: Filling buffer with 1s...", test_num);
            reset_dut();

            shiftIn = 1;
            repeat(128) @(posedge clk);


            sample = 1;
            addr = 7'd64;
            @(posedge clk);
            sample = 0;
            @(posedge clk);


            #1;



            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %03d: Verifying oldest bit (addr 127)...", test_num);
            reset_dut();


            shiftIn = 1;
            @(posedge clk);
            shiftIn = 0;
            repeat(127) @(posedge clk);


            sample = 1;
            addr = 7'd127;
            @(posedge clk);
            sample = 0;
            @(posedge clk);


            #1;



            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %03d: Verifying newest bit (addr 0)...", test_num);
            reset_dut();


            shiftIn = 0;
            repeat(127) @(posedge clk);
            shiftIn = 1;
            @(posedge clk);


            sample = 1;
            addr = 7'd0;
            @(posedge clk);
            sample = 0;
            @(posedge clk);


            #1;



            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %03d: Verifying sample latching logic...", test_num);
            reset_dut();


            shiftIn = 1;
            repeat(128) @(posedge clk);
            sample = 1;
            @(posedge clk);
            sample = 0;


            shiftIn = 0;
            repeat(128) @(posedge clk);

            addr = 7'd10;
            @(posedge clk);



            #1;




            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        integer i;
        reg [127:0] pattern;
        begin
            test_num = 5;
            $display("\nTestcase %03d: Address decoding walk...", test_num);
            reset_dut();
            pattern = 128'hA5A5A5A5_5A5A5A5A_FF00FF00_00FF00FF;


            for (i = 0; i < 128; i = i + 1) begin
                shiftIn = pattern[i];
                @(posedge clk);
            end

            sample = 1;
            @(posedge clk);
            sample = 0;


            addr = 7'd0;
            #1;
            if (dataOut !== pattern[127]) begin
                $display("Subtest failed at addr 0");
                fail_count = fail_count + 1;
            end else begin

                addr = 7'd127;
                #1;
                #1;

                check_outputs(pattern[0], pattern[127]);
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
        input expected_dataOut;
        input expected_shiftOut;
        begin
            if (expected_dataOut === (expected_dataOut ^ dataOut ^ expected_dataOut) &&
                expected_shiftOut === (expected_shiftOut ^ shiftOut ^ expected_shiftOut)) begin
                $display("PASS");
                $display("  Outputs: dataOut=%b, shiftOut=%b",
                         dataOut, shiftOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dataOut=%b, shiftOut=%b",
                         expected_dataOut, expected_shiftOut);
                $display("  Got:      dataOut=%b, shiftOut=%b",
                         dataOut, shiftOut);
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
        $dumpvars(0,addr, clk, sample, shiftIn, dataOut, shiftOut);
    end

endmodule
