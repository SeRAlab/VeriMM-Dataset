`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] clcount;
    reg clk;
    reg enable;
    reg [9:0] tor_x;
    reg [8:0] tor_y;
    wire t_no;
    wire t_yes;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clcount(clcount),
        .clk(clk),
        .enable(enable),
        .tor_x(tor_x),
        .tor_y(tor_y),
        .t_no(t_no),
        .t_yes(t_yes)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            enable = 0;
            clcount = 0;
            tor_x = 0;
            tor_y = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Module Disabled, Coordinates inside R1", test_num);
            enable = 0;
            clcount = 2'b01;
            tor_x = 10'd150;
            tor_y = 9'd150;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Module Enabled, R1 Coords, clcount=1", test_num);
            enable = 1;
            clcount = 2'b01;
            tor_x = 10'd150;
            tor_y = 9'd150;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Module Enabled, R1 Coords, clcount=2", test_num);
            enable = 1;
            clcount = 2'b10;
            tor_x = 10'd150;
            tor_y = 9'd150;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Module Enabled, R2 Coords", test_num);
            enable = 1;
            clcount = 2'b01;
            tor_x = 10'd350;
            tor_y = 9'd150;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Module Enabled, Coords outside both", test_num);
            enable = 1;
            clcount = 2'b01;
            tor_x = 10'd50;
            tor_y = 9'd50;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Boundary Check R1 (Min X, Min Y)", test_num);
            enable = 1;
            clcount = 2'b01;
            tor_x = 10'd100;
            tor_y = 9'd100;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Boundary Check R2 (Max X, Max Y)", test_num);
            enable = 1;
            clcount = 2'b11;
            tor_x = 10'd400;
            tor_y = 9'd200;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: R2 Coords, clcount=0 (t_no should not depend on clcount)", test_num);
            enable = 1;
            clcount = 2'b00;
            tor_x = 10'd350;
            tor_y = 9'd150;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b0);
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
        input expected_t_no;
        input expected_t_yes;
        begin
            if (expected_t_no === (expected_t_no ^ t_no ^ expected_t_no) &&
                expected_t_yes === (expected_t_yes ^ t_yes ^ expected_t_yes)) begin
                $display("PASS");
                $display("  Outputs: t_no=%b, t_yes=%b",
                         t_no, t_yes);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: t_no=%b, t_yes=%b",
                         expected_t_no, expected_t_yes);
                $display("  Got:      t_no=%b, t_yes=%b",
                         t_no, t_yes);
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
        $dumpvars(0,clcount, clk, enable, tor_x, tor_y, t_no, t_yes);
    end

endmodule
