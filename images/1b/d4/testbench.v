`timescale 1ns/1ps

module I2C_Controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg reset;
    reg start;
    reg valid;
    wire ack;
    wire busy;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    I2C_Controller dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .start(start),
        .valid(valid),
        .ack(ack),
        .busy(busy),
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
        valid = 0;
        data_in = 8'h00;
        repeat(5) @(posedge clk);
        #1 reset = 0;
        repeat(5) @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %0d: Sending data 0xA5", test_num);
        reset_dut();


        @(posedge clk);
        #1;
        data_in = 8'hA5;
        valid = 1;
        start = 1;


        wait(busy == 1);
        @(posedge clk);
        #1;
        start = 0;
        valid = 0;


        wait(busy == 0);
        repeat(5) @(posedge clk);


        #1;



        check_outputs(1'b1, 1'b0, 8'hA5);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %0d: Sending data 0x5A", test_num);
        reset_dut();

        @(posedge clk);
        #1;
        data_in = 8'h5A;
        valid = 1;
        start = 1;

        wait(busy == 1);
        @(posedge clk);
        #1;
        start = 0;
        valid = 0;

        wait(busy == 0);
        repeat(5) @(posedge clk);

        #1;


        check_outputs(1'b1, 1'b0, 8'h5A);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase %0d: Sending data 0xFF", test_num);
        reset_dut();

        @(posedge clk);
        #1;
        data_in = 8'hFF;
        valid = 1;
        start = 1;

        wait(busy == 1);
        @(posedge clk);
        #1;
        start = 0;
        valid = 0;

        wait(busy == 0);
        repeat(5) @(posedge clk);

        #1;


        check_outputs(1'b1, 1'b0, 8'hFF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase %0d: Sending data 0x00", test_num);
        reset_dut();

        @(posedge clk);
        #1;
        data_in = 8'h00;
        valid = 1;
        start = 1;

        wait(busy == 1);
        @(posedge clk);
        #1;
        start = 0;
        valid = 0;

        wait(busy == 0);
        repeat(5) @(posedge clk);

        #1;


        check_outputs(1'b1, 1'b0, 8'h00);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTestcase %0d: Reset during transaction", test_num);
        reset_dut();

        @(posedge clk);
        #1;
        data_in = 8'hAA;
        valid = 1;
        start = 1;

        wait(busy == 1);
        repeat(10) @(posedge clk);


        #1 reset = 1;
        repeat(5) @(posedge clk);
        #1 reset = 0;
        repeat(2) @(posedge clk);


        #1;



        check_outputs(1'b0, 1'b0, 8'h00);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("I2C_Controller Testbench");
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
        input expected_ack;
        input expected_busy;
        input [7:0] expected_data_out;
        begin
            if (expected_ack === (expected_ack ^ ack ^ expected_ack) &&
                expected_busy === (expected_busy ^ busy ^ expected_busy) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: ack=%b, busy=%b, data_out=%h",
                         ack, busy, data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack=%b, busy=%b, data_out=%h",
                         expected_ack, expected_busy, expected_data_out);
                $display("  Got:      ack=%b, busy=%b, data_out=%h",
                         ack, busy, data_out);
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
        $dumpvars(0,clk, data_in, reset, start, valid, ack, busy, data_out);
    end

endmodule
