`timescale 1ns/1ps

module stop_and_wait_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg [7:0] data_in;
    reg reset;
    reg send;
    wire busy;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    stop_and_wait dut (
        .ack(ack),
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .send(send),
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
            reset = 1;
            send = 0;
            ack = 0;
            data_in = 8'h00;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running testcase%03d: Initial Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running testcase%03d: Single Successful Transmission", test_num);
            reset_dut();
            data_in = 8'hA5;
            send = 1;
            @(posedge clk);
            #1 send = 0;
            @(posedge clk);

            ack = 1;
            @(posedge clk);
            #1 ack = 0;
            @(posedge clk);

            #1;


            check_outputs(1'b0, 8'hA5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running testcase%03d: Stall State without Ack", test_num);
            reset_dut();
            data_in = 8'hFF;
            send = 1;
            @(posedge clk);
            #1 send = 0;

            repeat(5) @(posedge clk);

            #1;


            check_outputs(1'b1, 8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running testcase%03d: Ignore Transmission while Busy", test_num);
            reset_dut();


            data_in = 8'h11;
            send = 1;
            @(posedge clk);
            #1 send = 0;
            @(posedge clk);


            data_in = 8'h22;
            send = 1;
            @(posedge clk);
            #1 send = 0;


            ack = 1;
            @(posedge clk);
            #1 ack = 0;
            @(posedge clk);


            #1;



            check_outputs(1'b0, 8'h11);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running testcase%03d: Back-to-back Transmission", test_num);
            reset_dut();


            data_in = 8'hCC;
            send = 1;
            @(posedge clk);
            #1 send = 0;
            @(posedge clk);
            ack = 1;
            @(posedge clk);
            #1 ack = 0;
            @(posedge clk);


            data_in = 8'hDD;
            send = 1;
            @(posedge clk);
            #1 send = 0;
            @(posedge clk);
            ack = 1;
            @(posedge clk);
            #1 ack = 0;
            @(posedge clk);

            #1;


            check_outputs(1'b0, 8'hDD);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("stop_and_wait Testbench");
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
        $dumpvars(0,ack, clk, data_in, reset, send, busy, data_out);
    end

endmodule
