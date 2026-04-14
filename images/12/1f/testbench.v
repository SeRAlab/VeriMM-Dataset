`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] channel_select;
    reg clk;
    reg [7:0] data_in;
    reg reset;
    reg start;
    wire [7:0] data_out;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .channel_select(channel_select),
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
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
            reset = 1;
            start = 0;
            channel_select = 0;
            data_in = 0;
            #20;
            reset = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Channel 0 Transfer (Data: 0xAA)", test_num);
            reset_dut();

            @(negedge clk);
            channel_select = 2'b00;
            data_in = 8'hAA;
            start = 1;

            @(negedge clk);
            start = 0;


            wait(done == 1'b1);
            @(negedge clk);

            #1;


            check_outputs(8'hAA, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Channel 1 Transfer (Data: 0x55)", test_num);
            reset_dut();

            @(negedge clk);
            channel_select = 2'b01;
            data_in = 8'h55;
            start = 1;

            @(negedge clk);
            start = 0;


            wait(done == 1'b1);
            @(negedge clk);

            #1;


            check_outputs(8'h55, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Channel 0 Transfer (Data: 0xFF)", test_num);
            reset_dut();

            @(negedge clk);
            channel_select = 2'b00;
            data_in = 8'hFF;
            start = 1;

            @(negedge clk);
            start = 0;


            wait(done == 1'b1);
            @(negedge clk);

            #1;


            check_outputs(8'hFF, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Channel 1 Transfer (Data: 0x00)", test_num);
            reset_dut();

            @(negedge clk);
            channel_select = 2'b01;
            data_in = 8'h00;
            start = 1;

            @(negedge clk);
            start = 0;


            wait(done == 1'b1);
            @(negedge clk);

            #1;


            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Consecutive Transfers", test_num);
            reset_dut();


            @(negedge clk);
            channel_select = 2'b00;
            data_in = 8'h12;
            start = 1;
            @(negedge clk);
            start = 0;
            wait(done == 1'b1);
            @(negedge clk);


            @(negedge clk);
            channel_select = 2'b01;
            data_in = 8'h34;
            start = 1;
            @(negedge clk);
            start = 0;
            wait(done == 1'b1);
            @(negedge clk);

            #1;


            check_outputs(8'h34, 1'b1);
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
        $dumpvars(0,channel_select, clk, data_in, reset, start, data_out, done);
    end

endmodule
