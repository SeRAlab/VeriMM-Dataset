`timescale 1ns/1ps

module stop_and_wait_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg rst;
    reg send;
    wire ack;
    wire [7:0] data_out;
    wire sending;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    stop_and_wait dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .send(send),
        .ack(ack),
        .data_out(data_out),
        .sending(sending)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            send = 0;
            data_in = 8'h00;
            @(posedge clk);
            #2;
            rst = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Initial Reset State Check", test_num);
            reset_dut();

            repeat(2) @(posedge clk);


            #1;



            check_outputs(1'b0, 8'h00, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Single Data Transmission (0xA5)", test_num);
            reset_dut();

            data_in = 8'hA5;
            send = 1;
            @(posedge clk);
            #1;
            send = 0;


            wait(ack == 1'b1);


            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b1, 8'hA5, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Sequential Transmission (0x12 then 0x34)", test_num);
            reset_dut();


            data_in = 8'h12;
            send = 1;
            @(posedge clk);
            #1;
            send = 0;
            wait(ack == 1'b1);
            repeat(2) @(posedge clk);


            data_in = 8'h34;
            send = 1;
            @(posedge clk);
            #1;
            send = 0;
            wait(ack == 1'b1);

            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b1, 8'h34, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Idle Operation Check", test_num);
            reset_dut();

            data_in = 8'hFF;
            send = 0;

            repeat(5) @(posedge clk);


            #1;



            check_outputs(1'b0, 8'h00, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Sustained Send Signal", test_num);
            reset_dut();

            data_in = 8'h77;
            send = 1;


            wait(ack == 1'b1);



            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 8'h77, 1'b0);
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
        input expected_ack;
        input [7:0] expected_data_out;
        input expected_sending;
        begin
            if (expected_ack === (expected_ack ^ ack ^ expected_ack) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_sending === (expected_sending ^ sending ^ expected_sending)) begin
                $display("PASS");
                $display("  Outputs: ack=%b, data_out=%h, sending=%b",
                         ack, data_out, sending);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack=%b, data_out=%h, sending=%b",
                         expected_ack, expected_data_out, expected_sending);
                $display("  Got:      ack=%b, data_out=%h, sending=%b",
                         ack, data_out, sending);
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
        $dumpvars(0,clk, data_in, rst, send, ack, data_out, sending);
    end

endmodule
