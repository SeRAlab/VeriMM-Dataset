`timescale 1ns/1ps

module arq_system_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg data_in;
    reg nack;
    reg rst;
    wire ack_out;
    wire data_out;
    wire err;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    arq_system dut (
        .ack(ack),
        .clk(clk),
        .data_in(data_in),
        .nack(nack),
        .rst(rst),
        .ack_out(ack_out),
        .data_out(data_out),
        .err(err)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            data_in = 0;
            ack = 0;
            nack = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning Testcase 001: Successful transmission (Data=1)");
            test_num = 1;
            reset_dut();

            data_in = 1;
            @(posedge clk);
            #1 ack = 1;
            @(posedge clk);
            #1 ack = 0;


            #1;



            check_outputs(1, 1, 0);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Testcase 002: Successful transmission (Data=0)");
            test_num = 2;
            reset_dut();

            data_in = 0;
            @(posedge clk);
            #1 ack = 1;
            @(posedge clk);
            #1 ack = 0;

            #1;


            check_outputs(1, 0, 0);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Testcase 003: Retransmission via NACK");
            test_num = 3;
            reset_dut();

            data_in = 1;
            @(posedge clk);
            #1 nack = 1;
            @(posedge clk);
            #1 nack = 0;



            @(posedge clk);
            #1 ack = 1;
            @(posedge clk);
            #1 ack = 0;

            #1;


            check_outputs(1, 1, 0);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Testcase 004: Retransmission via Timeout");
            test_num = 4;
            reset_dut();

            data_in = 1;

            repeat(10) @(posedge clk);


            #1 ack = 1;
            @(posedge clk);
            #1 ack = 0;

            #1;


            check_outputs(1, 1, 0);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning Testcase 005: Persistent NACK scenario");
            test_num = 5;
            reset_dut();

            data_in = 0;
            @(posedge clk);


            repeat(3) begin
                #1 nack = 1;
                @(posedge clk);
                #1 nack = 0;
                @(posedge clk);
            end


            #1 ack = 1;
            @(posedge clk);
            #1 ack = 0;

            #1;


            check_outputs(1, 0, 0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("arq_system Testbench");
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
        input expected_ack_out;
        input expected_data_out;
        input expected_err;
        begin
            if (expected_ack_out === (expected_ack_out ^ ack_out ^ expected_ack_out) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_err === (expected_err ^ err ^ expected_err)) begin
                $display("PASS");
                $display("  Outputs: ack_out=%b, data_out=%b, err=%b",
                         ack_out, data_out, err);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack_out=%b, data_out=%b, err=%b",
                         expected_ack_out, expected_data_out, expected_err);
                $display("  Got:      ack_out=%b, data_out=%b, err=%b",
                         ack_out, data_out, err);
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
        $dumpvars(0,ack, clk, data_in, nack, rst, ack_out, data_out, err);
    end

endmodule
