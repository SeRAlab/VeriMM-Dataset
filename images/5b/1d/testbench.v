`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] d;
    wire [23:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            d = 8'h00;
            repeat (4) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sequential shift 0xAA, 0xBB, 0xCC", test_num);
            reset_dut();

            @(negedge clk) d = 8'hAA;
            @(negedge clk) d = 8'hBB;
            @(negedge clk) d = 8'hCC;

            @(posedge clk);
            #2;
            #1;

            check_outputs(24'hCCBBAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overwriting pipeline (4 shifts: 11, 22, 33, 44)", test_num);
            reset_dut();

            @(negedge clk) d = 8'h11;
            @(negedge clk) d = 8'h22;
            @(negedge clk) d = 8'h33;
            @(negedge clk) d = 8'h44;

            @(posedge clk);
            #2;

            #1;


            check_outputs(24'h443322);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary values 0x00 and 0xFF", test_num);
            reset_dut();

            @(negedge clk) d = 8'hFF;
            @(negedge clk) d = 8'h00;
            @(negedge clk) d = 8'hFF;

            @(posedge clk);
            #2;
            #1;

            check_outputs(24'hFF00FF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating bit patterns 0x55, 0xAA, 0x55", test_num);
            reset_dut();

            @(negedge clk) d = 8'h55;
            @(negedge clk) d = 8'hAA;
            @(negedge clk) d = 8'h55;

            @(posedge clk);
            #2;
            #1;

            check_outputs(24'h55AA55);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Long sequence 01->02->03->04->05", test_num);
            reset_dut();

            @(negedge clk) d = 8'h01;
            @(negedge clk) d = 8'h02;
            @(negedge clk) d = 8'h03;
            @(negedge clk) d = 8'h04;
            @(negedge clk) d = 8'h05;

            @(posedge clk);
            #2;

            #1;


            check_outputs(24'h050403);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        $dumpvars(0,clk, d, q);
    end

endmodule
