`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg dir;
    reg rst;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .data_in(data_in),
        .dir(dir),
        .rst(rst),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        input [15:0] initial_val;
        begin
            rst = 1;
            data_in = initial_val;
            dir = 0;
            @(posedge clk);
            #1;
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Load and Reset Check...");
            reset_dut(16'hABCD);
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Single Left Shift Check...");
            reset_dut(16'h0001);
            dir = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0002);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Single Right Shift Check...");
            reset_dut(16'h8000);
            dir = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h4000);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: 4 Left Shifts...");
            reset_dut(16'h000F);
            dir = 0;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h00F0);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: 8 Right Shifts...");
            reset_dut(16'hFF00);
            dir = 1;
            repeat(8) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h00FF);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Shift Out Boundary Check...");
            reset_dut(16'h0001);
            dir = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: Direction Switch Check...");
            reset_dut(16'h0010);
            dir = 0;
            @(posedge clk);
            #1;
            dir = 1;
            @(posedge clk);
            #1;
            dir = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0008);
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
        input [15:0] expected_data_out;
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
        $dumpvars(0,clk, data_in, dir, rst, data_out);
    end

endmodule
