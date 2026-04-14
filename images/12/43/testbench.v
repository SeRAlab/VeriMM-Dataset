`timescale 1ns/1ps

module StopAndWait_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg [7:0] data_in;
    reg rst;
    reg sender_ready;
    wire busy;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    StopAndWait dut (
        .ack(ack),
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .sender_ready(sender_ready),
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
            rst = 1;
            ack = 0;
            sender_ready = 0;
            data_in = 8'h0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Send and ACK", test_num);
            reset_dut();

            data_in = 8'hA5;
            sender_ready = 1;
            @(posedge clk);
            #1 sender_ready = 0;


            repeat(2) @(posedge clk);
            #1 ack = 1;
            @(posedge clk);
            #1 ack = 0;
            repeat(1) @(posedge clk);

            #1;


            check_outputs(1'b0, 8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify Busy Signal", test_num);
            reset_dut();

            data_in = 8'h5A;
            sender_ready = 1;
            @(posedge clk);
            #1 sender_ready = 0;


            repeat(1) @(posedge clk);
            #1;

            check_outputs(1'b1, 8'h5A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Ignore Data During Busy", test_num);
            reset_dut();


            data_in = 8'h11;
            sender_ready = 1;
            @(posedge clk);
            #1 sender_ready = 0;


            repeat(1) @(posedge clk);
            data_in = 8'h22;
            sender_ready = 1;
            @(posedge clk);
            #1 sender_ready = 0;


            #1 ack = 1;
            @(posedge clk);
            #1 ack = 0;
            repeat(1) @(posedge clk);



            #1;




            check_outputs(1'b0, 8'h11);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Back-to-Back Transfers", test_num);
            reset_dut();


            data_in = 8'hCC;
            sender_ready = 1;
            @(posedge clk);
            #1 sender_ready = 0;
            repeat(1) @(posedge clk);
            #1 ack = 1;
            @(posedge clk);
            #1 ack = 0;


            repeat(1) @(posedge clk);
            data_in = 8'hDD;
            sender_ready = 1;
            @(posedge clk);
            #1 sender_ready = 0;
            repeat(1) @(posedge clk);
            #1 ack = 1;
            @(posedge clk);
            #1 ack = 0;
            repeat(1) @(posedge clk);

            #1;


            check_outputs(1'b0, 8'hDD);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset during Busy", test_num);
            reset_dut();

            data_in = 8'hFF;
            sender_ready = 1;
            @(posedge clk);
            #1 sender_ready = 0;

            repeat(1) @(posedge clk);

            #1 rst = 1;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(1) @(posedge clk);


            #1;



            check_outputs(1'b0, 8'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("StopAndWait Testbench");
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
        input expected_busy;
        input [7:0] expected_data_out;
        begin
            if (expected_busy === (expected_busy ^ busy ^ expected_busy) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: busy=%b, data_out=%h",
                         busy, data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busy=%b, data_out=%h",
                         expected_busy, expected_data_out);
                $display("  Got:      busy=%b, data_out=%h",
                         busy, data_out);
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
        $dumpvars(0,ack, clk, data_in, rst, sender_ready, busy, data_out);
    end

endmodule
