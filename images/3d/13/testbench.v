`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data_in;
    reg rst;
    wire [15:0] shift_reg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .shift_reg(shift_reg)
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
            #15;
            rst = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying Reset functionality", test_num);
            reset_dut();

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift single '1' bit 4 positions", test_num);
            reset_dut();


            @(negedge clk);
            data_in = 1;
            @(negedge clk);
            data_in = 0;


            repeat (3) @(negedge clk);


            #1;



            check_outputs(16'h0008);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Fill register with all 1s (16 shifts)", test_num);
            reset_dut();

            @(negedge clk);
            data_in = 1;
            repeat (15) @(negedge clk);


            #1;



            check_outputs(16'hFFFF);
        end
        endtask

    task testcase004;

        reg [15:0] pattern;
        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load pattern 0xA5A5", test_num);
            reset_dut();
            pattern = 16'hA5A5;

            for (i = 15; i >= 0; i = i - 1) begin
                @(negedge clk);
                data_in = pattern[i];
            end
            @(negedge clk);

            #1;


            check_outputs(16'hA5A5);
        end
        endtask

    task testcase005;

        reg [19:0] long_pattern;
        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift 20 bits (Overflow check)", test_num);
            reset_dut();
            long_pattern = 20'h1ABCD;

            for (i = 19; i >= 0; i = i - 1) begin
                @(negedge clk);
                data_in = long_pattern[i];
            end
            @(negedge clk);

            #1;


            check_outputs(16'hABCD);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Asynchronous reset during operation", test_num);
            reset_dut();


            @(negedge clk);
            data_in = 1;
            repeat (5) @(negedge clk);


            #3 rst = 1;
            #5;
            rst = 0;

            #1;


            check_outputs(16'h0000);
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
        input [15:0] expected_shift_reg;
        begin
            if (expected_shift_reg === (expected_shift_reg ^ shift_reg ^ expected_shift_reg)) begin
                $display("PASS");
                $display("  Outputs: shift_reg=%h",
                         shift_reg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: shift_reg=%h",
                         expected_shift_reg);
                $display("  Got:      shift_reg=%h",
                         shift_reg);
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
        $dumpvars(0,clk, data_in, rst, shift_reg);
    end

endmodule
