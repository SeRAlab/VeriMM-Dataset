`timescale 1ns/1ps

module arq_system_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data_in;
    reg parity_in;
    reg rst;
    wire ack_out;
    wire retransmit;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    arq_system dut (
        .clk(clk),
        .data_in(data_in),
        .parity_in(parity_in),
        .rst(rst),
        .ack_out(ack_out),
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
            data_in = 0;
            parity_in = 0;
            repeat(2) @(posedge clk);
            rst = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Valid data 0, Parity 0", test_num);
            reset_dut();
            data_in = 0;
            parity_in = 0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Valid data 1, Parity 1", test_num);
            reset_dut();
            data_in = 1;
            parity_in = 1;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Invalid parity (Data 1, Parity 0)", test_num);
            reset_dut();
            data_in = 1;
            parity_in = 0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Invalid parity (Data 0, Parity 1)", test_num);
            reset_dut();
            data_in = 0;
            parity_in = 1;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Reset override during error", test_num);
            reset_dut();

            data_in = 1;
            parity_in = 0;
            repeat(2) @(posedge clk);

            rst = 1;
            @(posedge clk);
            #1;

            check_outputs(1'b0, 1'b0);
            rst = 0;
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Recovery (Error then Valid)", test_num);
            reset_dut();

            data_in = 1;
            parity_in = 0;
            repeat(2) @(posedge clk);

            data_in = 1;
            parity_in = 1;
            repeat(2) @(posedge clk);
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
        $display("arq_system Testbench");
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
        input expected_ack_out;
        input expected_retransmit;
        begin
            if (expected_ack_out === (expected_ack_out ^ ack_out ^ expected_ack_out) &&
                expected_retransmit === (expected_retransmit ^ retransmit ^ expected_retransmit)) begin
                $display("PASS");
                $display("  Outputs: ack_out=%b, retransmit=%b",
                         ack_out, retransmit);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack_out=%b, retransmit=%b",
                         expected_ack_out, expected_retransmit);
                $display("  Got:      ack_out=%b, retransmit=%b",
                         ack_out, retransmit);
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
        $dumpvars(0,clk, data_in, parity_in, rst, ack_out, retransmit);
    end

endmodule
