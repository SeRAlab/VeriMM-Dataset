`timescale 1ns/1ps

module sliding_window_protocol_tb;

    // Testbench signals (sequential circuit)
    reg ack_received;
    reg clk;
    reg [7:0] data_in;
    reg reset;
    reg send_enable;
    wire busy;
    wire [7:0] data_out;
    wire [3:0] window_status;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sliding_window_protocol dut (
        .ack_received(ack_received),
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .send_enable(send_enable),
        .busy(busy),
        .data_out(data_out),
        .window_status(window_status)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            ack_received = 0;
            data_in = 8'h00;
            send_enable = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: Reset State Verification", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 8'h00, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: Single Packet Transmission", test_num);
            reset_dut();

            data_in = 8'hA5;
            send_enable = 1;
            @(posedge clk);
            #1 send_enable = 0;
            @(posedge clk);


            #1;



            check_outputs(1'b0, 8'hA5, 4'h1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: Fill Window to Capacity", test_num);
            reset_dut();


            repeat(4) begin
                data_in = data_in + 8'h11;
                send_enable = 1;
                @(posedge clk);
                #1 send_enable = 0;
                @(posedge clk);
            end


            #1;



            check_outputs(1'b1, 8'h44, 4'h4);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Handle Acknowledgment", test_num);
            reset_dut();


            data_in = 8'h10; send_enable = 1; @(posedge clk); #1;
            data_in = 8'h20; send_enable = 1; @(posedge clk); #1;
            send_enable = 0;


            ack_received = 1;
            @(posedge clk);
            #1 ack_received = 0;
            @(posedge clk);


            #1;



            check_outputs(1'b0, 8'h20, 4'h1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: Full Window Recovery", test_num);
            reset_dut();


            repeat(4) begin
                send_enable = 1;
                @(posedge clk);
                #1;
            end
            send_enable = 0;


            ack_received = 1;
            repeat(4) @(posedge clk);
            #1 ack_received = 0;
            @(posedge clk);


            #1;



            check_outputs(1'b0, 8'h00, 4'h0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sliding_window_protocol Testbench");
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
        input [3:0] expected_window_status;
        begin
            if (expected_busy === (expected_busy ^ busy ^ expected_busy) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_window_status === (expected_window_status ^ window_status ^ expected_window_status)) begin
                $display("PASS");
                $display("  Outputs: busy=%b, data_out=%h, window_status=%h",
                         busy, data_out, window_status);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busy=%b, data_out=%h, window_status=%h",
                         expected_busy, expected_data_out, expected_window_status);
                $display("  Got:      busy=%b, data_out=%h, window_status=%h",
                         busy, data_out, window_status);
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
        $dumpvars(0,ack_received, clk, data_in, reset, send_enable, busy, data_out, window_status);
    end

endmodule
