`timescale 1ns/1ps

module crc_generator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg data_valid;
    reg reset;
    wire [2:0] crc_out;
    wire crc_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    crc_generator dut (
        .clk(clk),
        .data_in(data_in),
        .data_valid(data_valid),
        .reset(reset),
        .crc_out(crc_out),
        .crc_valid(crc_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            reset = 1;
            data_in = 4'b0;
            data_valid = 1'b0;
            @(negedge clk);
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Input 4'b0000", test_num);
            data_in = 4'b0000;
            data_valid = 1'b1;
            @(posedge clk);
            data_valid = 1'b0;

            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b000, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Input 4'b1000", test_num);
            data_in = 4'b1000;
            data_valid = 1'b1;
            @(posedge clk);
            data_valid = 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b110, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Input 4'b0001", test_num);
            data_in = 4'b0001;
            data_valid = 1'b1;
            @(posedge clk);
            data_valid = 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b101, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Input 4'b1111", test_num);
            data_in = 4'b1111;
            data_valid = 1'b1;
            @(posedge clk);
            data_valid = 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b111, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Input 4'b1011", test_num);
            data_in = 4'b1011;
            data_valid = 1'b1;
            @(posedge clk);
            data_valid = 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b100, 1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Input 4'b0101", test_num);
            data_in = 4'b0101;
            data_valid = 1'b1;
            @(posedge clk);
            data_valid = 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b110, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("crc_generator Testbench");
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
        input [2:0] expected_crc_out;
        input expected_crc_valid;
        begin
            if (expected_crc_out === (expected_crc_out ^ crc_out ^ expected_crc_out) &&
                expected_crc_valid === (expected_crc_valid ^ crc_valid ^ expected_crc_valid)) begin
                $display("PASS");
                $display("  Outputs: crc_out=%h, crc_valid=%b",
                         crc_out, crc_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: crc_out=%h, crc_valid=%b",
                         expected_crc_out, expected_crc_valid);
                $display("  Got:      crc_out=%h, crc_valid=%b",
                         crc_out, crc_valid);
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
        $dumpvars(0,clk, data_in, data_valid, reset, crc_out, crc_valid);
    end

endmodule
