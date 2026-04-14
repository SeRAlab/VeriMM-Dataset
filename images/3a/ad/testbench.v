`timescale 1ns/1ps

module timer_16bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg load;
    reg rst;
    wire [15:0] count;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    timer_16bit dut (
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .rst(rst),
        .count(count),
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
            load = 0;
            data_in = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset State Check", test_num);
            reset_dut();

            #1;


            check_outputs(16'h0000, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Counting", test_num);
            reset_dut();

            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h000A, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Load Data Input", test_num);
            reset_dut();


            data_in = 16'h1234;
            load = 1;
            @(posedge clk);
            #1 load = 0;


            #1;



            check_outputs(16'h1234, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reaching MAX and Done Flag", test_num);
            reset_dut();


            data_in = 16'hFFFD;
            load = 1;
            @(posedge clk);
            #1 load = 0;


            @(posedge clk);

            @(posedge clk);

            #1;
            #1;

            check_outputs(16'hFFFF, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Hold at MAX Value", test_num);
            reset_dut();


            data_in = 16'hFFFF;
            load = 1;
            @(posedge clk);
            #1 load = 0;


            repeat(10) @(posedge clk);

            #1;
            #1;

            check_outputs(16'hFFFF, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset from MAX", test_num);
            reset_dut();


            data_in = 16'hFFFF;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            @(posedge clk);


            rst = 1;
            @(posedge clk);
            #1 rst = 0;

            #1;


            check_outputs(16'h0000, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Priority Load over Counting", test_num);
            reset_dut();


            repeat(5) @(posedge clk);


            data_in = 16'hA000;
            load = 1;
            @(posedge clk);
            #1 load = 0;


            @(posedge clk);

            #1;
            #1;

            check_outputs(16'hA001, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("timer_16bit Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [15:0] expected_count;
        input expected_done;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count) &&
                expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: count=%h, done=%b",
                         count, done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h, done=%b",
                         expected_count, expected_done);
                $display("  Got:      count=%h, done=%b",
                         count, done);
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
        $dumpvars(0,clk, data_in, load, rst, count, done);
    end

endmodule
