`timescale 1ns/1ps

module DWT_Haar_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg rst;
    wire [7:0] approx_out;
    wire [7:0] detail_out;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DWT_Haar dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .approx_out(approx_out),
        .detail_out(detail_out),
        .done(done)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            data_in = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Zeros Input", test_num);
            reset_dut();

            repeat(8) begin
                data_in = 8'd0;
                @(posedge clk);
            end


            wait(done == 1'b1);
            @(posedge clk);
            #1;

            check_outputs(8'd0, 8'd0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Constant 255 Input", test_num);
            reset_dut();

            repeat(8) begin
                data_in = 8'd255;
                @(posedge clk);
            end

            wait(done == 1'b1);
            @(posedge clk);
            #1;

            check_outputs(8'd255, 8'd0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Alternating Pattern", test_num);
            reset_dut();

            repeat(4) begin
                data_in = 8'd200;
                @(posedge clk);
                data_in = 8'd0;
                @(posedge clk);
            end

            wait(done == 1'b1);
            @(posedge clk);

            #1;


            check_outputs(8'd100, 8'd0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Step Function", test_num);
            reset_dut();

            repeat(4) begin
                data_in = 8'd0;
                @(posedge clk);
            end
            repeat(4) begin
                data_in = 8'd128;
                @(posedge clk);
            end

            wait(done == 1'b1);
            @(posedge clk);

            #1;


            check_outputs(8'd64, 8'd192, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("DWT_Haar Testbench");
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
        input [7:0] expected_approx_out;
        input [7:0] expected_detail_out;
        input expected_done;
        begin
            if (expected_approx_out === (expected_approx_out ^ approx_out ^ expected_approx_out) &&
                expected_detail_out === (expected_detail_out ^ detail_out ^ expected_detail_out) &&
                expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: approx_out=%h, detail_out=%h, done=%b",
                         approx_out, detail_out, done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: approx_out=%h, detail_out=%h, done=%b",
                         expected_approx_out, expected_detail_out, expected_done);
                $display("  Got:      approx_out=%h, detail_out=%h, done=%b",
                         approx_out, detail_out, done);
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
        $dumpvars(0,clk, data_in, rst, approx_out, detail_out, done);
    end

endmodule
