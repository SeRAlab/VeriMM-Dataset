`timescale 1ns/1ps

module ARQ_System_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg [4:0] data_in;
    reg rst;
    wire [4:0] data_out;
    wire done;
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
        .rst(rst),
        .data_out(data_out),
        .done(done),
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
            data_in = 5'b0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Immediate ACK", test_num);
            reset_dut();

            data_in = 5'h0A;

            @(posedge clk);
            #1 ack = 1;


            repeat(3) @(posedge clk);


            #1;



            check_outputs(5'h0A, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Success after 1 Retransmission", test_num);
            reset_dut();

            data_in = 5'h15;
            ack = 0;


            wait(retransmit == 1);
            @(posedge clk);


            #1 ack = 1;

            repeat(5) @(posedge clk);
            #1;

            check_outputs(5'h15, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Success on Last (3rd) Retransmission", test_num);
            reset_dut();

            data_in = 5'h1F;
            ack = 0;


            repeat(3) begin
                wait(retransmit == 1);
                @(posedge clk);
                wait(retransmit == 0);
            end


            #1 ack = 1;

            repeat(5) @(posedge clk);
            #1;

            check_outputs(5'h1F, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Transmission Failure (No ACK)", test_num);
            reset_dut();

            data_in = 5'h07;
            ack = 0;



            repeat(40) @(posedge clk);



            #1;




            check_outputs(data_out, 1'b1, 1'b0);
            if (fail_count == 0 && done == 1)
                $display("  Note: System correctly stopped after timeout.");
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Reset during retransmission", test_num);
            reset_dut();

            data_in = 5'h02;
            ack = 0;


            wait(retransmit == 1);
            repeat(2) @(posedge clk);


            #1 rst = 1;
            repeat(2) @(posedge clk);
            #1 rst = 0;


            #1;



            check_outputs(5'h00, 1'b0, 1'b0);
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
        input [4:0] expected_data_out;
        input expected_done;
        input expected_retransmit;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_done === (expected_done ^ done ^ expected_done) &&
                expected_retransmit === (expected_retransmit ^ retransmit ^ expected_retransmit)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, done=%b, retransmit=%b",
                         data_out, done, retransmit);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, done=%b, retransmit=%b",
                         expected_data_out, expected_done, expected_retransmit);
                $display("  Got:      data_out=%h, done=%b, retransmit=%b",
                         data_out, done, retransmit);
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
        $dumpvars(0,ack, clk, data_in, rst, data_out, done, retransmit);
    end

endmodule
