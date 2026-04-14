`timescale 1ns/1ps

module i2c_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg start;
    wire [7:0] data_out;
    wire stop;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    i2c_controller dut (
        .clk(clk),
        .data_in(data_in),
        .start(start),
        .data_out(data_out),
        .stop(stop)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            start = 0;
            data_in = 8'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Transmitting 8'hA5", test_num);
            reset_dut();
            data_in = 8'hA5;
            start = 1;
            @(posedge clk);
            #1 start = 0;


            repeat (10) @(posedge clk);

            #1;


            check_outputs(8'hA5, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Transmitting 8'h5A", test_num);
            reset_dut();
            data_in = 8'h5A;
            start = 1;
            @(posedge clk);
            #1 start = 0;

            repeat (10) @(posedge clk);

            #1;


            check_outputs(8'h5A, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Transmitting 8'hFF (All Ones)", test_num);
            reset_dut();
            data_in = 8'hFF;
            start = 1;
            @(posedge clk);
            #1 start = 0;

            repeat (10) @(posedge clk);

            #1;


            check_outputs(8'hFF, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Transmitting 8'h00 (All Zeros)", test_num);
            reset_dut();
            data_in = 8'h00;
            start = 1;
            @(posedge clk);
            #1 start = 0;

            repeat (10) @(posedge clk);

            #1;


            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Transmitting 8'hC3 (Pattern)", test_num);
            reset_dut();
            data_in = 8'hC3;
            start = 1;
            @(posedge clk);
            #1 start = 0;

            repeat (10) @(posedge clk);

            #1;


            check_outputs(8'hC3, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("i2c_controller Testbench");
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
        input [7:0] expected_data_out;
        input expected_stop;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_stop === (expected_stop ^ stop ^ expected_stop)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, stop=%b",
                         data_out, stop);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, stop=%b",
                         expected_data_out, expected_stop);
                $display("  Got:      data_out=%h, stop=%b",
                         data_out, stop);
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
        $dumpvars(0,clk, data_in, start, data_out, stop);
    end

endmodule
