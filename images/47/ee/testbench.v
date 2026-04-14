`timescale 1ns/1ps

module twos_complement_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg rst_n;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    twos_complement dut (
        .clk(clk),
        .data_in(data_in),
        .rst_n(rst_n),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            rst_n = 0;
            data_in = 8'h00;
            @(negedge clk);
            rst_n = 1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            data_in = 8'd0;
            @(posedge clk);
            #1;
            $display("Testcase 001: Input = 0");
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            data_in = 8'd1;
            @(posedge clk);
            #1;
            $display("Testcase 002: Input = 1");
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            data_in = 8'h7F;
            @(posedge clk);
            #1;
            $display("Testcase 003: Input = 127 (0x7F)");
            #1;

            check_outputs(8'h81);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            data_in = 8'h80;
            @(posedge clk);
            #1;
            $display("Testcase 004: Input = -128 (0x80)");
            #1;

            check_outputs(8'h80);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            data_in = 8'hFF;
            @(posedge clk);
            #1;
            $display("Testcase 005: Input = -1 (0xFF)");
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            data_in = 8'd42;
            @(posedge clk);
            #1;
            $display("Testcase 006: Input = 42");
            #1;

            check_outputs(8'hD6);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            data_in = 8'hAA;
            @(posedge clk);
            #1;
            rst_n = 0;
            @(posedge clk);
            #1;
            $display("Testcase 007: Verifying Reset State");
            #1;

            check_outputs(8'h00);
            rst_n = 1;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("twos_complement Testbench");
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
        input [7:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clk, data_in, rst_n, data_out);
    end

endmodule
