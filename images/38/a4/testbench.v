`timescale 1ns/1ps

module ARQ_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg [7:0] data_in;
    reg reset;
    wire [7:0] data_out;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ARQ dut (
        .ack(ack),
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .data_out(data_out),
        .state(state)
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
            #20;
            reset = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Send and ACK", test_num);
            reset_dut();


            data_in = 8'hA1;
            #10;


            ack = 1;
            #10;
            ack = 0;
            #20;


            #1;



            check_outputs(8'hA1, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Timeout and Retransmission", test_num);
            reset_dut();


            data_in = 8'hB2;
            #10;



            #100;



            #1;




            check_outputs(8'hB2, 2'b10);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Sliding Window Full", test_num);
            reset_dut();


            data_in = 8'h01; #10;

            data_in = 8'h02; #10;

            data_in = 8'h03; #10;

            data_in = 8'h04; #10;



            #1;




            check_outputs(8'h04, 2'b11);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Window Recovery via ACK", test_num);
            reset_dut();


            data_in = 8'h11; #10;
            data_in = 8'h22; #10;
            data_in = 8'h33; #10;
            data_in = 8'h44; #10;


            ack = 1;
            #40;
            ack = 0;
            #10;


            data_in = 8'h55;
            #10;



            #1;




            check_outputs(8'h55, 2'b01);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Mid-operation Reset", test_num);
            reset_dut();

            data_in = 8'hFF;
            #10;


            reset = 1;
            #20;
            reset = 0;
            #10;


            #1;



            check_outputs(8'h00, 2'b00);
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
        input [1:0] expected_state;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_state === (expected_state ^ state ^ expected_state)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, state=%h",
                         data_out, state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, state=%h",
                         expected_data_out, expected_state);
                $display("  Got:      data_out=%h, state=%h",
                         data_out, state);
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
        $dumpvars(0,ack, clk, data_in, reset, data_out, state);
    end

endmodule
