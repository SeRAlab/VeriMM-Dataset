`timescale 1ns/1ps

module mult_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg rst_n;
    reg valid_in;
    wire [31:0] data_out;
    wire valid_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mult dut (
        .clk(clk),
        .data_in(data_in),
        .rst_n(rst_n),
        .valid_in(valid_in),
        .data_out(data_out),
        .valid_out(valid_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            data_in = 0;
            valid_in = 0;
            repeat(2) @(posedge clk);
            #1 rst_n = 1;
            repeat(1) @(posedge clk);
            #1;
        end
        endtask
    task send_data;

        input [7:0] val;
        begin
            data_in = val;
            valid_in = 1;
            @(posedge clk);
            #1;
            valid_in = 0;
            data_in = 0;
        end
        endtask

    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test %03d: Basic Multiplication (1, 2, 3, 4)", test_num);

            send_data(8'd1);
            send_data(8'd2);
            send_data(8'd3);
            send_data(8'd4);


            #1;



            check_outputs(32'd24, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test %03d: Larger Numbers (10, 20, 30, 40)", test_num);

            send_data(8'd10);
            send_data(8'd20);
            send_data(8'd30);
            send_data(8'd40);

            #1;


            check_outputs(32'd240000, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test %03d: Multiplication with Zero (5, 0, 10, 2)", test_num);

            send_data(8'd5);
            send_data(8'd0);
            send_data(8'd10);
            send_data(8'd2);

            #1;


            check_outputs(32'd0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test %03d: Maximum Values (255, 255, 255, 255)", test_num);

            send_data(8'hFF);
            send_data(8'hFF);
            send_data(8'hFF);
            send_data(8'hFF);


            #1;



            check_outputs(32'hFBF00101, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test %03d: Gaps in valid_in (2, gap, 5, 2, gap, 5)", test_num);

            send_data(8'd2);
            repeat(3) @(posedge clk);
            send_data(8'd5);
            send_data(8'd2);
            repeat(2) @(posedge clk);
            send_data(8'd5);

            #1;


            check_outputs(32'd100, 1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Test %03d: Consecutive Sets (Set 1: 1,1,1,1; Set 2: 2,2,2,2)", test_num);


            send_data(8'd1);
            send_data(8'd1);
            send_data(8'd1);
            send_data(8'd1);




            @(posedge clk); #1;


            send_data(8'd2);
            send_data(8'd2);
            send_data(8'd2);
            send_data(8'd2);

            #1;


            check_outputs(32'd16, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mult Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [31:0] expected_data_out;
        input expected_valid_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_valid_out === (expected_valid_out ^ valid_out ^ expected_valid_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, valid_out=%b",
                         data_out, valid_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, valid_out=%b",
                         expected_data_out, expected_valid_out);
                $display("  Got:      data_out=%h, valid_out=%b",
                         data_out, valid_out);
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
        $dumpvars(0,clk, data_in, rst_n, valid_in, data_out, valid_out);
    end

endmodule
