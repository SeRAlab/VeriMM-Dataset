`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg rst;
    reg start_ch0;
    reg start_ch1;
    reg stop_ch0;
    reg stop_ch1;
    wire busy_ch0;
    wire busy_ch1;
    wire [7:0] data_out_ch0;
    wire [7:0] data_out_ch1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .start_ch0(start_ch0),
        .start_ch1(start_ch1),
        .stop_ch0(stop_ch0),
        .stop_ch1(stop_ch1),
        .busy_ch0(busy_ch0),
        .busy_ch1(busy_ch1),
        .data_out_ch0(data_out_ch0),
        .data_out_ch1(data_out_ch1)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        data_in = 8'h0;
        start_ch0 = 0;
        start_ch1 = 0;
        stop_ch0 = 0;
        stop_ch1 = 0;
        repeat(2) @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %0d: Initial Reset State", test_num);
        reset_dut();

        #1;


        check_outputs(0, 0, 8'h00, 8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %0d: Channel 0 Data Transfer", test_num);
        reset_dut();


        data_in = 8'hA5;
        start_ch0 = 1;
        @(posedge clk);
        #1 start_ch0 = 0;
        data_in = 8'h00;

        repeat(2) @(posedge clk);


        stop_ch0 = 1;
        @(posedge clk);
        #1 stop_ch0 = 0;
        @(posedge clk);

        #1;


        check_outputs(0, 0, 8'hA5, 8'h00);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase %0d: Channel 1 Data Transfer", test_num);
        reset_dut();


        data_in = 8'h5A;
        start_ch1 = 1;
        @(posedge clk);
        #1 start_ch1 = 0;
        data_in = 8'hFF;

        repeat(2) @(posedge clk);


        stop_ch1 = 1;
        @(posedge clk);
        #1 stop_ch1 = 0;
        @(posedge clk);

        #1;


        check_outputs(0, 0, 8'h00, 8'h5A);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase %0d: Simultaneous Channel Transfers", test_num);
        reset_dut();


        data_in = 8'h11;
        start_ch0 = 1;
        @(posedge clk);
        #1 start_ch0 = 0;


        data_in = 8'h22;
        start_ch1 = 1;
        @(posedge clk);
        #1 start_ch1 = 0;


        repeat(2) @(posedge clk);
        stop_ch0 = 1;
        stop_ch1 = 1;
        @(posedge clk);
        #1 stop_ch0 = 0;
        stop_ch1 = 0;
        @(posedge clk);

        #1;


        check_outputs(0, 0, 8'h11, 8'h22);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTestcase %0d: Overlapping transfers check busy logic", test_num);
        reset_dut();


        data_in = 8'hBC;
        start_ch1 = 1;
        @(posedge clk);
        #1 start_ch1 = 0;


        if (busy_ch1 === 1 && busy_ch0 === 0) begin

            stop_ch1 = 1;
            @(posedge clk);
            #1 stop_ch1 = 0;
            @(posedge clk);
            #1;

            check_outputs(0, 0, 8'h00, 8'hBC);
        end else begin
            $display("FAIL: Busy signal logic incorrect during transfer");
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
        $display("dma_controller Testbench");
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
        input expected_busy_ch0;
        input expected_busy_ch1;
        input [7:0] expected_data_out_ch0;
        input [7:0] expected_data_out_ch1;
        begin
            if (expected_busy_ch0 === (expected_busy_ch0 ^ busy_ch0 ^ expected_busy_ch0) &&
                expected_busy_ch1 === (expected_busy_ch1 ^ busy_ch1 ^ expected_busy_ch1) &&
                expected_data_out_ch0 === (expected_data_out_ch0 ^ data_out_ch0 ^ expected_data_out_ch0) &&
                expected_data_out_ch1 === (expected_data_out_ch1 ^ data_out_ch1 ^ expected_data_out_ch1)) begin
                $display("PASS");
                $display("  Outputs: busy_ch0=%b, busy_ch1=%b, data_out_ch0=%h, data_out_ch1=%h",
                         busy_ch0, busy_ch1, data_out_ch0, data_out_ch1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busy_ch0=%b, busy_ch1=%b, data_out_ch0=%h, data_out_ch1=%h",
                         expected_busy_ch0, expected_busy_ch1, expected_data_out_ch0, expected_data_out_ch1);
                $display("  Got:      busy_ch0=%b, busy_ch1=%b, data_out_ch0=%h, data_out_ch1=%h",
                         busy_ch0, busy_ch1, data_out_ch0, data_out_ch1);
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
        $dumpvars(0,clk, data_in, rst, start_ch0, start_ch1, stop_ch0, stop_ch1, busy_ch0, busy_ch1, data_out_ch0, data_out_ch1);
    end

endmodule
