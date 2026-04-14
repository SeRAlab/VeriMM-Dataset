`timescale 1ns/1ps

module fir_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] x;
    wire [7:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fir_filter dut (
        .clk(clk),
        .x(x),
        .y(y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            x = 8'd0;
            repeat (10) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Zero Input", test_num);
            reset_dut();
            x = 8'd0;
            repeat (8) @(posedge clk);
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Impulse Response (Tail)", test_num);
            reset_dut();
            @(posedge clk) x = 8'd1;
            @(posedge clk) x = 8'd0;
            repeat (6) @(posedge clk);

            #1;


            check_outputs(8'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: DC Step Response", test_num);
            reset_dut();
            x = 8'd10;
            repeat (8) @(posedge clk);

            #1;


            check_outputs(8'd80);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Scaling Check", test_num);
            reset_dut();
            x = 8'd5;
            repeat (8) @(posedge clk);

            #1;


            check_outputs(8'd40);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Pipeline Flush", test_num);
            reset_dut();
            x = 8'd255;
            repeat (8) @(posedge clk);
            x = 8'd0;
            repeat (8) @(posedge clk);
            #1;

            check_outputs(8'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fir_filter Testbench");
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
        input [7:0] expected_y;
        begin
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
        $dumpvars(0,clk, x, y);
    end

endmodule
