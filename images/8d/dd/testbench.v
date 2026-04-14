`timescale 1ns/1ps

module parallel_to_serial_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [9:0] data;
    reg load;
    reg rst;
    wire serial_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    parallel_to_serial dut (
        .clk(clk),
        .data(data),
        .load(load),
        .rst(rst),
        .serial_out(serial_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            rst = 1;
            load = 0;
            data = 10'b0;
            @(negedge clk);
            rst = 0;
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Synchronous Reset", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Parallel Load (LSB=1)", test_num);
            reset_dut();
            @(negedge clk);
            data = 10'b0000000001;
            load = 1;
            @(negedge clk);
            load = 0;
            #1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Parallel Load (LSB=0)", test_num);
            reset_dut();
            @(negedge clk);
            data = 10'b1111111110;
            load = 1;
            @(negedge clk);
            load = 0;
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Shift MSB to Output (10 bits)", test_num);
            reset_dut();
            @(negedge clk);
            data = 10'b1000000000;
            load = 1;
            @(negedge clk);
            load = 0;

            repeat (9) @(negedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Shift Out All Data", test_num);
            reset_dut();
            @(negedge clk);
            data = 10'b1111111111;
            load = 1;
            @(negedge clk);
            load = 0;

            repeat (10) @(negedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset Priority", test_num);
            reset_dut();
            @(negedge clk);
            rst = 1;
            load = 1;
            data = 10'b1111111111;
            @(negedge clk);
            rst = 0;
            load = 0;
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Partial Shift Pattern", test_num);
            reset_dut();
            @(negedge clk);
            data = 10'b0001000000;
            load = 1;
            @(negedge clk);
            load = 0;
            repeat (6) @(negedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("parallel_to_serial Testbench");
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
        input expected_serial_out;
        begin
            if (expected_serial_out === (expected_serial_out ^ serial_out ^ expected_serial_out)) begin
                $display("PASS");
                $display("  Outputs: serial_out=%b",
                         serial_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: serial_out=%b",
                         expected_serial_out);
                $display("  Got:      serial_out=%b",
                         serial_out);
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
        $dumpvars(0,clk, data, load, rst, serial_out);
    end

endmodule
