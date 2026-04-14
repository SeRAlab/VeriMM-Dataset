`timescale 1ns/1ps

module arq_system_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] data_in;
    reg parity_in;
    reg reset;
    wire [4:0] data_out;
    wire is_correct;
    wire request_retransmission;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    arq_system dut (
        .clk(clk),
        .data_in(data_in),
        .parity_in(parity_in),
        .reset(reset),
        .data_out(data_out),
        .is_correct(is_correct),
        .request_retransmission(request_retransmission)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            reset = 1;
            data_in = 0;
            parity_in = 0;
            @(posedge clk);
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Valid transmission (01010, P=0)", test_num);
            reset_dut();
            data_in = 5'b01010;
            parity_in = 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'b01010, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Erroneous transmission (01010, P=1)", test_num);
            reset_dut();
            data_in = 5'b01010;
            parity_in = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(data_out, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Valid transmission (11111, P=1)", test_num);
            reset_dut();
            data_in = 5'b11111;
            parity_in = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'b11111, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Erroneous transmission (11111, P=0)", test_num);
            reset_dut();
            data_in = 5'b11111;
            parity_in = 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(data_out, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Valid transmission (00000, P=0)", test_num);
            reset_dut();
            data_in = 5'b00000;
            parity_in = 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'b00000, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Erroneous transmission (10001, P=1)", test_num);
            reset_dut();
            data_in = 5'b10001;
            parity_in = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(data_out, 1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Valid transmission (00111, P=1)", test_num);
            reset_dut();
            data_in = 5'b00111;
            parity_in = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'b00111, 1'b1, 1'b0);
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
        testcase007();
        
        
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
        input [4:0] expected_data_out;
        input expected_is_correct;
        input expected_request_retransmission;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_is_correct === (expected_is_correct ^ is_correct ^ expected_is_correct) &&
                expected_request_retransmission === (expected_request_retransmission ^ request_retransmission ^ expected_request_retransmission)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, is_correct=%b, request_retransmission=%b",
                         data_out, is_correct, request_retransmission);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, is_correct=%b, request_retransmission=%b",
                         expected_data_out, expected_is_correct, expected_request_retransmission);
                $display("  Got:      data_out=%h, is_correct=%b, request_retransmission=%b",
                         data_out, is_correct, request_retransmission);
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
        $dumpvars(0,clk, data_in, parity_in, reset, data_out, is_correct, request_retransmission);
    end

endmodule
