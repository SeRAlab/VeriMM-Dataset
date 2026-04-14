`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg data_serial;
    reg left_right;
    reg load;
    reg rst;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .data_in(data_in),
        .data_serial(data_serial),
        .left_right(left_right),
        .load(load),
        .rst(rst),
        .data_out(data_out)
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
            left_right = 0;
            data_in = 8'h00;
            data_serial = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Initial Reset");
            reset_dut();
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Parallel Load 8'hA5");
            reset_dut();
            load = 1;
            data_in = 8'hA5;
            @(posedge clk);
            #1 load = 0;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Shift Left (data_serial = 0)");
            reset_dut();

            load = 1;
            data_in = 8'hFF;
            @(posedge clk);
            #1 load = 0;
            left_right = 1;
            data_serial = 0;
            @(posedge clk);
            @(posedge clk);
            #1 #1;
 check_outputs(8'hFC);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Shift Right (data_serial = 0)");
            reset_dut();
            load = 1;
            data_in = 8'hFF;
            @(posedge clk);
            #1 load = 0;
            left_right = 0;
            data_serial = 0;
            @(posedge clk);
            @(posedge clk);
            #1 #1;
 check_outputs(8'h3F);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Shift Left (data_serial = 1)");
            reset_dut();
            load = 1;
            data_in = 8'h00;
            @(posedge clk);
            #1 load = 0;
            left_right = 1;
            data_serial = 1;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #1 #1;
 check_outputs(8'h07);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Shift Right (data_serial = 1)");
            reset_dut();
            load = 1;
            data_in = 8'h00;
            @(posedge clk);
            #1 load = 0;
            left_right = 0;
            data_serial = 1;
            @(posedge clk);
            @(posedge clk);
            #1 #1;
 check_outputs(8'hC0);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Mixed Sequence");
            reset_dut();

            load = 1; data_in = 8'h55;
            @(posedge clk);
            #1 load = 0;

            left_right = 1; data_serial = 1;
            @(posedge clk);

            left_right = 0; data_serial = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(8'h55);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_register Testbench");
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
        $dumpvars(0,clk, data_in, data_serial, left_right, load, rst, data_out);
    end

endmodule
