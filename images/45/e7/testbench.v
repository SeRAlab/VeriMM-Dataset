`timescale 1ns/1ps

module shift_register_8bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg load;
    reg shift_in;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register_8bit dut (
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .shift_in(shift_in),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            load = 0;
            data_in = 8'h00;
            shift_in = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %03d: Parallel Load 8'hA5", test_num);
            load = 1;
            data_in = 8'hA5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %03d: Shift Left with 0 (Initial 8'hFF)", test_num);

            load = 1;
            data_in = 8'hFF;
            @(posedge clk);
            #1;

            load = 0;
            shift_in = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFE);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %03d: Shift Left with 1 (Initial 8'h00)", test_num);

            load = 1;
            data_in = 8'h00;
            @(posedge clk);
            #1;

            load = 0;
            shift_in = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %03d: Multiple Shifts (Initial 8'h55)", test_num);

            load = 1;
            data_in = 8'h55;
            @(posedge clk);
            #1;

            load = 0;
            shift_in = 1;
            @(posedge clk);
            #1;

            shift_in = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h56);
        end
        endtask

    task testcase005;

        integer i;
        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %03d: Full Shift Through", test_num);

            load = 1;
            data_in = 8'h01;
            @(posedge clk);
            #1;

            load = 0;
            shift_in = 0;
            repeat(7) begin
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(8'h80);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_register_8bit Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input [7:0] expected_q;
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
        $dumpvars(0,clk, data_in, load, shift_in, q);
    end

endmodule
