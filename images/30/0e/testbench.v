`timescale 1ns/1ps

module ARQ_Controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data_in;
    reg parity_in;
    reg rst;
    wire [1:0] attempts;
    wire request_resend;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ARQ_Controller dut (
        .clk(clk),
        .data_in(data_in),
        .parity_in(parity_in),
        .rst(rst),
        .attempts(attempts),
        .request_resend(request_resend)
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
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Success on first try (0,0)", test_num);
            reset_dut();
            data_in = 0;
            parity_in = 0;
            @(posedge clk);
            #2 #1;
 check_outputs(2'b00, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Success on first try (1,1)", test_num);
            reset_dut();
            data_in = 1;
            parity_in = 1;
            @(posedge clk);
            #2 #1;
 check_outputs(2'b00, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Failure on first try (1,0)", test_num);
            reset_dut();
            data_in = 1;
            parity_in = 0;
            @(posedge clk);
            #2 #1;
 check_outputs(2'b01, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Two consecutive failures", test_num);
            reset_dut();

            data_in = 0;
            parity_in = 1;
            @(posedge clk);

            #1;
            data_in = 1;
            parity_in = 0;
            @(posedge clk);
            #2 #1;
 check_outputs(2'b10, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum retransmissions (3 failures)", test_num);
            reset_dut();

            data_in = 1; parity_in = 0; @(posedge clk);

            #1; data_in = 1; parity_in = 0; @(posedge clk);

            #1; data_in = 1; parity_in = 0; @(posedge clk);
            #2 #1;
 check_outputs(2'b11, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Recovery after failure", test_num);
            reset_dut();

            data_in = 1; parity_in = 0; @(posedge clk);

            #1;
            data_in = 1; parity_in = 1; @(posedge clk);
            #2 #1;
 check_outputs(2'b00, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ARQ_Controller Testbench");
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
        input [1:0] expected_attempts;
        input expected_request_resend;
        begin
            if (expected_attempts === (expected_attempts ^ attempts ^ expected_attempts) &&
                expected_request_resend === (expected_request_resend ^ request_resend ^ expected_request_resend)) begin
                $display("PASS");
                $display("  Outputs: attempts=%h, request_resend=%b",
                         attempts, request_resend);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: attempts=%h, request_resend=%b",
                         expected_attempts, expected_request_resend);
                $display("  Got:      attempts=%h, request_resend=%b",
                         attempts, request_resend);
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
        $dumpvars(0,clk, data_in, parity_in, rst, attempts, request_resend);
    end

endmodule
