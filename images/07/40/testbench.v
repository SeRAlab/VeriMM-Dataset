`timescale 1ns/1ps

module stop_and_wait_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg rst;
    reg send_data;
    wire data_out;
    wire ready;

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
        .ready(ready)
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
            send_data = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Initial state after reset", test_num);
            reset_dut();


            #1;



            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Single packet transmission with ACK", test_num);
            reset_dut();


            send_data = 1;
            @(posedge clk);
            #1 send_data = 0;


            repeat(2) @(posedge clk);


            ack = 1;
            @(posedge clk);
            #1 ack = 0;


            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Sequential back-to-back transmissions", test_num);
            reset_dut();


            send_data = 1;
            @(posedge clk);
            #1 send_data = 0;
            repeat(2) @(posedge clk);
            ack = 1;
            @(posedge clk);
            #1 ack = 0;
            @(posedge clk);


            #1 send_data = 1;
            @(posedge clk);
            #1 send_data = 0;
            repeat(2) @(posedge clk);
            ack = 1;
            @(posedge clk);
            #1 ack = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Protocol stays busy without ACK", test_num);
            reset_dut();


            send_data = 1;
            @(posedge clk);
            #1 send_data = 0;


            repeat(10) @(posedge clk);
            #1;




            #1;





            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Ignore send_data during busy state", test_num);
            reset_dut();


            send_data = 1;
            @(posedge clk);
            #1 send_data = 0;


            repeat(2) @(posedge clk);
            #1 send_data = 1;
            @(posedge clk);
            #1 send_data = 0;


            #1;
            if (ready == 0) begin

                 ack = 1;
                 @(posedge clk);
                 #1 ack = 0;
                 @(posedge clk);
                 #1;

                 #1;


                 check_outputs(1'b0, 1'b1);
            end else begin

                 #1;


                 check_outputs(1'b0, 1'b0);
            end
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
        input expected_ready;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_ready === (expected_ready ^ ready ^ expected_ready)) begin
                $display("PASS");
                $display("  Outputs: data_out=%b, ready=%b",
                         data_out, ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%b, ready=%b",
                         expected_data_out, expected_ready);
                $display("  Got:      data_out=%b, ready=%b",
                         data_out, ready);
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
        $dumpvars(0,ack, clk, rst, send_data, data_out, ready);
    end

endmodule
