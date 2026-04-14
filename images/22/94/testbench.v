`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg [3:0] channel_req;
    reg clk;
    reg [7:0] data_in;
    reg rst;
    reg start;
    wire [3:0] channel_busy;
    wire [7:0] data_out;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .ack(ack),
        .channel_req(channel_req),
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .start(start),
        .channel_busy(channel_busy),
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
            rst = 1;
            ack = 0;
            channel_req = 4'b0000;
            data_in = 8'h00;
            start = 0;
            #20;
            rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Initial Reset and Idle Check", test_num);
            reset_dut();

            #1;


            check_outputs(4'b0000, 8'h00, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Channel 0 Transfer", test_num);
            reset_dut();

            @(posedge clk);
            data_in = 8'hAA;
            channel_req = 4'b0001;
            start = 1;

            @(posedge clk);
            start = 0;

            #10;
            ack = 1;


            @(posedge done);
            @(posedge clk);
            ack = 0;


            #1;



            check_outputs(4'b0000, 8'hAA, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Channel 2 Transfer", test_num);
            reset_dut();

            @(posedge clk);
            data_in = 8'h55;
            channel_req = 4'b0100;
            start = 1;

            @(posedge clk);
            start = 0;
            #10;
            ack = 1;

            @(posedge done);
            @(posedge clk);
            ack = 0;

            #1;


            check_outputs(4'b0000, 8'h55, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Channel 3 Transfer", test_num);
            reset_dut();

            @(posedge clk);
            data_in = 8'hFF;
            channel_req = 4'b1000;
            start = 1;

            @(posedge clk);
            start = 0;
            #10;
            ack = 1;

            @(posedge done);
            @(posedge clk);
            ack = 0;

            #1;


            check_outputs(4'b0000, 8'hFF, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Simultaneous Channel Request (0 and 1)", test_num);
            reset_dut();

            @(posedge clk);
            data_in = 8'hB1;
            channel_req = 4'b0011;
            start = 1;

            @(posedge clk);
            start = 0;


            #10;
            ack = 1;

            @(posedge done);
            @(posedge clk);
            ack = 0;


            if (data_out == 8'hB1 && (channel_busy == 4'b0000))
                #1;

                check_outputs(4'b0000, 8'hB1, 1'b1);
            else
                #1;

                check_outputs(4'b0000, 8'hB1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Busy Status Verification", test_num);
            reset_dut();

            @(posedge clk);
            data_in = 8'h12;
            channel_req = 4'b0010;
            start = 1;

            @(posedge clk);
            start = 0;


            #2;
            if (channel_busy == 4'b0010) begin
                $display("  Sub-check: Channel 1 Busy signal correctly asserted.");
            end else begin
                $display("  Sub-check: FAIL - Channel 1 Busy signal not asserted. Got: %b", channel_busy);
            end

            ack = 1;
            @(posedge done);
            @(posedge clk);
            ack = 0;

            #1;


            check_outputs(4'b0000, 8'h12, 1'b1);
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
        input [3:0] expected_channel_busy;
        input [7:0] expected_data_out;
        input expected_done;
        begin
            if (expected_channel_busy === (expected_channel_busy ^ channel_busy ^ expected_channel_busy) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: channel_busy=%h, data_out=%h, done=%b",
                         channel_busy, data_out, done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: channel_busy=%h, data_out=%h, done=%b",
                         expected_channel_busy, expected_data_out, expected_done);
                $display("  Got:      channel_busy=%h, data_out=%h, done=%b",
                         channel_busy, data_out, done);
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
        $dumpvars(0,ack, channel_req, clk, data_in, rst, start, channel_busy, data_out, done);
    end

endmodule
