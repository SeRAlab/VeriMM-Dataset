`timescale 1ns/1ps

module I2C_Controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data;
    reg start;
    reg stop;
    wire SCL;
    wire SDA;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    I2C_Controller dut (
        .clk(clk),
        .data(data),
        .start(start),
        .stop(stop),
        .SCL(SCL),
        .SDA(SDA),
        .state(state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            start = 0;
            stop = 0;
            data = 8'h00;
            @(posedge clk);


            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Sending Data 8'hA5", test_num);
            reset_dut();


            data = 8'hA5;
            start = 1;
            @(posedge clk);
            start = 0;



            repeat(10) @(posedge clk);


            stop = 1;
            @(posedge clk);
            stop = 0;
            repeat(2) @(posedge clk);


            #1;



            check_outputs(1'b1, 1'b1, 2'b10);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Sending All Zeros (8'h00)", test_num);
            reset_dut();

            data = 8'h00;
            start = 1;
            @(posedge clk);
            start = 0;

            repeat(10) @(posedge clk);

            stop = 1;
            @(posedge clk);
            stop = 0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b1, 1'b1, 2'b10);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Sending All Ones (8'hFF)", test_num);
            reset_dut();

            data = 8'hFF;
            start = 1;
            @(posedge clk);
            start = 0;

            repeat(10) @(posedge clk);

            stop = 1;
            @(posedge clk);
            stop = 0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b1, 1'b1, 2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Sending Alternating Bits (8'h55)", test_num);
            reset_dut();

            data = 8'h55;
            start = 1;
            @(posedge clk);
            start = 0;

            repeat(10) @(posedge clk);

            stop = 1;
            @(posedge clk);
            stop = 0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b1, 1'b1, 2'b10);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("I2C_Controller Testbench");
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
        input expected_SCL;
        input expected_SDA;
        input [1:0] expected_state;
        begin
            if (expected_SCL === (expected_SCL ^ SCL ^ expected_SCL) &&
                expected_SDA === (expected_SDA ^ SDA ^ expected_SDA) &&
                expected_state === (expected_state ^ state ^ expected_state)) begin
                $display("PASS");
                $display("  Outputs: SCL=%b, SDA=%b, state=%h",
                         SCL, SDA, state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: SCL=%b, SDA=%b, state=%h",
                         expected_SCL, expected_SDA, expected_state);
                $display("  Got:      SCL=%b, SDA=%b, state=%h",
                         SCL, SDA, state);
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
        $dumpvars(0,clk, data, start, stop, SCL, SDA, state);
    end

endmodule
