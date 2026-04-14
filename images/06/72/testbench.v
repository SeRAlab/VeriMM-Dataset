`timescale 1ns/1ps

module ARQ_System_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg rst;
    reg send;
    wire [2:0] packet_id;
    wire retransmit;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ARQ_System dut (
        .ack(ack),
        .clk(clk),
        .rst(rst),
        .send(send),
        .packet_id(packet_id),
        .retransmit(retransmit)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            ack = 0;
            send = 0;
            repeat(2) @(posedge clk);
            rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(3'd0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            send = 1;
            @(posedge clk);
            send = 0;
            @(posedge clk);

            ack = 1;
            @(posedge clk);
            ack = 0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(3'd1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            send = 1;
            @(posedge clk);
            send = 0;

            repeat(15) @(posedge clk);

            #1;


            check_outputs(3'd0, 1'b1);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            reset_dut();
            send = 1;
            @(posedge clk);
            send = 0;


            for (i = 0; i < 4; i = i + 1) begin
                @(posedge clk);
                ack = 1;
                @(posedge clk);
                ack = 0;
                repeat(2) @(posedge clk);
            end


            #1;



            check_outputs(3'd4, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            send = 1;
            @(posedge clk);
            send = 0;


            repeat(15) @(posedge clk);


            ack = 1;
            @(posedge clk);
            ack = 0;
            repeat(2) @(posedge clk);


            #1;



            check_outputs(3'd1, 1'b0);
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
        input [2:0] expected_packet_id;
        input expected_retransmit;
        begin
            if (expected_packet_id === (expected_packet_id ^ packet_id ^ expected_packet_id) &&
                expected_retransmit === (expected_retransmit ^ retransmit ^ expected_retransmit)) begin
                $display("PASS");
                $display("  Outputs: packet_id=%h, retransmit=%b",
                         packet_id, retransmit);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: packet_id=%h, retransmit=%b",
                         expected_packet_id, expected_retransmit);
                $display("  Got:      packet_id=%h, retransmit=%b",
                         packet_id, retransmit);
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
        $dumpvars(0,ack, clk, rst, send, packet_id, retransmit);
    end

endmodule
