`timescale 1ns/1ps

module ARQ_System_tb;

    // Testbench signals (sequential circuit)
    reg ack_nack;
    reg clk;
    reg [7:0] data_in;
    reg reset;
    wire [7:0] data_out;
    wire resend;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ARQ_System dut (
        .ack_nack(ack_nack),
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .data_out(data_out),
        .resend(resend)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            ack_nack = 1;
            data_in = 8'h00;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("\nRunning Testcase %0d: Successful Transmission", test_num);

            data_in = 8'hA5;
            ack_nack = 1;

            @(posedge clk);
            #2;


            #1;



            check_outputs(8'hA5, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("\nRunning Testcase %0d: Failed Transmission (NACK)", test_num);

            data_in = 8'h5A;
            ack_nack = 0;

            @(posedge clk);
            #2;


            #1;



            check_outputs(8'h5A, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("\nRunning Testcase %0d: Recovery from NACK to ACK", test_num);

            data_in = 8'h33;
            ack_nack = 0;
            @(posedge clk);

            #1 ack_nack = 1;
            @(posedge clk);
            #2;


            #1;



            check_outputs(8'h33, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("\nRunning Testcase %0d: Continuous NACKs", test_num);

            data_in = 8'hFF;
            ack_nack = 0;

            repeat(3) @(posedge clk);
            #2;


            #1;



            check_outputs(8'hFF, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("\nRunning Testcase %0d: Data Pattern Integrity", test_num);

            data_in = 8'hC3;
            ack_nack = 1;

            @(posedge clk);
            #2;

            #1;


            check_outputs(8'hC3, 1'b0);
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
        input [7:0] expected_data_out;
        input expected_resend;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_resend === (expected_resend ^ resend ^ expected_resend)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, resend=%b",
                         data_out, resend);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, resend=%b",
                         expected_data_out, expected_resend);
                $display("  Got:      data_out=%h, resend=%b",
                         data_out, resend);
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
        $dumpvars(0,ack_nack, clk, data_in, reset, data_out, resend);
    end

endmodule
