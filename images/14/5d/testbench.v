`timescale 1ns/1ps

module ARQ_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg reset;
    reg send_data;
    wire resend_data;
    wire sent_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ARQ dut (
        .ack(ack),
        .clk(clk),
        .reset(reset),
        .send_data(send_data),
        .resend_data(resend_data),
        .sent_data(sent_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            ack = 0;
            send_data = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Basic Success Transmission (Data: 1)", test_num);
            reset_dut();

            send_data = 1;
            ack = 1;

            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Basic Success Transmission (Data: 0)", test_num);
            reset_dut();

            send_data = 0;
            ack = 1;

            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: NACK Triggers Resend Signal", test_num);
            reset_dut();

            send_data = 1;
            ack = 0;

            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Recovery from NACK to ACK", test_num);
            reset_dut();


            send_data = 0;
            ack = 0;
            @(posedge clk);


            ack = 1;
            @(posedge clk);

            #1;

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Continuous NACK Handling", test_num);
            reset_dut();

            send_data = 1;
            ack = 0;


            repeat(3) @(posedge clk);

            #1;

            #1;


            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Verify Reset State", test_num);

            reset = 1;
            ack = 1;
            send_data = 1;
            @(posedge clk);
            #1;

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
        $display("ARQ Testbench");
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
        input expected_resend_data;
        input expected_sent_data;
        begin
            if (expected_resend_data === (expected_resend_data ^ resend_data ^ expected_resend_data) &&
                expected_sent_data === (expected_sent_data ^ sent_data ^ expected_sent_data)) begin
                $display("PASS");
                $display("  Outputs: resend_data=%b, sent_data=%b",
                         resend_data, sent_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: resend_data=%b, sent_data=%b",
                         expected_resend_data, expected_sent_data);
                $display("  Got:      resend_data=%b, sent_data=%b",
                         resend_data, sent_data);
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
        $dumpvars(0,ack, clk, reset, send_data, resend_data, sent_data);
    end

endmodule
