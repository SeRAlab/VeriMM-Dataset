`timescale 1ns/1ps

module ARQ_System_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] data_in;
    reg reset;
    wire data_correct;
    wire request_retransmission;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ARQ_System dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .data_correct(data_correct),
        .request_retransmission(request_retransmission)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data_in = 5'b0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 5'b00000 (Even Parity)", test_num);
            reset_dut();
            data_in = 5'b00000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 5'b00001 (Odd Parity)", test_num);
            reset_dut();
            data_in = 5'b00001;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 5'b10100 (Even Parity)", test_num);
            reset_dut();
            data_in = 5'b10100;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 5'b11100 (Odd Parity)", test_num);
            reset_dut();
            data_in = 5'b11100;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 5'b10111 (Even Parity)", test_num);
            reset_dut();
            data_in = 5'b10111;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 5'b11111 (Odd Parity)", test_num);
            reset_dut();
            data_in = 5'b11111;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0, 1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ARQ_System Testbench");
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
        input expected_data_correct;
        input expected_request_retransmission;
        begin
            if (expected_data_correct === (expected_data_correct ^ data_correct ^ expected_data_correct) &&
                expected_request_retransmission === (expected_request_retransmission ^ request_retransmission ^ expected_request_retransmission)) begin
                $display("PASS");
                $display("  Outputs: data_correct=%b, request_retransmission=%b",
                         data_correct, request_retransmission);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_correct=%b, request_retransmission=%b",
                         expected_data_correct, expected_request_retransmission);
                $display("  Got:      data_correct=%b, request_retransmission=%b",
                         data_correct, request_retransmission);
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
        $dumpvars(0,clk, data_in, reset, data_correct, request_retransmission);
    end

endmodule
