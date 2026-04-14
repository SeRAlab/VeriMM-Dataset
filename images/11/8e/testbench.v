`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in_chan1;
    reg [7:0] data_in_chan2;
    reg reset;
    reg start_chan1;
    reg start_chan2;
    wire busy_chan1;
    wire busy_chan2;
    wire [7:0] data_out_chan1;
    wire [7:0] data_out_chan2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .data_in_chan1(data_in_chan1),
        .data_in_chan2(data_in_chan2),
        .reset(reset),
        .start_chan1(start_chan1),
        .start_chan2(start_chan2),
        .busy_chan1(busy_chan1),
        .busy_chan2(busy_chan2),
        .data_out_chan1(data_out_chan1),
        .data_out_chan2(data_out_chan2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            start_chan1 = 0;
            start_chan2 = 0;
            data_in_chan1 = 8'h00;
            data_in_chan2 = 8'h00;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Channel 1 Single Transfer", test_num);
            reset_dut();

            data_in_chan1 = 8'hA5;
            start_chan1 = 1;
            @(posedge clk);
            #1 start_chan1 = 0;


            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b0, 1'b0, 8'hA5, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Channel 2 Single Transfer", test_num);
            reset_dut();

            data_in_chan2 = 8'h5A;
            start_chan2 = 1;
            @(posedge clk);
            #1 start_chan2 = 0;

            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b0, 1'b0, 8'h00, 8'h5A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simultaneous Transfer Both Channels", test_num);
            reset_dut();

            data_in_chan1 = 8'h11;
            data_in_chan2 = 8'h22;
            start_chan1 = 1;
            start_chan2 = 1;
            @(posedge clk);
            #1 start_chan1 = 0;
            start_chan2 = 0;

            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b0, 1'b0, 8'h11, 8'h22);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Idle State Check", test_num);
            reset_dut();

            data_in_chan1 = 8'hFF;
            data_in_chan2 = 8'hEE;


            repeat(3) @(posedge clk);

            #1;


            check_outputs(1'b0, 1'b0, 8'h00, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max Value Transfers", test_num);
            reset_dut();

            data_in_chan1 = 8'hFF;
            data_in_chan2 = 8'hFF;
            start_chan1 = 1;
            start_chan2 = 1;
            @(posedge clk);
            #1 start_chan1 = 0;
            start_chan2 = 0;

            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b0, 1'b0, 8'hFF, 8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sequential Channel Hits", test_num);
            reset_dut();


            data_in_chan1 = 8'h01;
            start_chan1 = 1;
            @(posedge clk);
            #1 start_chan1 = 0;
            repeat(2) @(posedge clk);


            data_in_chan2 = 8'h02;
            start_chan2 = 1;
            @(posedge clk);
            #1 start_chan2 = 0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b0, 1'b0, 8'h01, 8'h02);
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
        input expected_busy_chan1;
        input expected_busy_chan2;
        input [7:0] expected_data_out_chan1;
        input [7:0] expected_data_out_chan2;
        begin
            if (expected_busy_chan1 === (expected_busy_chan1 ^ busy_chan1 ^ expected_busy_chan1) &&
                expected_busy_chan2 === (expected_busy_chan2 ^ busy_chan2 ^ expected_busy_chan2) &&
                expected_data_out_chan1 === (expected_data_out_chan1 ^ data_out_chan1 ^ expected_data_out_chan1) &&
                expected_data_out_chan2 === (expected_data_out_chan2 ^ data_out_chan2 ^ expected_data_out_chan2)) begin
                $display("PASS");
                $display("  Outputs: busy_chan1=%b, busy_chan2=%b, data_out_chan1=%h, data_out_chan2=%h",
                         busy_chan1, busy_chan2, data_out_chan1, data_out_chan2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busy_chan1=%b, busy_chan2=%b, data_out_chan1=%h, data_out_chan2=%h",
                         expected_busy_chan1, expected_busy_chan2, expected_data_out_chan1, expected_data_out_chan2);
                $display("  Got:      busy_chan1=%b, busy_chan2=%b, data_out_chan1=%h, data_out_chan2=%h",
                         busy_chan1, busy_chan2, data_out_chan1, data_out_chan2);
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
        $dumpvars(0,clk, data_in_chan1, data_in_chan2, reset, start_chan1, start_chan2, busy_chan1, busy_chan2, data_out_chan1, data_out_chan2);
    end

endmodule
