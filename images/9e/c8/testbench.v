`timescale 1ns/1ps

module max_detect_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg rst_n;
    reg valid_in;
    wire [7:0] data_out;
    wire valid_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    max_detect dut (
        .clk(clk),
        .data_in(data_in),
        .rst_n(rst_n),
        .valid_in(valid_in),
        .data_out(data_out),
        .valid_out(valid_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            valid_in = 0;
            data_in = 0;
            @(posedge clk);
            #1 rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Ascending values...");
            reset_dut();
            @(posedge clk); data_in = 8'd10; valid_in = 1;
            @(posedge clk); data_in = 8'd20; valid_in = 1;
            @(posedge clk); data_in = 8'd30; valid_in = 1;
            @(posedge clk); data_in = 8'd40; valid_in = 1;
            #1;
            #1;

            check_outputs(8'd40, 1'b1);
            @(posedge clk); valid_in = 0;
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Descending values...");
            reset_dut();
            @(posedge clk); data_in = 8'd255; valid_in = 1;
            @(posedge clk); data_in = 8'd100; valid_in = 1;
            @(posedge clk); data_in = 8'd50;  valid_in = 1;
            @(posedge clk); data_in = 8'd10;  valid_in = 1;
            #1;
            #1;

            check_outputs(8'd255, 1'b1);
            @(posedge clk); valid_in = 0;
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Peak in middle...");
            reset_dut();
            @(posedge clk); data_in = 8'd15;  valid_in = 1;
            @(posedge clk); data_in = 8'd120; valid_in = 1;
            @(posedge clk); data_in = 8'd45;  valid_in = 1;
            @(posedge clk); data_in = 8'd88;  valid_in = 1;
            #1;
            #1;

            check_outputs(8'd120, 1'b1);
            @(posedge clk); valid_in = 0;
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Identical values...");
            reset_dut();
            @(posedge clk); data_in = 8'd77; valid_in = 1;
            @(posedge clk); data_in = 8'd77; valid_in = 1;
            @(posedge clk); data_in = 8'd77; valid_in = 1;
            @(posedge clk); data_in = 8'd77; valid_in = 1;
            #1;
            #1;

            check_outputs(8'd77, 1'b1);
            @(posedge clk); valid_in = 0;
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Sparse valid signals...");
            reset_dut();
            @(posedge clk); data_in = 8'd5;  valid_in = 1;
            @(posedge clk); valid_in = 0;
            @(posedge clk); valid_in = 0;
            @(posedge clk); data_in = 8'd200; valid_in = 1;
            @(posedge clk); data_in = 8'd150; valid_in = 1;
            @(posedge clk); valid_in = 0;
            @(posedge clk); data_in = 8'd10;  valid_in = 1;
            #1;
            #1;

            check_outputs(8'd200, 1'b1);
            @(posedge clk); valid_in = 0;
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Two consecutive groups...");
            reset_dut();

            @(posedge clk); data_in = 8'd10; valid_in = 1;
            @(posedge clk); data_in = 8'd50; valid_in = 1;
            @(posedge clk); data_in = 8'd30; valid_in = 1;
            @(posedge clk); data_in = 8'd20; valid_in = 1;
            #1; #1;
 check_outputs(8'd50, 1'b1);

            @(posedge clk); data_in = 8'd99; valid_in = 1;
            @(posedge clk); data_in = 8'd11; valid_in = 1;
            @(posedge clk); data_in = 8'd22; valid_in = 1;
            @(posedge clk); data_in = 8'd33; valid_in = 1;
            #1; #1;
 check_outputs(8'd99, 1'b1);
            @(posedge clk); valid_in = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("max_detect Testbench");
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
        input [7:0] expected_data_out;
        input expected_valid_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_valid_out === (expected_valid_out ^ valid_out ^ expected_valid_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, valid_out=%b",
                         data_out, valid_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, valid_out=%b",
                         expected_data_out, expected_valid_out);
                $display("  Got:      data_out=%h, valid_out=%b",
                         data_out, valid_out);
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
        $dumpvars(0,clk, data_in, rst_n, valid_in, data_out, valid_out);
    end

endmodule
