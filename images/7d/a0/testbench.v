`timescale 1ns/1ps

module johnson_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    johnson_counter dut (
        .clk(clk),
        .rst(rst),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            @(posedge clk);
            #1;
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Resetting...");
            reset_dut();
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: 1 clock cycle after reset...");
            reset_dut();
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            $display("Test Case 003: 4 clock cycles after reset...");
            reset_dut();
            for (i = 0; i < 4; i = i + 1) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h0F);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            $display("Test Case 004: 8 clock cycles (Half period - all ones)...");
            reset_dut();
            for (i = 0; i < 8; i = i + 1) @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            $display("Test Case 005: 12 clock cycles (Inversion phase)...");
            reset_dut();
            for (i = 0; i < 12; i = i + 1) @(posedge clk);
            #1;
            #1;

            check_outputs(8'hF0);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = 6;
            $display("Test Case 006: 15 clock cycles (Last state before wrap)...");
            reset_dut();
            for (i = 0; i < 15; i = i + 1) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h80);
        end
        endtask

    task testcase007;

        integer i;
        begin
            test_num = 7;
            $display("Test Case 007: 16 clock cycles (Full period loop)...");
            reset_dut();
            for (i = 0; i < 16; i = i + 1) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase008;

        integer i;
        begin
            test_num = 8;
            $display("Test Case 008: 20 clock cycles (Loop wrap-around)...");
            reset_dut();
            for (i = 0; i < 20; i = i + 1) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h0F);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("johnson_counter Testbench");
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
        $dumpvars(0,clk, rst, q);
    end

endmodule
