`timescale 1ns/1ps

module stop_and_wait_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg rst;
    reg send_data;
    wire data_out;
    wire send_done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    stop_and_wait dut (
        .ack(ack),
        .clk(clk),
        .rst(rst),
        .send_data(send_data),
        .data_out(data_out),
        .send_done(send_done)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            send_data = 0;
            ack = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Single Successful Transmission", test_num);
            reset_dut();


            send_data = 1;
            @(posedge clk);
            send_data = 0;


            repeat(2) @(posedge clk);


            ack = 1;
            @(posedge clk);
            ack = 0;


            #1;
            #1;

            check_outputs(data_out, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Idle State (No send_data)", test_num);
            reset_dut();


            repeat(5) @(posedge clk);


            #1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Delayed ACK Transmission", test_num);
            reset_dut();


            send_data = 1;
            @(posedge clk);
            send_data = 0;


            repeat(10) @(posedge clk);


            if (send_done == 0) begin

                ack = 1;
                @(posedge clk);
                ack = 0;
                repeat(1) @(posedge clk);
                #1;
                #1;

                check_outputs(data_out, 1'b1);
            end else begin
                $display("FAIL: send_done asserted before ACK");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Consecutive Transmissions", test_num);
            reset_dut();


            send_data = 1;
            @(posedge clk);
            send_data = 0;
            repeat(2) @(posedge clk);
            ack = 1;
            @(posedge clk);
            ack = 0;
            @(posedge clk);


            send_data = 1;
            @(posedge clk);
            send_data = 0;
            repeat(2) @(posedge clk);
            ack = 1;
            @(posedge clk);
            ack = 0;

            repeat(1) @(posedge clk);
            #1;

            #1;


            check_outputs(data_out, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset during Wait for ACK", test_num);
            reset_dut();


            send_data = 1;
            @(posedge clk);
            send_data = 0;

            repeat(2) @(posedge clk);


            rst = 1;
            @(posedge clk);
            rst = 0;
            @(posedge clk);


            ack = 1;
            @(posedge clk);
            ack = 0;

            #1;

            #1;


            check_outputs(1'b0, 1'b0);
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
        input expected_data_out;
        input expected_send_done;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_send_done === (expected_send_done ^ send_done ^ expected_send_done)) begin
                $display("PASS");
                $display("  Outputs: data_out=%b, send_done=%b",
                         data_out, send_done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%b, send_done=%b",
                         expected_data_out, expected_send_done);
                $display("  Got:      data_out=%b, send_done=%b",
                         data_out, send_done);
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
        $dumpvars(0,ack, clk, rst, send_data, data_out, send_done);
    end

endmodule
