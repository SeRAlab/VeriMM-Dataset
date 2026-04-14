`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg load;
    wire [15:0] reg_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .reg_out(reg_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            load <= 1;
            data_in <= 16'h0000;
            @(posedge clk);
            load <= 0;
            data_in <= 16'h0000;
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %0d: Parallel Load 0xABCD", test_num);
            @(posedge clk);
            load <= 1;
            data_in <= 16'hABCD;
            @(posedge clk);
            load <= 0;
            #1;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %0d: Shift Left 1 Position", test_num);
            @(posedge clk);
            load <= 1;
            data_in <= 16'h0001;
            @(posedge clk);
            load <= 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0002);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %0d: Shift Left 8 Positions", test_num);
            @(posedge clk);
            load <= 1;
            data_in <= 16'h00FF;
            @(posedge clk);
            load <= 0;
            repeat(8) @(posedge clk);
            #1;
            #1;

            check_outputs(16'hFF00);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %0d: Shift Out MSB", test_num);
            @(posedge clk);
            load <= 1;
            data_in <= 16'h8000;
            @(posedge clk);
            load <= 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %0d: Full Shift Out (16 cycles)", test_num);
            @(posedge clk);
            load <= 1;
            data_in <= 16'hFFFF;
            @(posedge clk);
            load <= 0;
            repeat(16) @(posedge clk);
            #1;
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
        input [15:0] expected_reg_out;
        begin
            if (expected_reg_out === (expected_reg_out ^ reg_out ^ expected_reg_out)) begin
                $display("PASS");
                $display("  Outputs: reg_out=%h",
                         reg_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: reg_out=%h",
                         expected_reg_out);
                $display("  Got:      reg_out=%h",
                         reg_out);
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
        $dumpvars(0,clk, data_in, load, reg_out);
    end

endmodule
