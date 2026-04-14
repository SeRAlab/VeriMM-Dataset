`timescale 1ns/1ps

module shift_reg_64bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [63:0] load_data;
    reg rst;
    reg shift_left;
    reg shift_right;
    wire [63:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_reg_64bit dut (
        .clk(clk),
        .load(load),
        .load_data(load_data),
        .rst(rst),
        .shift_left(shift_left),
        .shift_right(shift_right),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            rst = 1;
            load = 0;
            shift_left = 0;
            shift_right = 0;
            load_data = 64'b0;
            @(negedge clk);
            rst = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Basic Reset", test_num);
            reset_dut();

            #1;


            check_outputs(64'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Parallel Load", test_num);
            reset_dut();
            @(negedge clk);
            load = 1;
            load_data = 64'hFEDCBA9876543210;
            @(negedge clk);
            load = 0;
            #1;

            check_outputs(64'hFEDCBA9876543210);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Single Shift Left", test_num);
            reset_dut();

            @(negedge clk);
            load = 1;
            load_data = 64'h0000000000000001;
            @(negedge clk);
            load = 0;

            shift_left = 1;
            @(negedge clk);
            shift_left = 0;
            #1;

            check_outputs(64'h0000000000000002);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Single Shift Right", test_num);
            reset_dut();

            @(negedge clk);
            load = 1;
            load_data = 64'h8000000000000000;
            @(negedge clk);
            load = 0;

            shift_right = 1;
            @(negedge clk);
            shift_right = 0;
            #1;

            check_outputs(64'h4000000000000000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Multiple Shift Left", test_num);
            reset_dut();
            @(negedge clk);
            load = 1;
            load_data = 64'h000000000000000F;
            @(negedge clk);
            load = 0;
            shift_left = 1;
            repeat(4) @(negedge clk);
            shift_left = 0;
            #1;

            check_outputs(64'h00000000000000F0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Multiple Shift Right", test_num);
            reset_dut();
            @(negedge clk);
            load = 1;
            load_data = 64'hFF00000000000000;
            @(negedge clk);
            load = 0;
            shift_right = 1;
            repeat(8) @(negedge clk);
            shift_right = 0;
            #1;

            check_outputs(64'h00FF000000000000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: Shift Left Overflow", test_num);
            reset_dut();
            @(negedge clk);
            load = 1;
            load_data = 64'h8000000000000000;
            @(negedge clk);
            load = 0;
            shift_left = 1;
            @(negedge clk);
            shift_left = 0;
            #1;

            check_outputs(64'h0000000000000000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("\nTestcase %0d: Load Priority Check", test_num);
            reset_dut();
            @(negedge clk);
            load = 1;
            shift_left = 1;
            load_data = 64'hAAAA5555AAAA5555;
            @(negedge clk);
            load = 0;
            shift_left = 0;

            #1;


            check_outputs(64'hAAAA5555AAAA5555);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("\nTestcase %0d: Shift Right Underflow", test_num);
            reset_dut();
            @(negedge clk);
            load = 1;
            load_data = 64'h0000000000000001;
            @(negedge clk);
            load = 0;
            shift_right = 1;
            @(negedge clk);
            shift_right = 0;
            #1;

            check_outputs(64'h0000000000000000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_reg_64bit Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        
        
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
        input [63:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, load, load_data, rst, shift_left, shift_right, q);
    end

endmodule
