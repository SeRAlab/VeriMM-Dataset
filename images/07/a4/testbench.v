`timescale 1ns/1ps

module DMA_Controller_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] channel_select;
    reg clk;
    reg [7:0] data_in;
    reg start;
    wire [7:0] data_out;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DMA_Controller dut (
        .channel_select(channel_select),
        .clk(clk),
        .data_in(data_in),
        .start(start),
        .data_out(data_out),
        .done(done)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            channel_select = 0;
            data_in = 0;
            start = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        integer timeout;
        begin
            test_num = 1;
            $display("Test Case %03d: Channel 0 transfer", test_num);
            reset_dut();

            channel_select = 2'b00;
            data_in = 8'hA5;
            start = 1;

            @(posedge clk);
            #1 start = 0;


            timeout = 0;
            while (!done && timeout < 10) begin
                @(posedge clk);
                timeout = timeout + 1;
            end

            #1;


            check_outputs(8'hA5, 1'b1);
        end
        endtask

    task testcase002;

        integer timeout;
        begin
            test_num = 2;
            $display("Test Case %03d: Channel 1 transfer", test_num);
            reset_dut();

            channel_select = 2'b01;
            data_in = 8'h5A;
            start = 1;

            @(posedge clk);
            #1 start = 0;

            timeout = 0;
            while (!done && timeout < 10) begin
                @(posedge clk);
                timeout = timeout + 1;
            end

            #1;


            check_outputs(8'h5A, 1'b1);
        end
        endtask

    task testcase003;

        integer timeout;
        begin
            test_num = 3;
            $display("Test Case %03d: Channel 2 transfer", test_num);
            reset_dut();

            channel_select = 2'b10;
            data_in = 8'hFF;
            start = 1;

            @(posedge clk);
            #1 start = 0;

            timeout = 0;
            while (!done && timeout < 10) begin
                @(posedge clk);
                timeout = timeout + 1;
            end

            #1;


            check_outputs(8'hFF, 1'b1);
        end
        endtask

    task testcase004;

        integer timeout;
        begin
            test_num = 4;
            $display("Test Case %03d: Channel 3 transfer", test_num);
            reset_dut();

            channel_select = 2'b11;
            data_in = 8'h00;
            start = 1;

            @(posedge clk);
            #1 start = 0;

            timeout = 0;
            while (!done && timeout < 10) begin
                @(posedge clk);
                timeout = timeout + 1;
            end

            #1;


            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %03d: Idle State (No Start)", test_num);
            reset_dut();

            channel_select = 2'b00;
            data_in = 8'hCC;
            start = 0;

            repeat(3) @(posedge clk);



            if (done === 1'b0) begin
                $display("PASS: Controller remained idle.");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Controller asserted done without start.");
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
        $display("DMA_Controller Testbench");
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
        input [7:0] expected_data_out;
        input expected_done;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, done=%b",
                         data_out, done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, done=%b",
                         expected_data_out, expected_done);
                $display("  Got:      data_out=%h, done=%b",
                         data_out, done);
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
        $dumpvars(0,channel_select, clk, data_in, start, data_out, done);
    end

endmodule
