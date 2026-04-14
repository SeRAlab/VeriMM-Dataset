`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg channel_1_start;
    reg channel_2_start;
    reg clk;
    reg [7:0] data;
    reg [7:0] destination_address_1;
    reg [7:0] destination_address_2;
    reg rst;
    reg [7:0] source_address_1;
    reg [7:0] source_address_2;
    wire channel_1_done;
    wire channel_2_done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .channel_1_start(channel_1_start),
        .channel_2_start(channel_2_start),
        .clk(clk),
        .data(data),
        .destination_address_1(destination_address_1),
        .destination_address_2(destination_address_2),
        .rst(rst),
        .source_address_1(source_address_1),
        .source_address_2(source_address_2),
        .channel_1_done(channel_1_done),
        .channel_2_done(channel_2_done)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        channel_1_start = 0;
        channel_2_start = 0;
        source_address_1 = 8'h00;
        destination_address_1 = 8'h00;
        source_address_2 = 8'h00;
        destination_address_2 = 8'h00;
        data = 8'h00;
        repeat(2) @(posedge clk);
        #1 rst = 0;
        repeat(1) @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %0d: Channel 1 Single Transfer", test_num);
        reset_dut();

        source_address_1 = 8'hAA;
        destination_address_1 = 8'hBB;
        data = 8'h55;

        @(posedge clk);
        #1 channel_1_start = 1;
        @(posedge clk);
        #1 channel_1_start = 0;


        repeat(4) @(posedge clk);

        #2 #1;
 check_outputs(1, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %0d: Channel 2 Single Transfer", test_num);
        reset_dut();

        source_address_2 = 8'hCC;
        destination_address_2 = 8'hDD;
        data = 8'hAA;

        @(posedge clk);
        #1 channel_2_start = 1;
        @(posedge clk);
        #1 channel_2_start = 0;

        repeat(4) @(posedge clk);

        #2 #1;
 check_outputs(0, 1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase %0d: Simultaneous Dual Channel Transfer", test_num);
        reset_dut();

        source_address_1 = 8'h11;
        destination_address_1 = 8'h22;
        source_address_2 = 8'h33;
        destination_address_2 = 8'h44;

        @(posedge clk);
        #1;
        channel_1_start = 1;
        channel_2_start = 1;
        @(posedge clk);
        #1;
        channel_1_start = 0;
        channel_2_start = 0;

        repeat(4) @(posedge clk);

        #2 #1;
 check_outputs(1, 1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase %0d: Idle State Check", test_num);
        reset_dut();


        repeat(6) @(posedge clk);

        #2 #1;
 check_outputs(0, 0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTestcase %0d: Reset Mid-Transfer", test_num);
        reset_dut();

        @(posedge clk);
        #1 channel_1_start = 1;
        @(posedge clk);
        #1 channel_1_start = 0;


        repeat(2) @(posedge clk);


        #1 rst = 1;
        repeat(2) @(posedge clk);
        #1 rst = 0;


        repeat(4) @(posedge clk);

        #2 #1;
 check_outputs(0, 0);
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
        input expected_channel_1_done;
        input expected_channel_2_done;
        begin
            if (expected_channel_1_done === (expected_channel_1_done ^ channel_1_done ^ expected_channel_1_done) &&
                expected_channel_2_done === (expected_channel_2_done ^ channel_2_done ^ expected_channel_2_done)) begin
                $display("PASS");
                $display("  Outputs: channel_1_done=%b, channel_2_done=%b",
                         channel_1_done, channel_2_done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: channel_1_done=%b, channel_2_done=%b",
                         expected_channel_1_done, expected_channel_2_done);
                $display("  Got:      channel_1_done=%b, channel_2_done=%b",
                         channel_1_done, channel_2_done);
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
        $dumpvars(0,channel_1_start, channel_2_start, clk, data, destination_address_1, destination_address_2, rst, source_address_1, source_address_2, channel_1_done, channel_2_done);
    end

endmodule
