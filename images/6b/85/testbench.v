`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg encode_enable;
    reg error_enable;
    reg reset;
    wire [7:0] data_out;
    wire error_detected;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .encode_enable(encode_enable),
        .error_enable(error_enable),
        .reset(reset),
        .data_out(data_out),
        .error_detected(error_detected)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            encode_enable = 0;
            error_enable = 0;
            data_in = 8'h0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Basic Encoding Flow", test_num);
            reset_dut();

            encode_enable = 1;
            error_enable = 0;


            for(i=0; i<4; i=i+1) begin
                data_in = 8'hA0 + i;
                @(posedge clk);
            end

            encode_enable = 0;
            repeat(10) @(posedge clk);


            #1;



            check_outputs(data_out, 1'b0);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Decoding Clean Data", test_num);
            reset_dut();

            encode_enable = 0;
            error_enable = 0;


            for(i=0; i<4; i=i+1) begin
                data_in = 8'h11 * (i+1);
                @(posedge clk);
            end

            repeat(10) @(posedge clk);


            #1;



            check_outputs(data_out, 1'b0);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Error Injection and Detection", test_num);
            reset_dut();


            encode_enable = 0;
            error_enable = 1;

            for(i=0; i<4; i=i+1) begin
                data_in = 8'h55;
                @(posedge clk);
            end

            error_enable = 0;
            repeat(10) @(posedge clk);




            #1;





            check_outputs(data_out, 1'b1);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Sequence Processing", test_num);
            reset_dut();

            encode_enable = 1;
            for(i=0; i<8; i=i+1) begin
                data_in = $random % 256;
                @(posedge clk);
            end

            encode_enable = 0;
            repeat(5) @(posedge clk);


            #1;



            check_outputs(data_out, error_detected);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input expected_error_detected;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_error_detected === (expected_error_detected ^ error_detected ^ expected_error_detected)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, error_detected=%b",
                         data_out, error_detected);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, error_detected=%b",
                         expected_data_out, expected_error_detected);
                $display("  Got:      data_out=%h, error_detected=%b",
                         data_out, error_detected);
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
        $dumpvars(0,clk, data_in, encode_enable, error_enable, reset, data_out, error_detected);
    end

endmodule
