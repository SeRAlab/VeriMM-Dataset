`timescale 1ns/1ps

module I2C_Controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg read;
    reg reset;
    reg start;
    reg stop;
    reg write;
    wire SCL;
    wire SDA;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    I2C_Controller dut (
        .clk(clk),
        .data_in(data_in),
        .read(read),
        .reset(reset),
        .start(start),
        .stop(stop),
        .write(write),
        .SCL(SCL),
        .SDA(SDA),
        .done(done)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data_in = 8'b0;
            read = 0;
            write = 0;
            start = 0;
            stop = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: I2C Start Condition", test_num);
            reset_dut();
            start = 1;
            @(posedge clk);
            #1 start = 0;

            wait(done == 1);
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: I2C Stop Condition", test_num);
            reset_dut();
            stop = 1;
            @(posedge clk);
            #1 stop = 0;

            wait(done == 1);
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Write 8'hAA", test_num);
            reset_dut();
            data_in = 8'hAA;
            write = 1;
            @(posedge clk);
            #1 write = 0;

            wait(done == 1);
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Write 8'hFF", test_num);
            reset_dut();
            data_in = 8'hFF;
            write = 1;
            @(posedge clk);
            #1 write = 0;

            wait(done == 1);
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Read Operation", test_num);
            reset_dut();
            read = 1;
            @(posedge clk);
            #1 read = 0;

            wait(done == 1);
            @(posedge clk);
            #1;

            if (done === 1'b1) begin
                $display("PASS: Read operation completed");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Read operation did not complete");
                fail_count = fail_count + 1;
            end
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
        input expected_SCL;
        input expected_SDA;
        input expected_done;
        begin
            if (expected_SCL === (expected_SCL ^ SCL ^ expected_SCL) &&
                expected_SDA === (expected_SDA ^ SDA ^ expected_SDA) &&
                expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: SCL=%b, SDA=%b, done=%b",
                         SCL, SDA, done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: SCL=%b, SDA=%b, done=%b",
                         expected_SCL, expected_SDA, expected_done);
                $display("  Got:      SCL=%b, SDA=%b, done=%b",
                         SCL, SDA, done);
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
        $dumpvars(0,clk, data_in, read, reset, start, stop, write, SCL, SDA, done);
    end

endmodule
