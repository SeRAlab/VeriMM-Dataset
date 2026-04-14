`timescale 1ns/1ps

module deserializer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg rst;
    wire [15:0] data_out;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    deserializer dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .data_out(data_out),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            data_in = 8'h0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Normal Data Pair (0x12, 0x34)");
            reset_dut();


            data_in = 8'h12;
            @(posedge clk);


            #1 data_in = 8'h34;
            @(posedge clk);


            #1 #1;
 check_outputs(16'h1234, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Alternating Pattern (0xAA, 0x55)");
            reset_dut();

            data_in = 8'hAA;
            @(posedge clk);
            #1 data_in = 8'h55;
            @(posedge clk);

            #1 #1;
 check_outputs(16'hAA55, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: All Zeros");
            reset_dut();

            data_in = 8'h00;
            @(posedge clk);
            #1 data_in = 8'h00;
            @(posedge clk);

            #1 #1;
 check_outputs(16'h0000, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: All Ones");
            reset_dut();

            data_in = 8'hFF;
            @(posedge clk);
            #1 data_in = 8'hFF;
            @(posedge clk);

            #1 #1;
 check_outputs(16'hFFFF, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Mixed Extremes (0xFF, 0x00)");
            reset_dut();

            data_in = 8'hFF;
            @(posedge clk);
            #1 data_in = 8'h00;
            @(posedge clk);

            #1 #1;
 check_outputs(16'hFF00, 1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase 006: Reset Integrity Check");
            reset_dut();

            #1;


            check_outputs(16'h0000, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("deserializer Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [15:0] expected_data_out;
        input expected_valid;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, valid=%b",
                         data_out, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, valid=%b",
                         expected_data_out, expected_valid);
                $display("  Got:      data_out=%h, valid=%b",
                         data_out, valid);
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
        $dumpvars(0,clk, data_in, rst, data_out, valid);
    end

endmodule
