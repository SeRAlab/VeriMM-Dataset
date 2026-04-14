`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] channel_select;
    reg clk;
    reg [31:0] data_in;
    reg [15:0] mem_addr;
    reg reset;
    reg start;
    wire [1:0] active_channel;
    wire [31:0] data_out;
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
        .mem_addr(mem_addr),
        .reset(reset),
        .start(start),
        .active_channel(active_channel),
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
        mem_addr = 0;
        data_in = 0;
        repeat(2) @(posedge clk);
        #1 reset = 0;
        repeat(1) @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Channel 0 Transfer", test_num);
        reset_dut();

        @(negedge clk);
        channel_select = 2'b00;
        mem_addr = 16'h1000;
        data_in = 32'hAAAA_BBBB;
        start = 1;

        @(posedge clk);
        #2;
        #1;

        check_outputs(2'b00, 32'hAAAA_BBBB, 1'b1);

        @(negedge clk);
        start = 0;
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Channel 1 Transfer", test_num);
        reset_dut();

        @(negedge clk);
        channel_select = 2'b01;
        mem_addr = 16'h2000;
        data_in = 32'h1234_5678;
        start = 1;

        @(posedge clk);
        #2;
        #1;

        check_outputs(2'b01, 32'h1234_5678, 1'b1);

        @(negedge clk);
        start = 0;
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Channel 2 Transfer", test_num);
        reset_dut();

        @(negedge clk);
        channel_select = 2'b10;
        mem_addr = 16'h3000;
        data_in = 32'hDEAD_BEEF;
        start = 1;

        @(posedge clk);
        #2;
        #1;

        check_outputs(2'b10, 32'hDEAD_BEEF, 1'b1);

        @(negedge clk);
        start = 0;
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Channel 3 Transfer", test_num);
        reset_dut();

        @(negedge clk);
        channel_select = 2'b11;
        mem_addr = 16'hFFFF;
        data_in = 32'h5555_AAAA;
        start = 1;

        @(posedge clk);
        #2;
        #1;

        check_outputs(2'b11, 32'h5555_AAAA, 1'b1);

        @(negedge clk);
        start = 0;
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Idle State Check", test_num);
        reset_dut();

        @(negedge clk);
        channel_select = 2'b00;
        mem_addr = 16'h4000;
        data_in = 32'h8888_8888;
        start = 0;

        repeat(2) @(posedge clk);
        #2;


        if (done === 1'b0) begin
            $display("PASS: Controller remained idle.");
            pass_count = pass_count + 1;
        end else begin
            $display("FAIL: Controller signaled done without start.");
            fail_count = fail_count + 1;
        end
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Reset Recovery Check", test_num);
        reset_dut();


        #1;
        #1;

        check_outputs(2'b00, 32'h0, 1'b0);
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
        input [1:0] expected_active_channel;
        input [31:0] expected_data_out;
        input expected_done;
        begin
            if (expected_active_channel === (expected_active_channel ^ active_channel ^ expected_active_channel) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: active_channel=%h, data_out=%h, done=%b",
                         active_channel, data_out, done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: active_channel=%h, data_out=%h, done=%b",
                         expected_active_channel, expected_data_out, expected_done);
                $display("  Got:      active_channel=%h, data_out=%h, done=%b",
                         active_channel, data_out, done);
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
        $dumpvars(0,channel_select, clk, data_in, mem_addr, reset, start, active_channel, data_out, done);
    end

endmodule
