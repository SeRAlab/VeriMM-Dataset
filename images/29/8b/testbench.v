`timescale 1ns/1ps

module ARQ_Error_Correction_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg [7:0] data_received;
    reg parity_received;
    reg reset;
    wire request_retransmit;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ARQ_Error_Correction dut (
        .clk(clk),
        .data_in(data_in),
        .data_received(data_received),
        .parity_received(parity_received),
        .reset(reset),
        .request_retransmit(request_retransmit)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data_in = 8'b0;
            data_received = 8'b0;
            parity_received = 1'b0;
            @(posedge clk);
            #2;
            reset = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All zeros, Parity 0 (Correct)", test_num);
            reset_dut();
            data_received = 8'b00000000;
            parity_received = 1'b0;
            data_in = 8'b00000000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: One bit set, Parity 1 (Correct)", test_num);
            reset_dut();
            data_received = 8'b00000001;
            parity_received = 1'b1;
            data_in = 8'b00000001;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: One bit set, Parity 0 (Error)", test_num);
            reset_dut();
            data_received = 8'b00000001;
            parity_received = 1'b0;
            data_in = 8'b00000001;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All bits set, Parity 0 (Correct)", test_num);
            reset_dut();
            data_received = 8'b11111111;
            parity_received = 1'b0;
            data_in = 8'b11111111;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All bits set, Parity 1 (Error)", test_num);
            reset_dut();
            data_received = 8'b11111111;
            parity_received = 1'b1;
            data_in = 8'b11111111;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating bits, Parity 0 (Correct)", test_num);
            reset_dut();
            data_received = 8'b10101010;
            parity_received = 1'b0;
            data_in = 8'b10101010;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating bits, Parity 1 (Error)", test_num);
            reset_dut();
            data_received = 8'b10101010;
            parity_received = 1'b1;
            data_in = 8'b10101010;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset behavior", test_num);
            reset_dut();
            #1;

            check_outputs(1'b0);
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
        testcase008();
        
        
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
        input expected_request_retransmit;
        begin
            if (expected_request_retransmit === (expected_request_retransmit ^ request_retransmit ^ expected_request_retransmit)) begin
                $display("PASS");
                $display("  Outputs: request_retransmit=%b",
                         request_retransmit);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: request_retransmit=%b",
                         expected_request_retransmit);
                $display("  Got:      request_retransmit=%b",
                         request_retransmit);
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
        $dumpvars(0,clk, data_in, data_received, parity_received, reset, request_retransmit);
    end

endmodule
