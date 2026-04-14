`timescale 1ns/1ps

module crc4_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg rst;
    wire [3:0] crc_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    crc4 dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .crc_out(crc_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            data_in = 0;
            @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            data_in = 4'b0000;
            @(posedge clk);
            #1;
            $display("Test Case 001: Data=4'h0");
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            data_in = 4'b1010;
            @(posedge clk);
            #1;
            $display("Test Case 002: Data=4'hA");
            #1;

            check_outputs(4'hD);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            data_in = 4'b1111;
            @(posedge clk);
            #1;
            $display("Test Case 003: Data=4'hF");
            #1;

            check_outputs(4'h2);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            data_in = 4'b1000;
            @(posedge clk);
            #1;
            $display("Test Case 004: Data=4'h8");
            #1;

            check_outputs(4'hB);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            data_in = 4'b0001;
            @(posedge clk);
            #1;
            $display("Test Case 005: Data=4'h1");
            #1;

            check_outputs(4'h3);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            data_in = 4'b0110;
            @(posedge clk);
            #1;
            $display("Test Case 006: Data=4'h6");
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            data_in = 4'b0100;
            @(posedge clk);
            #1;
            $display("Test Case 007: Data=4'h4");
            #1;

            check_outputs(4'hC);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case 008: Check Output after Reset");
            #1;

            check_outputs(4'h0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("crc4 Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [3:0] expected_crc_out;
        begin
            if (expected_crc_out === (expected_crc_out ^ crc_out ^ expected_crc_out)) begin
                $display("PASS");
                $display("  Outputs: crc_out=%h",
                         crc_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: crc_out=%h",
                         expected_crc_out);
                $display("  Got:      crc_out=%h",
                         crc_out);
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
        $dumpvars(0,clk, data_in, rst, crc_out);
    end

endmodule
