`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] channel_select;
    reg clk;
    reg read_write;
    reg rst;
    reg start;
    wire [1:0] current_state;
    wire [1:0] transfer_complete;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .channel_select(channel_select),
        .clk(clk),
        .read_write(read_write),
        .rst(rst),
        .start(start),
        .current_state(current_state),
        .transfer_complete(transfer_complete)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        channel_select = 2'b00;
        read_write = 0;
        start = 0;
        repeat(2) @(posedge clk);
        rst = 0;
        repeat(1) @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Basic Transfer on Channel 0", test_num);
        reset_dut();


        channel_select = 2'b01;
        read_write = 1;
        start = 1;
        @(posedge clk);
        start = 0;



        repeat(10) @(posedge clk);


        #1;



        check_outputs(2'b00, 2'b01);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Basic Transfer on Channel 1", test_num);
        reset_dut();


        channel_select = 2'b10;
        read_write = 1;
        start = 1;
        @(posedge clk);
        start = 0;

        repeat(10) @(posedge clk);


        #1;



        check_outputs(2'b00, 2'b10);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Idle State Check", test_num);
        reset_dut();


        channel_select = 2'b01;
        read_write = 1;
        start = 0;

        repeat(5) @(posedge clk);


        #1;



        check_outputs(2'b00, 2'b00);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Consecutive Transfers", test_num);
        reset_dut();


        channel_select = 2'b01;
        start = 1;
        read_write = 1;
        @(posedge clk);
        start = 0;
        repeat(8) @(posedge clk);


        channel_select = 2'b10;
        start = 1;
        @(posedge clk);
        start = 0;
        repeat(8) @(posedge clk);




        #1;





        check_outputs(2'b00, 2'b10);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Reset during transfer", test_num);
        reset_dut();

        channel_select = 2'b01;
        start = 1;
        read_write = 1;
        @(posedge clk);
        start = 0;


        repeat(2) @(posedge clk);


        rst = 1;
        repeat(2) @(posedge clk);
        rst = 0;
        @(posedge clk);


        #1;



        check_outputs(2'b00, 2'b00);
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
        input [1:0] expected_current_state;
        input [1:0] expected_transfer_complete;
        begin
            if (expected_current_state === (expected_current_state ^ current_state ^ expected_current_state) &&
                expected_transfer_complete === (expected_transfer_complete ^ transfer_complete ^ expected_transfer_complete)) begin
                $display("PASS");
                $display("  Outputs: current_state=%h, transfer_complete=%h",
                         current_state, transfer_complete);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: current_state=%h, transfer_complete=%h",
                         expected_current_state, expected_transfer_complete);
                $display("  Got:      current_state=%h, transfer_complete=%h",
                         current_state, transfer_complete);
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
        $dumpvars(0,channel_select, clk, read_write, rst, start, current_state, transfer_complete);
    end

endmodule
