`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg load;
    reg rst;
    reg shift_dir;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .rst(rst),
        .shift_dir(shift_dir),
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
        data_in = 8'h00;
        shift_dir = 0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Reset Logic", test_num);
        reset_dut();

        #1;


        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Load Operation", test_num);
        reset_dut();
        @(negedge clk);
        data_in = 8'hA5;
        load = 1;
        @(posedge clk);
        #1 load = 0;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Shift Left (4 steps)", test_num);
        reset_dut();

        @(negedge clk);
        data_in = 8'h01;
        load = 1;
        @(posedge clk);
        #1 load = 0;
        shift_dir = 0;

        repeat(4) @(posedge clk);
        #1 #1;
 check_outputs(8'h10);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Shift Right (4 steps)", test_num);
        reset_dut();

        @(negedge clk);
        data_in = 8'h80;
        load = 1;
        @(posedge clk);
        #1 load = 0;
        shift_dir = 1;

        repeat(4) @(posedge clk);
        #1 #1;
 check_outputs(8'h08);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Shift Left until Empty", test_num);
        reset_dut();
        @(negedge clk);
        data_in = 8'hFF;
        load = 1;
        @(posedge clk);
        #1 load = 0;
        shift_dir = 0;

        repeat(8) @(posedge clk);
        #1 #1;
 check_outputs(8'h00);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Shift Right until Empty", test_num);
        reset_dut();
        @(negedge clk);
        data_in = 8'hFF;
        load = 1;
        @(posedge clk);
        #1 load = 0;
        shift_dir = 1;

        repeat(8) @(posedge clk);
        #1 #1;
 check_outputs(8'h00);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Direction Change Mid-Operation", test_num);
        reset_dut();
        @(negedge clk);
        data_in = 8'h55;
        load = 1;
        @(posedge clk);
        #1 load = 0;

        shift_dir = 0;
        @(posedge clk);

        #1 shift_dir = 1;
        @(posedge clk);

        #1 #1;
 check_outputs(8'h55);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Load Override", test_num);
        reset_dut();
        @(negedge clk);
        data_in = 8'hFF;
        load = 1;
        @(posedge clk);
        #1 load = 0;
        shift_dir = 0;
        repeat(2) @(posedge clk);

        #1 data_in = 8'h33;
        load = 1;
        @(posedge clk);
        #1 load = 0;
        #1;

        check_outputs(8'h33);
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
        $dumpvars(0,clk, data_in, load, rst, shift_dir, data_out);
    end

endmodule
