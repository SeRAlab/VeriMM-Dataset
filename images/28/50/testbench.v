`timescale 1ns/1ps

module uart_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg rst;
    reg tx_enable;
    wire ready;
    wire tx;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    uart_controller dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .tx_enable(tx_enable),
        .ready(ready),
        .tx(tx)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        tx_enable = 0;
        data_in = 8'b0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        $display("Running testcase001: Initial Idle State Check");
        reset_dut();

        #1;


        check_outputs(1, 1);
    end
        endtask

    task testcase002;

    integer i;
    begin
        $display("Running testcase002: Transmit 0x00");
        reset_dut();
        data_in = 8'h00;
        tx_enable = 1;
        @(posedge clk);
        #1 tx_enable = 0;


        #1;



        check_outputs(0, 0);


        for (i = 0; i < 8; i = i + 1) begin
            @(posedge clk); #1;
            #1;

            check_outputs(0, 0);
        end


        @(posedge clk); #1;
        #1;

        check_outputs(0, 1);


        @(posedge clk); #1;
        #1;

        check_outputs(1, 1);
    end
        endtask

    task testcase003;

    integer i;
    begin
        $display("Running testcase003: Transmit 0xFF");
        reset_dut();
        data_in = 8'hFF;
        tx_enable = 1;
        @(posedge clk);
        #1 tx_enable = 0;


        #1;



        check_outputs(0, 0);


        for (i = 0; i < 8; i = i + 1) begin
            @(posedge clk); #1;
            #1;

            check_outputs(0, 1);
        end


        @(posedge clk); #1;
        #1;

        check_outputs(0, 1);


        @(posedge clk); #1;
        #1;

        check_outputs(1, 1);
    end
        endtask

    task testcase004;

    integer i;
    reg [7:0] pattern;
    begin
        $display("Running testcase004: Transmit 0x55");
        pattern = 8'h55;
        reset_dut();
        data_in = pattern;
        tx_enable = 1;
        @(posedge clk);
        #1 tx_enable = 0;


        #1;



        check_outputs(0, 0);


        for (i = 0; i < 8; i = i + 1) begin
            @(posedge clk); #1;
            #1;

            check_outputs(0, pattern[i]);
        end


        @(posedge clk); #1;
        #1;

        check_outputs(0, 1);

        @(posedge clk); #1;
        #1;

        check_outputs(1, 1);
    end
        endtask

    task testcase005;

    integer i;
    reg [7:0] pattern;
    begin
        $display("Running testcase005: Transmit 0xAA");
        pattern = 8'hAA;
        reset_dut();
        data_in = pattern;
        tx_enable = 1;
        @(posedge clk);
        #1 tx_enable = 0;


        #1;



        check_outputs(0, 0);


        for (i = 0; i < 8; i = i + 1) begin
            @(posedge clk); #1;
            #1;

            check_outputs(0, pattern[i]);
        end


        @(posedge clk); #1;
        #1;

        check_outputs(0, 1);

        @(posedge clk); #1;
        #1;

        check_outputs(1, 1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("uart_controller Testbench");
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
        input expected_ready;
        input expected_tx;
        begin
            if (expected_ready === (expected_ready ^ ready ^ expected_ready) &&
                expected_tx === (expected_tx ^ tx ^ expected_tx)) begin
                $display("PASS");
                $display("  Outputs: ready=%b, tx=%b",
                         ready, tx);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ready=%b, tx=%b",
                         expected_ready, expected_tx);
                $display("  Got:      ready=%b, tx=%b",
                         ready, tx);
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
        $dumpvars(0,clk, data_in, rst, tx_enable, ready, tx);
    end

endmodule
