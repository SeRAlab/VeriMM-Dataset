`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] in;
    reg rst;
    reg shift_dir;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .in(in),
        .rst(rst),
        .shift_dir(shift_dir),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        input [7:0] load_value;
        begin
            rst = 1;
            in = load_value;
            @(posedge clk);
            #1;
            rst = 0;
            in = 8'h00;
        end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Left shift 1 bit", test_num);
        reset_dut(8'hA5);
        shift_dir = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h4A);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Right shift 1 bit", test_num);
        reset_dut(8'hA5);
        shift_dir = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h52);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Left shift 4 bits", test_num);
        reset_dut(8'h0F);
        shift_dir = 0;
        repeat(4) @(posedge clk);
        #1;
        #1;

        check_outputs(8'hF0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Right shift 4 bits", test_num);
        reset_dut(8'hF0);
        shift_dir = 1;
        repeat(4) @(posedge clk);
        #1;
        #1;

        check_outputs(8'h0F);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Left shift until empty", test_num);
        reset_dut(8'h80);
        shift_dir = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Right shift until empty", test_num);
        reset_dut(8'h01);
        shift_dir = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Shift left 7 times", test_num);
        reset_dut(8'h01);
        shift_dir = 0;
        repeat(7) @(posedge clk);
        #1;
        #1;

        check_outputs(8'h80);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Shift left 8 times (Full clear)", test_num);
        reset_dut(8'hFF);
        shift_dir = 0;
        repeat(8) @(posedge clk);
        #1;
        #1;

        check_outputs(8'h00);
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
        input [7:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,clk, in, rst, shift_dir, out);
    end

endmodule
