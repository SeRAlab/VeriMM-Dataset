`timescale 1ns/1ps

module stop_and_wait_arq_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg data_in;
    reg rst;
    wire data_out;
    wire parity_out;
    wire retransmit;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    stop_and_wait_arq dut (
        .ack(ack),
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .data_out(data_out),
        .parity_out(parity_out),
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
            data_in = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Successful transmission of data 0", test_num);
            reset_dut();
            data_in = 0;
            ack = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Successful transmission of data 1", test_num);
            reset_dut();
            data_in = 1;
            ack = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Retransmission of data 0 (NACK -> ACK)", test_num);
            reset_dut();
            data_in = 0;
            ack = 0;
            @(posedge clk);
            #2;

            if (retransmit !== 1'b1) $display("  Note: Retransmit signal not high yet, waiting next cycle...");

            @(posedge clk);
            ack = 1;
            #2;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Retransmission of data 1 (NACK -> ACK)", test_num);
            reset_dut();
            data_in = 1;
            ack = 0;
            @(posedge clk);
            #2;

            @(posedge clk);
            ack = 1;
            #2;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Multiple Retransmissions for data 1", test_num);
            reset_dut();
            data_in = 1;
            ack = 0;
            repeat(3) @(posedge clk);
            #2;
            if (retransmit !== 1'b1) $display("  Warning: retransmit should be high during NACK sequence");

            ack = 1;
            @(posedge clk);
            #2;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset during operation", test_num);
            reset_dut();
            data_in = 1;
            ack = 0;
            @(posedge clk);
            rst = 1;
            @(posedge clk);
            #2;
            rst = 0;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0);
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
        input expected_parity_out;
        input expected_retransmit;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_parity_out === (expected_parity_out ^ parity_out ^ expected_parity_out) &&
                expected_retransmit === (expected_retransmit ^ retransmit ^ expected_retransmit)) begin
                $display("PASS");
                $display("  Outputs: data_out=%b, parity_out=%b, retransmit=%b",
                         data_out, parity_out, retransmit);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%b, parity_out=%b, retransmit=%b",
                         expected_data_out, expected_parity_out, expected_retransmit);
                $display("  Got:      data_out=%b, parity_out=%b, retransmit=%b",
                         data_out, parity_out, retransmit);
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
        $dumpvars(0,ack, clk, data_in, rst, data_out, parity_out, retransmit);
    end

endmodule
