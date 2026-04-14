`timescale 1ns/1ps

module ARQ_System_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg [4:0] data_in;
    reg reset;
    wire [4:0] data_out;
    wire retransmit;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ARQ_System dut (
        .ack(ack),
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .data_out(data_out),
        .retransmit(retransmit)
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
        reset_dut();
        test_num = 1;
        $display("Running Testcase %03d: Basic Load (ACK=1)", test_num);
        data_in = 5'h1A;
        ack = 1;
        @(posedge clk);
        #2 #1;
 check_outputs(5'h1A, 1'b0);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Running Testcase %03d: Retransmit Signal (ACK=0)", test_num);
        data_in = 5'h0F;
        ack = 0;
        @(posedge clk);
        #2 #1;
 check_outputs(5'h00, 1'b1);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Running Testcase %03d: Sequential Success", test_num);

        data_in = 5'h05; ack = 1;
        @(posedge clk);

        #1 data_in = 5'h12; ack = 1;
        @(posedge clk);
        #2 #1;
 check_outputs(5'h12, 1'b0);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Running Testcase %03d: Data Persistence on NACK", test_num);

        data_in = 5'h0A; ack = 1;
        @(posedge clk);

        #1 data_in = 5'h1F; ack = 0;
        @(posedge clk);
        #2 #1;
 check_outputs(5'h0A, 1'b1);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Running Testcase %03d: Recovery after NACK", test_num);

        data_in = 5'h11; ack = 0;
        @(posedge clk);

        #1 data_in = 5'h11; ack = 1;
        @(posedge clk);
        #2 #1;
 check_outputs(5'h11, 1'b0);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        $display("Running Testcase %03d: All-Ones Data Check", test_num);
        data_in = 5'b11111;
        ack = 1;
        @(posedge clk);
        #2 #1;
 check_outputs(5'b11111, 1'b0);
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
        input [4:0] expected_data_out;
        input expected_retransmit;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_retransmit === (expected_retransmit ^ retransmit ^ expected_retransmit)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, retransmit=%b",
                         data_out, retransmit);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, retransmit=%b",
                         expected_data_out, expected_retransmit);
                $display("  Got:      data_out=%h, retransmit=%b",
                         data_out, retransmit);
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
        $dumpvars(0,ack, clk, data_in, reset, data_out, retransmit);
    end

endmodule
