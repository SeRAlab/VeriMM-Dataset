`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [11:0] D;
    reg [11:0] I1;
    reg I3;
    reg rd_clk;
    reg wr_clk;
    wire [11:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D(D),
        .I1(I1),
        .I3(I3),
        .rd_clk(rd_clk),
        .wr_clk(wr_clk),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        I3 = 0;
        forever #5 I3 = ~I3;
    end

        task reset_dut;

        begin
            I3 = 1;
            D = 12'h0;
            I1 = 12'h0;
            #25;
            I3 = 0;
            #15;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running testcase%03d: Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(12'h000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running testcase%03d: Write Domain Transfer", test_num);
            reset_dut();
            D = 12'hA5A;
            @(posedge wr_clk);
            #2;
            #1;

            check_outputs(12'hA5A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running testcase%03d: Read Domain Transfer", test_num);
            reset_dut();
            I1 = 12'h5A5;
            @(posedge rd_clk);
            #2;
            #1;

            check_outputs(12'h5A5);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running testcase%03d: Sequential Write then Read", test_num);
            reset_dut();

            D = 12'h123;
            @(posedge wr_clk);
            #2;

            I1 = 12'h456;
            @(posedge rd_clk);
            #2;
            #1;

            check_outputs(12'h456);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running testcase%03d: Sequential Read then Write", test_num);
            reset_dut();

            I1 = 12'hABC;
            @(posedge rd_clk);
            #2;

            D = 12'hDEF;
            @(posedge wr_clk);
            #2;
            #1;

            check_outputs(12'hDEF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Running testcase%03d: Reset Priority", test_num);
            reset_dut();

            D = 12'hFFF;
            @(posedge wr_clk);
            #2;

            I3 = 1;
            #5;
            #1;

            check_outputs(12'h000);
            I3 = 0;
            #5;
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Running testcase%03d: Stability Check", test_num);
            reset_dut();
            D = 12'h666;
            I1 = 12'h999;
            #50;

            #1;


            check_outputs(12'h000);
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
        input [11:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,D, I1, I3, rd_clk, wr_clk, Q);
    end

endmodule
