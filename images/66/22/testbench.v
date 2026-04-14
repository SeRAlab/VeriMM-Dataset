`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data;
    reg rst;
    reg stb;
    wire ack;
    wire [7:0] data_out;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .rst(rst),
        .stb(stb),
        .ack(ack),
        .data_out(data_out),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            data = 8'h00;
            stb = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Post-reset verification", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 8'h00, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Single data capture (0xA5)", test_num);
            reset_dut();

            data = 8'hA5;
            stb = 1;


            repeat(4) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 8'hA5, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Data hold and strobe deassertion", test_num);
            reset_dut();


            data = 8'h5A;
            stb = 1;
            repeat(4) @(posedge clk);


            stb = 0;
            repeat(4) @(posedge clk);
            #1;


            #1;



            check_outputs(1'b0, 8'h5A, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Successive data transfers", test_num);
            reset_dut();


            data = 8'h11;
            stb = 1;
            repeat(4) @(posedge clk);


            stb = 0;
            @(posedge clk);
            data = 8'hEE;
            stb = 1;
            repeat(4) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 8'hEE, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Strobe toggle with constant data", test_num);
            reset_dut();

            data = 8'hFF;
            stb = 1;
            repeat(4) @(posedge clk);

            stb = 0;
            repeat(4) @(posedge clk);

            stb = 1;
            repeat(4) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 8'hFF, 1'b1);
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
        input expected_ack;
        input [7:0] expected_data_out;
        input expected_valid;
        begin
            if (expected_ack === (expected_ack ^ ack ^ expected_ack) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: ack=%b, data_out=%h, valid=%b",
                         ack, data_out, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack=%b, data_out=%h, valid=%b",
                         expected_ack, expected_data_out, expected_valid);
                $display("  Got:      ack=%b, data_out=%h, valid=%b",
                         ack, data_out, valid);
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
        $dumpvars(0,clk, data, rst, stb, ack, data_out, valid);
    end

endmodule
