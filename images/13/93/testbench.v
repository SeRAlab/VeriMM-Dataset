`timescale 1ns/1ps

module ARQ_System_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg [7:0] data_in;
    reg reset;
    wire retransmit;
    wire [7:0] sent_data;

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
        .retransmit(retransmit),
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
            data_in = 8'h00;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            data_in = 8'hA1;
            ack = 0;
            @(posedge clk);
            #1 ack = 1;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b0, 8'hA1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            data_in = 8'hB2;
            ack = 0;

            repeat(10) @(posedge clk);
            #1;

            check_outputs(1'b1, 8'hB2);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            data_in = 8'hC3;
            ack = 0;
            repeat(10) @(posedge clk);
            #1 ack = 1;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b0, 8'hC3);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            data_in = 8'hD4;
            @(posedge clk);
            #1 data_in = 8'hFF;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(retransmit, 8'hD4);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            data_in = 8'hE5;
            ack = 0;
            repeat(20) @(posedge clk);
            #1;

            check_outputs(1'b1, 8'hE5);
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
        input expected_retransmit;
        input [7:0] expected_sent_data;
        begin
            if (expected_retransmit === (expected_retransmit ^ retransmit ^ expected_retransmit) &&
                expected_sent_data === (expected_sent_data ^ sent_data ^ expected_sent_data)) begin
                $display("PASS");
                $display("  Outputs: retransmit=%b, sent_data=%h",
                         retransmit, sent_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: retransmit=%b, sent_data=%h",
                         expected_retransmit, expected_sent_data);
                $display("  Got:      retransmit=%b, sent_data=%h",
                         retransmit, sent_data);
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
        $dumpvars(0,ack, clk, data_in, reset, retransmit, sent_data);
    end

endmodule
