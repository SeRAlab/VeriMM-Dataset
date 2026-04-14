`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in1;
    reg [7:0] data_in2;
    wire [7:0] q_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in1(data_in1),
        .data_in2(data_in2),
        .q_out(q_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            data_in1 = 8'h0;
            data_in2 = 8'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic data_in2 capture...");
            reset_dut();
            test_num = test_num + 1;

            data_in2 = 8'hA5;
            data_in1 = 8'h00;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Verify data_in1 isolation...");
            reset_dut();
            test_num = test_num + 1;


            data_in2 = 8'h5A;
            data_in1 = 8'hFF;
            @(posedge clk);
            #1;
            data_in1 = 8'hEE;
            @(posedge clk);
            #1;
            data_in1 = 8'hDD;
            @(posedge clk);
            #1;



            #1;




            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Sequential data_in2 updates...");
            reset_dut();
            test_num = test_num + 1;

            data_in2 = 8'h11;
            @(posedge clk);
            #1;
            data_in2 = 8'h22;
            @(posedge clk);
            #1;
            data_in2 = 8'h33;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h33);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Bit boundary check (0xFF and 0x00)...");
            reset_dut();
            test_num = test_num + 1;

            data_in2 = 8'hFF;
            @(posedge clk);
            #1;
            data_in2 = 8'h00;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Output stability check...");
            reset_dut();
            test_num = test_num + 1;

            data_in2 = 8'hBC;
            @(posedge clk);
            #1;

            repeat(10) begin
                data_in1 = $random;
                @(posedge clk);
                #1;
            end

            #1;


            check_outputs(8'hBC);
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
        input [7:0] expected_q_out;
        begin
            if (expected_q_out === (expected_q_out ^ q_out ^ expected_q_out)) begin
                $display("PASS");
                $display("  Outputs: q_out=%h",
                         q_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q_out=%h",
                         expected_q_out);
                $display("  Got:      q_out=%h",
                         q_out);
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
        $dumpvars(0,clk, data_in1, data_in2, q_out);
    end

endmodule
