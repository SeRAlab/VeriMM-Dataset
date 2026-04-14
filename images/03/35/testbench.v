`timescale 1ns/1ps

module serializer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] parallel_in;
    reg rst;
    reg valid;
    wire serial_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    serializer dut (
        .clk(clk),
        .parallel_in(parallel_in),
        .rst(rst),
        .valid(valid),
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
            valid = 0;
            parallel_in = 8'b0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        integer i;
        reg [7:0] test_data;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Alternating Bits 10101011", test_num);
            reset_dut();
            test_data = 8'b10101011;
            parallel_in = test_data;
            valid = 1;
            @(posedge clk);
            #1 valid = 0;

            for (i = 0; i < 8; i = i + 1) begin
                #1;

                check_outputs(test_data[i]);
                @(posedge clk);
                #1;
            end
        end
        endtask

    task testcase002;

        integer i;
        reg [7:0] test_data;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All Zeros", test_num);
            reset_dut();
            test_data = 8'b00000000;
            parallel_in = test_data;
            valid = 1;
            @(posedge clk);
            #1 valid = 0;

            for (i = 0; i < 8; i = i + 1) begin
                #1;

                check_outputs(test_data[i]);
                @(posedge clk);
                #1;
            end
        end
        endtask

    task testcase003;

        integer i;
        reg [7:0] test_data;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All Ones", test_num);
            reset_dut();
            test_data = 8'b11111111;
            parallel_in = test_data;
            valid = 1;
            @(posedge clk);
            #1 valid = 0;

            for (i = 0; i < 8; i = i + 1) begin
                #1;

                check_outputs(test_data[i]);
                @(posedge clk);
                #1;
            end
        end
        endtask

    task testcase004;

        integer i;
        reg [7:0] test_data;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Walking One (MSB set)", test_num);
            reset_dut();
            test_data = 8'b10000000;
            parallel_in = test_data;
            valid = 1;
            @(posedge clk);
            #1 valid = 0;

            for (i = 0; i < 8; i = i + 1) begin
                #1;

                check_outputs(test_data[i]);
                @(posedge clk);
                #1;
            end
        end
        endtask

    task testcase005;

        integer i;
        reg [7:0] test_data;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Walking One (LSB set)", test_num);
            reset_dut();
            test_data = 8'b00000001;
            parallel_in = test_data;
            valid = 1;
            @(posedge clk);
            #1 valid = 0;

            for (i = 0; i < 8; i = i + 1) begin
                #1;

                check_outputs(test_data[i]);
                @(posedge clk);
                #1;
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
        $dumpvars(0,clk, parallel_in, rst, valid, serial_out);
    end

endmodule
