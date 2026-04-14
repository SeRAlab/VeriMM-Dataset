`timescale 1ns/1ps

module ARQ_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg [7:0] data_in;
    reg reset;
    wire [7:0] data_out;
    wire error;
    wire send;

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
        .error(error),
        .send(send)
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
        #2 reset = 0;
        @(posedge clk);
        $display("DUT Reset Complete.");
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %0d: Successful Transmission", test_num);
        reset_dut();

        data_in = 8'hA5;
        @(posedge clk);


        wait(send == 1);
        @(posedge clk);


        #2 ack = 1;
        @(posedge clk);
        #2 ack = 0;


        repeat(2) @(posedge clk);


        #1;



        check_outputs(8'hA5, 1'b0, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %0d: Timeout and Retransmission", test_num);
        reset_dut();

        data_in = 8'h5A;
        @(posedge clk);


        wait(send == 1);
        $display("  First send detected at %0t. Waiting for timeout...", $time);



        repeat(20) @(posedge clk);



        #1;




        check_outputs(8'h5A, 1'b0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase %0d: Parity Error Detection", test_num);
        reset_dut();




        data_in = 8'hFF;
        @(posedge clk);

        wait(send == 1);




        repeat(5) @(posedge clk);




        #1;





        check_outputs(8'hFF, 1'b0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase %0d: Recovery After Timeout", test_num);
        reset_dut();

        data_in = 8'h33;
        @(posedge clk);

        wait(send == 1);


        repeat(10) @(posedge clk);


        #2 ack = 1;
        @(posedge clk);
        #2 ack = 0;

        repeat(2) @(posedge clk);


        #1;



        check_outputs(8'h33, 1'b0, 1'b1);
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
        input expected_error;
        input expected_send;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_error === (expected_error ^ error ^ expected_error) &&
                expected_send === (expected_send ^ send ^ expected_send)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, error=%b, send=%b",
                         data_out, error, send);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, error=%b, send=%b",
                         expected_data_out, expected_error, expected_send);
                $display("  Got:      data_out=%h, error=%b, send=%b",
                         data_out, error, send);
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
        $dumpvars(0,ack, clk, data_in, reset, data_out, error, send);
    end

endmodule
