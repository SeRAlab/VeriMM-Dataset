`timescale 1ns/1ps

module serializer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg rst;
    wire serial_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    serializer dut (
        .clk(clk),
        .data_in(data_in),
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
            rst = 1;
            data_in = 8'b0;
            @(negedge clk);
            rst = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        integer i;
        reg [7:0] pattern;
        begin
            $display("Running testcase001: All Ones (8'hFF)");
            test_num = test_num + 1;
            pattern = 8'hFF;
            reset_dut();
            data_in = pattern;

            for (i = 7; i >= 0; i = i - 1) begin
                @(posedge clk);
                #1;
                #1;

                check_outputs(pattern[i]);
            end
        end
        endtask

    task testcase002;

        integer i;
        reg [7:0] pattern;
        begin
            $display("Running testcase002: All Zeros (8'h00)");
            test_num = test_num + 1;
            pattern = 8'h00;
            reset_dut();
            data_in = pattern;
            for (i = 7; i >= 0; i = i - 1) begin
                @(posedge clk);
                #1;
                #1;

                check_outputs(pattern[i]);
            end
        end
        endtask

    task testcase003;

        integer i;
        reg [7:0] pattern;
        begin
            $display("Running testcase003: Alternating Bits (8'hAA)");
            test_num = test_num + 1;
            pattern = 8'hAA;
            reset_dut();
            data_in = pattern;
            for (i = 7; i >= 0; i = i - 1) begin
                @(posedge clk);
                #1;
                #1;

                check_outputs(pattern[i]);
            end
        end
        endtask

    task testcase004;

        integer i;
        reg [7:0] pattern;
        begin
            $display("Running testcase004: Alternating Bits (8'h55)");
            test_num = test_num + 1;
            pattern = 8'h55;
            reset_dut();
            data_in = pattern;
            for (i = 7; i >= 0; i = i - 1) begin
                @(posedge clk);
                #1;
                #1;

                check_outputs(pattern[i]);
            end
        end
        endtask

    task testcase005;

        integer i;
        reg [7:0] pattern;
        begin
            $display("Running testcase005: MSB Only (8'h80)");
            test_num = test_num + 1;
            pattern = 8'h80;
            reset_dut();
            data_in = pattern;
            for (i = 7; i >= 0; i = i - 1) begin
                @(posedge clk);
                #1;
                #1;

                check_outputs(pattern[i]);
            end
        end
        endtask

    task testcase006;

        integer i;
        reg [7:0] pattern;
        begin
            $display("Running testcase006: LSB Only (8'h01)");
            test_num = test_num + 1;
            pattern = 8'h01;
            reset_dut();
            data_in = pattern;
            for (i = 7; i >= 0; i = i - 1) begin
                @(posedge clk);
                #1;
                #1;

                check_outputs(pattern[i]);
            end
        end
        endtask

    task testcase007;

        integer i;
        reg [7:0] pattern;
        begin
            $display("Running testcase007: Random Pattern (8'hC3)");
            test_num = test_num + 1;
            pattern = 8'hC3;
            reset_dut();
            data_in = pattern;
            for (i = 7; i >= 0; i = i - 1) begin
                @(posedge clk);
                #1;
                #1;

                check_outputs(pattern[i]);
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
        $dumpvars(0,clk, data_in, rst, serial_out);
    end

endmodule
