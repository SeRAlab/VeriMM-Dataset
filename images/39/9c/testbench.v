`timescale 1ns/1ps

module echo_cancellation_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] in_signal;
    reg reset;
    wire [1:0] out_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    echo_cancellation dut (
        .clk(clk),
        .in_signal(in_signal),
        .reset(reset),
        .out_signal(out_signal)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            in_signal = 2'b00;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Basic Delay", test_num);
            reset_dut();

            @(negedge clk);
            in_signal = 2'b01;

            @(posedge clk);
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'b01);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Reset Behavior", test_num);
            reset_dut();

            @(negedge clk);
            in_signal = 2'b11;
            @(posedge clk);

            reset = 1;
            #10;
            reset = 0;
            #1;

            #1;


            check_outputs(2'b00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Sequential Tracking", test_num);
            reset_dut();

            @(negedge clk) in_signal = 2'b10;
            @(negedge clk) in_signal = 2'b11;
            @(negedge clk) in_signal = 2'b01;

            @(posedge clk);
            #1;



            #1;




            check_outputs(2'b01);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Max Value Transition", test_num);
            reset_dut();

            @(negedge clk) in_signal = 2'b11;
            @(negedge clk) in_signal = 2'b00;

            @(posedge clk);
            #1;


            #1;



            check_outputs(2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Zero Persistence", test_num);
            reset_dut();

            @(negedge clk) in_signal = 2'b00;
            @(negedge clk) in_signal = 2'b00;
            @(negedge clk) in_signal = 2'b00;

            @(posedge clk);
            #1;

            #1;


            check_outputs(2'b00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("echo_cancellation Testbench");
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
        input [1:0] expected_out_signal;
        begin
            if (expected_out_signal === (expected_out_signal ^ out_signal ^ expected_out_signal)) begin
                $display("PASS");
                $display("  Outputs: out_signal=%h",
                         out_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_signal=%h",
                         expected_out_signal);
                $display("  Got:      out_signal=%h",
                         out_signal);
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
        $dumpvars(0,clk, in_signal, reset, out_signal);
    end

endmodule
