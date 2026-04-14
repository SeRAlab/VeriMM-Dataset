`timescale 1ns/1ps

module I2C_Master_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg [7:0] data_in;
    reg rst;
    wire [7:0] data_out;
    wire start;
    wire stop;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    I2C_Master dut (
        .ack(ack),
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .data_out(data_out),
        .start(start),
        .stop(stop)
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
            data_in = 8'h00;

            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Sending Data 8'hA5", test_num);
            reset_dut();

            data_in = 8'hA5;
            ack = 1;



            repeat(15) @(posedge clk);




            #1;





            check_outputs(8'hA5, 1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Sending Data 8'h5A", test_num);
            reset_dut();

            data_in = 8'h5A;
            ack = 1;

            repeat(15) @(posedge clk);

            #1;


            check_outputs(8'h5A, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Sending Data 8'hFF", test_num);
            reset_dut();

            data_in = 8'hFF;
            ack = 1;

            repeat(15) @(posedge clk);

            #1;


            check_outputs(8'hFF, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Sending Data 8'h00", test_num);
            reset_dut();

            data_in = 8'h00;
            ack = 1;

            repeat(15) @(posedge clk);

            #1;


            check_outputs(8'h00, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Handling NACK (ack=0) with Data 8'h12", test_num);
            reset_dut();

            data_in = 8'h12;
            ack = 0;

            repeat(15) @(posedge clk);

            #1;


            check_outputs(8'h12, 1'b0, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("I2C_Master Testbench");
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
        input expected_start;
        input expected_stop;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_start === (expected_start ^ start ^ expected_start) &&
                expected_stop === (expected_stop ^ stop ^ expected_stop)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, start=%b, stop=%b",
                         data_out, start, stop);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, start=%b, stop=%b",
                         expected_data_out, expected_start, expected_stop);
                $display("  Got:      data_out=%h, start=%b, stop=%b",
                         data_out, start, stop);
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
        $dumpvars(0,ack, clk, data_in, rst, data_out, start, stop);
    end

endmodule
