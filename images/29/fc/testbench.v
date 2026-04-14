`timescale 1ns/1ps

module stop_and_wait_arq_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg nack;
    reg rst;
    reg send_data;
    wire data_out;
    wire retransmit;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    stop_and_wait_arq dut (
        .ack(ack),
        .clk(clk),
        .nack(nack),
        .rst(rst),
        .send_data(send_data),
        .data_out(data_out),
        .retransmit(retransmit)
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
            nack = 0;
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
            $display("Test %03d: Reset State Verification", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Successful Transmission (ACK)", test_num);
            reset_dut();
            send_data = 1;
            @(posedge clk);
            #1 ack = 1;
            @(posedge clk);
            #1 ack = 0;

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Retransmission on NACK", test_num);
            reset_dut();
            send_data = 1;
            @(posedge clk);
            #1 nack = 1;
            @(posedge clk);
            #1 nack = 0;

            #1;


            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Retransmission on Timeout", test_num);
            reset_dut();
            send_data = 0;
            @(posedge clk);

            repeat(20) @(posedge clk);

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Multi-bit Sequence (1 then 0)", test_num);
            reset_dut();


            send_data = 1;
            @(posedge clk);
            #1 ack = 1;
            @(posedge clk);
            #1 ack = 0;


            send_data = 0;
            @(posedge clk);
            #1 ack = 1;
            @(posedge clk);
            #1 ack = 0;

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %03d: NACK then Recovery with ACK", test_num);
            reset_dut();

            send_data = 1;
            @(posedge clk);
            #1 nack = 1;
            @(posedge clk);
            #1 nack = 0;


            @(posedge clk);

            #1 ack = 1;
            @(posedge clk);
            #1 ack = 0;


            #1;



            check_outputs(1'b1, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("stop_and_wait_arq Testbench");
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
        input expected_data_out;
        input expected_retransmit;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_retransmit === (expected_retransmit ^ retransmit ^ expected_retransmit)) begin
                $display("PASS");
                $display("  Outputs: data_out=%b, retransmit=%b",
                         data_out, retransmit);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%b, retransmit=%b",
                         expected_data_out, expected_retransmit);
                $display("  Got:      data_out=%b, retransmit=%b",
                         data_out, retransmit);
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
        $dumpvars(0,ack, clk, nack, rst, send_data, data_out, retransmit);
    end

endmodule
