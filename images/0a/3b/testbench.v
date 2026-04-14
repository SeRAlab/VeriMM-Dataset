`timescale 1ns/1ps

module reed_solomon_encoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg rst;
    reg start;
    wire [15:0] encoded_out;
    wire ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    reed_solomon_encoder dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .start(start),
        .encoded_out(encoded_out),
        .ready(ready)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            start = 0;
            data_in = 8'h00;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
            $display("Reset complete.");
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: All Zeros Input", test_num);
            reset_dut();


            data_in = 8'h00;
            start = 1;
            @(posedge clk);
            #1;
            start = 0;


            @(posedge clk);
            #1;


            #1;



            check_outputs(16'h0000, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: Single Bit Set (0x01)", test_num);
            reset_dut();

            data_in = 8'h01;
            start = 1;
            @(posedge clk);
            #1 start = 0;

            @(posedge clk);
            #1;




            #1;





            check_outputs(16'h0302, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: Maximum Value Input (0xFF)", test_num);
            reset_dut();

            data_in = 8'hFF;
            start = 1;
            @(posedge clk);
            #1 start = 0;

            @(posedge clk);
            #1;


            #1;



            check_outputs(16'h701E, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: Consecutive Starts", test_num);
            reset_dut();


            data_in = 8'hAA;
            start = 1;
            @(posedge clk);
            #1 start = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(16'h55AA, 1'b1);


            data_in = 8'h55;
            start = 1;
            @(posedge clk);
            #1 start = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(16'hAA55, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("reed_solomon_encoder Testbench");
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
        input [15:0] expected_encoded_out;
        input expected_ready;
        begin
            if (expected_encoded_out === (expected_encoded_out ^ encoded_out ^ expected_encoded_out) &&
                expected_ready === (expected_ready ^ ready ^ expected_ready)) begin
                $display("PASS");
                $display("  Outputs: encoded_out=%h, ready=%b",
                         encoded_out, ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: encoded_out=%h, ready=%b",
                         expected_encoded_out, expected_ready);
                $display("  Got:      encoded_out=%h, ready=%b",
                         encoded_out, ready);
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
        $dumpvars(0,clk, data_in, rst, start, encoded_out, ready);
    end

endmodule
