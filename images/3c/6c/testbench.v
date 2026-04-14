`timescale 1ns/1ps

module rnn_cell_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [15:0] x1;
    reg [15:0] x2;
    wire [15:0] y1;
    wire [15:0] y2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rnn_cell dut (
        .clk(clk),
        .reset(reset),
        .x1(x1),
        .x2(x2),
        .y1(y1),
        .y2(y2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            x1 = 16'h0000;
            x2 = 16'h0000;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running Testcase %03d: Zero Input Response", test_num);
            reset_dut();

            x1 = 16'h0000;
            x2 = 16'h0000;

            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Testcase %03d: Single Step Response", test_num);
            reset_dut();

            x1 = 16'h1000;
            x2 = 16'hF000;

            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h0A12, 16'hF5EE);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Testcase %03d: Temporal Dependency (2 Steps)", test_num);
            reset_dut();


            x1 = 16'h0800;
            x2 = 16'h0800;
            @(posedge clk);
            #1;


            x1 = 16'h1000;
            x2 = 16'h0000;
            @(posedge clk);
            #1;



            #1;




            check_outputs(16'h1234, 16'h5678);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Testcase %03d: Saturation Check", test_num);
            reset_dut();

            x1 = 16'h7FFF;
            x2 = 16'h8000;

            @(posedge clk);
            #1;


            #1;



            check_outputs(16'h2000, 16'hE000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rnn_cell Testbench");
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
        input [15:0] expected_y1;
        input [15:0] expected_y2;
        begin
            if (expected_y1 === (expected_y1 ^ y1 ^ expected_y1) &&
                expected_y2 === (expected_y2 ^ y2 ^ expected_y2)) begin
                $display("PASS");
                $display("  Outputs: y1=%h, y2=%h",
                         y1, y2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y1=%h, y2=%h",
                         expected_y1, expected_y2);
                $display("  Got:      y1=%h, y2=%h",
                         y1, y2);
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
        $dumpvars(0,clk, reset, x1, x2, y1, y2);
    end

endmodule
