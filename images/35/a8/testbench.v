`timescale 1ns/1ps

module serializer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg load;
    reg rst;
    reg start;
    wire done;
    wire serial_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    serializer dut (
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .rst(rst),
        .start(start),
        .done(done),
        .serial_out(serial_out)
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
            start = 0;
            data_in = 8'h00;
            @(negedge clk);
            rst = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Serializing 8'hA5 (10100101)", test_num);
            reset_dut();
            @(negedge clk);
            data_in = 8'hA5;
            load = 1;
            @(negedge clk);
            load = 0;
            start = 1;
            @(negedge clk);
            start = 0;

            repeat(7) @(negedge clk);
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Serializing 8'hF0 (11110000)", test_num);
            reset_dut();
            @(negedge clk);
            data_in = 8'hF0;
            load = 1;
            @(negedge clk);
            load = 0;
            start = 1;
            @(negedge clk);
            start = 0;
            repeat(7) @(negedge clk);
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Serializing 8'h0F (00001111)", test_num);
            reset_dut();
            @(negedge clk);
            data_in = 8'h0F;
            load = 1;
            @(negedge clk);
            load = 0;
            start = 1;
            @(negedge clk);
            start = 0;
            repeat(7) @(negedge clk);
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Serializing 8'h5A (01011010)", test_num);
            reset_dut();
            @(negedge clk);
            data_in = 8'h5A;
            load = 1;
            @(negedge clk);
            load = 0;
            start = 1;
            @(negedge clk);
            start = 0;
            repeat(7) @(negedge clk);
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Serializing 8'hFF (11111111)", test_num);
            reset_dut();
            @(negedge clk);
            data_in = 8'hFF;
            load = 1;
            @(negedge clk);
            load = 0;
            start = 1;
            @(negedge clk);
            start = 0;
            repeat(7) @(negedge clk);
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("serializer Testbench");
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
        input expected_done;
        input expected_serial_out;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_serial_out === (expected_serial_out ^ serial_out ^ expected_serial_out)) begin
                $display("PASS");
                $display("  Outputs: done=%b, serial_out=%b",
                         done, serial_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, serial_out=%b",
                         expected_done, expected_serial_out);
                $display("  Got:      done=%b, serial_out=%b",
                         done, serial_out);
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
        $dumpvars(0,clk, data_in, load, rst, start, done, serial_out);
    end

endmodule
