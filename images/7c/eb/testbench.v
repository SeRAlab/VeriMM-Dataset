`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [23:0] data;
    reg load_enable;
    reg shift;
    reg sreset;
    wire [23:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .data(data),
        .load_enable(load_enable),
        .shift(shift),
        .sreset(sreset),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            sreset = 1;
            load_enable = 0;
            shift = 0;
            data = 24'b0;
            @(posedge clk);
            #1 sreset = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic Load Operation");
            test_num = 1;
            reset_dut();
            @(negedge clk);
            data = 24'hABCDEF;
            load_enable = 1;
            @(posedge clk);
            #1 load_enable = 0;
            #1;

            check_outputs(24'hABCDEF);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Reset Functionality");
            test_num = 2;
            reset_dut();
            @(negedge clk);
            data = 24'hFFFFFF;
            load_enable = 1;
            @(posedge clk);
            #1 load_enable = 0;
            sreset = 1;
            @(posedge clk);
            #1 sreset = 0;
            #1;

            check_outputs(24'h000000);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Single Shift Left");
            test_num = 3;
            reset_dut();
            @(negedge clk);
            data = 24'h000001;
            load_enable = 1;
            @(posedge clk);
            #1 load_enable = 0;
            shift = 1;
            @(posedge clk);
            #1 shift = 0;
            #1;

            check_outputs(24'h000002);
        end
        endtask

    task testcase004;

        integer i;
        begin
            $display("Running testcase004: Multiple Shifts (4 bits)");
            test_num = 4;
            reset_dut();
            @(negedge clk);
            data = 24'h00000F;
            load_enable = 1;
            @(posedge clk);
            #1 load_enable = 0;
            shift = 1;
            repeat(4) @(posedge clk);
            #1 shift = 0;
            #1;

            check_outputs(24'h0000F0);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Priority Check (Load > Shift)");
            test_num = 5;
            reset_dut();
            @(negedge clk);
            data = 24'hAAAAAA;
            load_enable = 1;
            shift = 1;
            @(posedge clk);
            #1 load_enable = 0;
            shift = 0;
            #1;

            check_outputs(24'hAAAAAA);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Priority Check (Reset > Load)");
            test_num = 6;
            reset_dut();
            @(negedge clk);
            data = 24'h555555;
            load_enable = 1;
            sreset = 1;
            @(posedge clk);
            #1 load_enable = 0;
            sreset = 0;
            #1;

            check_outputs(24'h000000);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: Shift MSB Out");
            test_num = 7;
            reset_dut();
            @(negedge clk);
            data = 24'h800000;
            load_enable = 1;
            @(posedge clk);
            #1 load_enable = 0;
            shift = 1;
            @(posedge clk);
            #1 shift = 0;
            #1;

            check_outputs(24'h000000);
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
        input [23:0] expected_q;
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
        $dumpvars(0,clk, data, load_enable, shift, sreset, q);
    end

endmodule
