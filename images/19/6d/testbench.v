`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg req_chan0;
    reg req_chan1;
    reg rst;
    wire ack_chan0;
    wire ack_chan1;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .req_chan0(req_chan0),
        .req_chan1(req_chan1),
        .rst(rst),
        .ack_chan0(ack_chan0),
        .ack_chan1(ack_chan1),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            req_chan0 = 0;
            req_chan1 = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest %0d: Idle State", test_num);
            reset_dut();
            req_chan0 = 0;
            req_chan1 = 0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b0, 1'b0, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest %0d: Channel 0 Single Request", test_num);
            reset_dut();
            req_chan0 = 1;
            req_chan1 = 0;
            repeat(2) @(posedge clk);


            #1;



            check_outputs(1'b1, 1'b0, data_out);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest %0d: Channel 1 Single Request", test_num);
            reset_dut();
            req_chan0 = 0;
            req_chan1 = 1;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b0, 1'b1, data_out);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest %0d: Priority Arbitration (Ch0 > Ch1)", test_num);
            reset_dut();
            req_chan0 = 1;
            req_chan1 = 1;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b1, 1'b0, data_out);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest %0d: Sequential Channel Servicing", test_num);
            reset_dut();

            req_chan0 = 1;
            req_chan1 = 1;
            repeat(2) @(posedge clk);

            req_chan0 = 0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b0, 1'b1, data_out);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTest %0d: Reset during operation", test_num);
            reset_dut();
            req_chan0 = 1;
            repeat(2) @(posedge clk);

            rst = 1;
            @(posedge clk);

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
        input expected_ack_chan0;
        input expected_ack_chan1;
        input [7:0] expected_data_out;
        begin
            if (expected_ack_chan0 === (expected_ack_chan0 ^ ack_chan0 ^ expected_ack_chan0) &&
                expected_ack_chan1 === (expected_ack_chan1 ^ ack_chan1 ^ expected_ack_chan1) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: ack_chan0=%b, ack_chan1=%b, data_out=%h",
                         ack_chan0, ack_chan1, data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack_chan0=%b, ack_chan1=%b, data_out=%h",
                         expected_ack_chan0, expected_ack_chan1, expected_data_out);
                $display("  Got:      ack_chan0=%b, ack_chan1=%b, data_out=%h",
                         ack_chan0, ack_chan1, data_out);
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
        $dumpvars(0,clk, req_chan0, req_chan1, rst, ack_chan0, ack_chan1, data_out);
    end

endmodule
