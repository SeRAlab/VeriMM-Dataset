`timescale 1ns/1ps

module ARQ_System_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg [7:0] data_in;
    reg nack;
    reg reset;
    wire [7:0] data_out;
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
        .nack(nack),
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
            $display("\nResetting System...");
            reset = 1;
            data_in = 8'h00;
            ack = 0;
            nack = 0;
            repeat (2) @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Normal Successful Transmission (ACK)", test_num);
            reset_dut();


            data_in = 8'hAA;
            @(posedge clk);
            #1;


            ack = 1;
            nack = 0;
            @(posedge clk);
            #1;
            ack = 0;


            #1;



            check_outputs(8'hAA, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Retransmission Request (NACK)", test_num);
            reset_dut();


            data_in = 8'hBB;
            @(posedge clk);


            nack = 1;
            ack = 0;
            @(posedge clk);
            #1;
            nack = 0;


            #1;



            check_outputs(8'hBB, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: NACK followed by successful recovery (ACK)", test_num);
            reset_dut();

            data_in = 8'hCC;
            @(posedge clk);


            nack = 1;
            @(posedge clk);
            #1;
            nack = 0;


            @(posedge clk);


            ack = 1;
            @(posedge clk);
            #1;
            ack = 0;


            #1;



            check_outputs(8'hCC, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Multiple consecutive NACKs", test_num);
            reset_dut();

            data_in = 8'hDD;
            @(posedge clk);


            repeat (3) begin
                nack = 1;
                @(posedge clk);
                #1;
                nack = 0;
                @(posedge clk);
            end


            #1;



            check_outputs(8'hDD, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Multiple unique packets sequence", test_num);
            reset_dut();


            data_in = 8'h11;
            @(posedge clk);
            ack = 1;
            @(posedge clk);
            #1;
            ack = 0;


            data_in = 8'h22;
            @(posedge clk);
            ack = 1;
            @(posedge clk);
            #1;
            ack = 0;


            data_in = 8'h33;
            @(posedge clk);
            ack = 1;
            @(posedge clk);
            #1;
            ack = 0;

            #1;


            check_outputs(8'h33, 1'b0);
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
        $dumpvars(0,ack, clk, data_in, nack, reset, data_out, retransmit);
    end

endmodule
