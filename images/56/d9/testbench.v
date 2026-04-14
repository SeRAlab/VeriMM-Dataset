`timescale 1ns/1ps

module shift_reg_4bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg load;
    reg reset;
    reg shift;
    wire [3:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_reg_4bit dut (
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .reset(reset),
        .shift(shift),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            reset = 1;
            load = 0;
            shift = 0;
            data_in = 4'b0000;
            @(posedge clk);
            reset = 0;
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Synchronous Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Parallel Load Check (4'b1010)", test_num);
            reset_dut();
            @(posedge clk);
            load = 1;
            data_in = 4'b1010;
            @(posedge clk);
            load = 0;
            #1;
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Shift Left Once (1011 -> 0110)", test_num);
            reset_dut();

            @(posedge clk);
            load = 1;
            data_in = 4'b1011;
            @(posedge clk);
            load = 0;

            shift = 1;
            @(posedge clk);
            shift = 0;
            #1;
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Shift Left Three Times (0001 -> 1000)", test_num);
            reset_dut();

            @(posedge clk);
            load = 1;
            data_in = 4'b0001;
            @(posedge clk);
            load = 0;

            shift = 1;
            repeat(3) @(posedge clk);
            shift = 0;
            #1;
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Priority Check (Load should override Shift)", test_num);
            reset_dut();

            @(posedge clk);
            load = 1;
            data_in = 4'b0101;
            @(posedge clk);

            load = 1;
            shift = 1;
            data_in = 4'b1111;
            @(posedge clk);
            load = 0;
            shift = 0;
            #1;

            #1;


            check_outputs(4'b1111);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Hold Value (Load/Shift/Reset all 0)", test_num);
            reset_dut();

            @(posedge clk);
            load = 1;
            data_in = 4'b1100;
            @(posedge clk);
            load = 0;
            shift = 0;
            reset = 0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(4'b1100);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Shift until empty (all zeros)", test_num);
            reset_dut();

            @(posedge clk);
            load = 1;
            data_in = 4'b1111;
            @(posedge clk);
            load = 0;
            shift = 1;
            repeat(4) @(posedge clk);
            shift = 0;
            #1;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_reg_4bit Testbench");
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
        input [3:0] expected_q;
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
        $dumpvars(0,clk, data_in, load, reset, shift, q);
    end

endmodule
