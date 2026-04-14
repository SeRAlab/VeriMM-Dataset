`timescale 1ns/1ps

module i2c_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg rst;
    reg start;
    wire busy;
    wire sent;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    i2c_controller dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .start(start),
        .busy(busy),
        .sent(sent)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        start = 0;
        data_in = 8'h00;
        repeat (2) @(posedge clk);
        #1 rst = 0;
        repeat (2) @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %0d: Sending 0xA5", test_num);
        reset_dut();

        data_in = 8'hA5;
        start = 1;
        @(posedge clk);
        #1 start = 0;


        wait(sent == 1);
        @(posedge clk);


        #1;



        check_outputs(0, 1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %0d: Sending 0x00", test_num);
        reset_dut();

        data_in = 8'h00;
        start = 1;
        @(posedge clk);
        #1 start = 0;

        wait(sent == 1);
        @(posedge clk);

        #1;


        check_outputs(0, 1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase %0d: Sending 0xFF", test_num);
        reset_dut();

        data_in = 8'hFF;
        start = 1;
        @(posedge clk);
        #1 start = 0;

        wait(sent == 1);
        @(posedge clk);

        #1;


        check_outputs(0, 1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase %0d: Sequential Transmissions", test_num);
        reset_dut();


        data_in = 8'h12;
        start = 1;
        @(posedge clk);
        #1 start = 0;
        wait(sent == 1);
        @(posedge clk);


        data_in = 8'h34;
        start = 1;
        @(posedge clk);
        #1 start = 0;
        wait(sent == 1);
        @(posedge clk);

        #1;


        check_outputs(0, 1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("i2c_controller Testbench");
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
        input expected_busy;
        input expected_sent;
        begin
            if (expected_busy === (expected_busy ^ busy ^ expected_busy) &&
                expected_sent === (expected_sent ^ sent ^ expected_sent)) begin
                $display("PASS");
                $display("  Outputs: busy=%b, sent=%b",
                         busy, sent);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busy=%b, sent=%b",
                         expected_busy, expected_sent);
                $display("  Got:      busy=%b, sent=%b",
                         busy, sent);
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
        $dumpvars(0,clk, data_in, rst, start, busy, sent);
    end

endmodule
