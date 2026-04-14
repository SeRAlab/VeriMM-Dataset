`timescale 1ns/1ps

module pipelined_processor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg rst;
    wire [3:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipelined_processor dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            data_in = 4'd0;
            repeat(2) @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Input = 0");
            test_num = test_num + 1;
            reset_dut();
            data_in = 4'd0;
            @(posedge clk);
            #1;
            data_in = 4'hF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd3);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Input = 2");
            test_num = test_num + 1;
            reset_dut();
            data_in = 4'd2;
            @(posedge clk);
            #1;
            data_in = 4'h0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd7);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Input = 6");
            test_num = test_num + 1;
            reset_dut();
            data_in = 4'd6;
            @(posedge clk);
            #1;
            data_in = 4'h0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Input = 7");
            test_num = test_num + 1;
            reset_dut();
            data_in = 4'd7;
            @(posedge clk);
            #1;
            data_in = 4'h0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Input = 15");
            test_num = test_num + 1;
            reset_dut();
            data_in = 4'd15;
            @(posedge clk);
            #1;
            data_in = 4'h0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning testcase006: Input = 8");
            test_num = test_num + 1;
            reset_dut();
            data_in = 4'd8;
            @(posedge clk);
            #1;
            data_in = 4'h0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd3);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pipelined_processor Testbench");
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
        input [3:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clk, data_in, rst, data_out);
    end

endmodule
