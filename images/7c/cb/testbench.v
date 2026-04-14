`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] din_1;
    reg wen;
    wire [7:0] dout_1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .din_1(din_1),
        .wen(wen),
        .dout_1(dout_1)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            wen = 0;
            din_1 = 8'h00;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Write", test_num);
            reset_dut();

            @(negedge clk);
            wen = 1;
            din_1 = 8'hA5;
            @(posedge clk);

            #1;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Write Disable (Retention)", test_num);
            reset_dut();


            @(negedge clk);
            wen = 1;
            din_1 = 8'h5A;
            @(posedge clk);


            @(negedge clk);
            wen = 0;
            din_1 = 8'hFF;
            @(posedge clk);

            #1;
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sequential Writes", test_num);
            reset_dut();

            @(negedge clk);
            wen = 1;
            din_1 = 8'h11;
            @(posedge clk);

            @(negedge clk);
            din_1 = 8'h22;
            @(posedge clk);

            @(negedge clk);
            din_1 = 8'h33;
            @(posedge clk);

            #1;
            #1;

            check_outputs(8'h33);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Toggling wen and din", test_num);
            reset_dut();

            @(negedge clk);
            wen = 1;
            din_1 = 8'hAA;
            @(posedge clk);

            @(negedge clk);
            wen = 0;
            din_1 = 8'hBB;
            @(posedge clk);

            @(negedge clk);
            wen = 1;
            din_1 = 8'hCC;
            @(posedge clk);

            #1;
            #1;

            check_outputs(8'hCC);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max and Min values", test_num);
            reset_dut();

            @(negedge clk);
            wen = 1;
            din_1 = 8'hFF;
            @(posedge clk);

            @(negedge clk);
            din_1 = 8'h00;
            @(posedge clk);

            #1;
            #1;

            check_outputs(8'h00);
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
        input [7:0] expected_dout_1;
        begin
            if (expected_dout_1 === (expected_dout_1 ^ dout_1 ^ expected_dout_1)) begin
                $display("PASS");
                $display("  Outputs: dout_1=%h",
                         dout_1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout_1=%h",
                         expected_dout_1);
                $display("  Got:      dout_1=%h",
                         dout_1);
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
        $dumpvars(0,clk, din_1, wen, dout_1);
    end

endmodule
