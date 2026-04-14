`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg RST;
    reg [15:0] address;
    reg clk;
    reg [15:0] data;
    reg read_signal;
    reg write_signal;
    wire [15:0] dataout;
    wire doneRead;
    wire doneWrite;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .RST(RST),
        .address(address),
        .clk(clk),
        .data(data),
        .read_signal(read_signal),
        .write_signal(write_signal),
        .dataout(dataout),
        .doneRead(doneRead),
        .doneWrite(doneWrite)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            RST = 1;
            address = 0;
            data = 0;
            read_signal = 0;
            write_signal = 0;
            @(posedge clk);
            #1;
            RST = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: Basic Write and Read", test_num);
            reset_dut();


            address = 16'h0010;
            data = 16'hABCD;
            write_signal = 1;
            @(posedge clk);
            #1;
            write_signal = 0;


            read_signal = 1;
            @(posedge clk);
            #1;
            read_signal = 0;


            #1;



            check_outputs(16'hABCD, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: Write and Read at different address", test_num);
            reset_dut();


            address = 16'hFFFF;
            data = 16'h5555;
            write_signal = 1;
            @(posedge clk);
            #1;
            write_signal = 0;


            read_signal = 1;
            @(posedge clk);
            #1;
            read_signal = 0;

            #1;


            check_outputs(16'h5555, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: Overwriting an existing address", test_num);
            reset_dut();


            address = 16'h1234;
            data = 16'h1111;
            write_signal = 1;
            @(posedge clk);
            #1;


            data = 16'h2222;
            @(posedge clk);
            #1;
            write_signal = 0;


            read_signal = 1;
            @(posedge clk);
            #1;
            read_signal = 0;

            #1;


            check_outputs(16'h2222, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Read from uninitialized memory", test_num);
            reset_dut();

            address = 16'hAAAA;
            read_signal = 1;
            @(posedge clk);
            #1;
            read_signal = 0;


            #1;



            check_outputs(16'h0000, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: doneWrite signal check", test_num);
            reset_dut();

            address = 16'h0005;
            data = 16'h9999;
            write_signal = 1;
            @(posedge clk);
            #1;
            write_signal = 0;


            #1;



            check_outputs(dataout, 1'b0, 1'b1);
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
        input [15:0] expected_dataout;
        input expected_doneRead;
        input expected_doneWrite;
        begin
            if (expected_dataout === (expected_dataout ^ dataout ^ expected_dataout) &&
                expected_doneRead === (expected_doneRead ^ doneRead ^ expected_doneRead) &&
                expected_doneWrite === (expected_doneWrite ^ doneWrite ^ expected_doneWrite)) begin
                $display("PASS");
                $display("  Outputs: dataout=%h, doneRead=%b, doneWrite=%b",
                         dataout, doneRead, doneWrite);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dataout=%h, doneRead=%b, doneWrite=%b",
                         expected_dataout, expected_doneRead, expected_doneWrite);
                $display("  Got:      dataout=%h, doneRead=%b, doneWrite=%b",
                         dataout, doneRead, doneWrite);
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
        $dumpvars(0,RST, address, clk, data, read_signal, write_signal, dataout, doneRead, doneWrite);
    end

endmodule
