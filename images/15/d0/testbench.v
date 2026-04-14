`timescale 1ns/1ps

module arq_protocol_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg [4:0] data_in;
    reg reset;
    wire [4:0] data_out;
    wire resend;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    arq_protocol dut (
        .ack(ack),
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
            ack = 0;
            data_in = 5'b0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Immediate ACK...");
            reset_dut();
            data_in = 5'h1A;
            ack = 1;
            repeat (2) @(posedge clk);

            #1;


            check_outputs(5'h1A, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Timeout (No ACK)...");
            reset_dut();
            data_in = 5'h0F;
            ack = 0;

            repeat (10) @(posedge clk);

            #1;


            check_outputs(5'h0F, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Late ACK recovery...");
            reset_dut();
            data_in = 5'h05;
            ack = 0;

            repeat (10) @(posedge clk);


            ack = 1;
            @(posedge clk);
            #1;


            #1;



            check_outputs(5'h05, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Data change...");
            reset_dut();
            data_in = 5'h11;
            ack = 1;
            @(posedge clk);
            data_in = 5'h1E;
            repeat (2) @(posedge clk);

            #1;


            check_outputs(5'h1E, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("arq_protocol Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        $dumpvars(0,ack, clk, data_in, reset, data_out, resend);
    end

endmodule
