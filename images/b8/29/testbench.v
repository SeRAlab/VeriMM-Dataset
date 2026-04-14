`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg baud_clk;
    reg clk;
    reg [7:0] data;
    reg data_strobe;
    reg reset;
    wire ready;
    wire serial_txd;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .baud_clk(baud_clk),
        .clk(clk),
        .data(data),
        .data_strobe(data_strobe),
        .reset(reset),
        .ready(ready),
        .serial_txd(serial_txd)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        data_strobe = 0;
        data = 8'h00;
        baud_clk = 0;
        repeat(5) @(posedge clk);
        reset = 0;
        repeat(5) @(posedge clk);
    end
        endtask
    task baud_tick;

    begin
        @(posedge clk);
        baud_clk = 1;
        @(posedge clk);
        baud_clk = 0;

        repeat(2) @(posedge clk);
    end
        endtask

    task testcase001;

        reg [9:0] captured;
        integer i;
    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %03d: Transmit 0x55 (Alternating 1/0)", test_num);
        data = 8'h55;
        data_strobe = 1;
        @(posedge clk);
        data_strobe = 0;


        while(ready) @(posedge clk);


        for (i = 0; i < 10; i = i + 1) begin
            captured[i] = serial_txd;
            baud_tick();
        end


        while(!ready) begin
            baud_tick();
            repeat(2) @(posedge clk);
        end



        if (captured === 10'b1_01010101_0)
            #1;

            check_outputs(1'b1, 1'b1);
        else begin
            $display("  FAIL: Captured bit sequence %b", captured);
            #1;

            check_outputs(1'b1, 1'b0);
        end
    end
        endtask

    task testcase002;

        reg [9:0] captured;
        integer i;
    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %03d: Transmit 0xAA (Alternating 0/1)", test_num);
        data = 8'hAA;
        data_strobe = 1;
        @(posedge clk);
        data_strobe = 0;

        while(ready) @(posedge clk);

        for (i = 0; i < 10; i = i + 1) begin
            captured[i] = serial_txd;
            baud_tick();
        end

        while(!ready) baud_tick();
        repeat(2) @(posedge clk);



        if (captured === 10'b1_10101010_0)
            #1;

            check_outputs(1'b1, 1'b1);
        else begin
            $display("  FAIL: Captured bit sequence %b", captured);
            #1;

            check_outputs(1'b1, 1'b0);
        end
    end
        endtask

    task testcase003;

        reg [9:0] captured;
        integer i;
    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %03d: Transmit 0x00 (All Zeros)", test_num);
        data = 8'h00;
        data_strobe = 1;
        @(posedge clk);
        data_strobe = 0;

        while(ready) @(posedge clk);

        for (i = 0; i < 10; i = i + 1) begin
            captured[i] = serial_txd;
            baud_tick();
        end

        while(!ready) baud_tick();
        repeat(2) @(posedge clk);


        if (captured === 10'b1_00000000_0)
            #1;

            check_outputs(1'b1, 1'b1);
        else
            #1;

            check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase004;

        reg [9:0] captured;
        integer i;
    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %03d: Transmit 0xFF (All Ones)", test_num);
        data = 8'hFF;
        data_strobe = 1;
        @(posedge clk);
        data_strobe = 0;

        while(ready) @(posedge clk);

        for (i = 0; i < 10; i = i + 1) begin
            captured[i] = serial_txd;
            baud_tick();
        end

        while(!ready) baud_tick();
        repeat(2) @(posedge clk);


        if (captured === 10'b1_11111111_0)
            #1;

            check_outputs(1'b1, 1'b1);
        else
            #1;

            check_outputs(1'b1, 1'b0);
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
        input expected_ready;
        input expected_serial_txd;
        begin
            if (expected_ready === (expected_ready ^ ready ^ expected_ready) &&
                expected_serial_txd === (expected_serial_txd ^ serial_txd ^ expected_serial_txd)) begin
                $display("PASS");
                $display("  Outputs: ready=%b, serial_txd=%b",
                         ready, serial_txd);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ready=%b, serial_txd=%b",
                         expected_ready, expected_serial_txd);
                $display("  Got:      ready=%b, serial_txd=%b",
                         ready, serial_txd);
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
        $dumpvars(0,baud_clk, clk, data, data_strobe, reset, ready, serial_txd);
    end

endmodule
