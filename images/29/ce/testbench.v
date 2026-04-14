`timescale 1ns/1ps

module ARQ_Error_Correction_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg parity_in;
    wire data_correct;
    wire request_retransmission;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ARQ_Error_Correction dut (
        .clk(clk),
        .data_in(data_in),
        .parity_in(parity_in),
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
            data_in = 8'b0;
            parity_in = 1'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Valid Data (8'h01, Parity 1)", test_num);
            reset_dut();
            data_in = 8'h01;
            parity_in = 1'b1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Invalid Data (8'h01, Parity 0)", test_num);
            reset_dut();
            data_in = 8'h01;
            parity_in = 1'b0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Valid Data (8'h03, Parity 0)", test_num);
            reset_dut();
            data_in = 8'h03;
            parity_in = 1'b0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros (8'h00, Parity 0)", test_num);
            reset_dut();
            data_in = 8'h00;
            parity_in = 1'b0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones (8'hFF, Parity 0)", test_num);
            reset_dut();
            data_in = 8'hFF;
            parity_in = 1'b0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones Error (8'hFF, Parity 1)", test_num);
            reset_dut();
            data_in = 8'hFF;
            parity_in = 1'b1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mixed Bits (8'hAA, Parity 0)", test_num);
            reset_dut();
            data_in = 8'hAA;
            parity_in = 1'b0;
            @(posedge clk);
            #2;
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
        $display("ARQ_Error_Correction Testbench");
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
        $dumpvars(0,clk, data_in, parity_in, data_correct, request_retransmission);
    end

endmodule
