`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [23:0] rgb_0;
    reg [23:0] rgb_1;
    reg sel;
    wire [23:0] rgb_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rgb_0(rgb_0),
        .rgb_1(rgb_1),
        .sel(sel),
        .rgb_out(rgb_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            sel = 0;
            rgb_0 = 24'h000000;
            rgb_1 = 24'h000000;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Select rgb_0 (Pure Red)", test_num);
            rgb_0 = 24'hFF0000;
            rgb_1 = 24'h00FF00;
            sel = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(24'hFF0000);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Select rgb_1 (Pure Green)", test_num);
            rgb_0 = 24'hFF0000;
            rgb_1 = 24'h00FF00;
            sel = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(24'h00FF00);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Select rgb_0 (White)", test_num);
            rgb_0 = 24'hFFFFFF;
            rgb_1 = 24'h123456;
            sel = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(24'hFFFFFF);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Select rgb_1 (Black)", test_num);
            rgb_0 = 24'hABCDEF;
            rgb_1 = 24'h000000;
            sel = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(24'h000000);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Verify output updates on clock edge after sel change", test_num);


            rgb_0 = 24'hAAAAAA;
            rgb_1 = 24'h555555;
            sel = 0;
            @(posedge clk);
            #2;


            sel = 1;
            #2;

            if (rgb_out == 24'hAAAAAA) begin
                @(posedge clk);
                #2;
                #1;

                check_outputs(24'h555555);
            end else begin
                $display("FAIL: Output updated asynchronously");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Random pattern test", test_num);
            rgb_0 = 24'h3C9BEF;
            rgb_1 = 24'hA5C332;
            sel = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(24'hA5C332);
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
        input [23:0] expected_rgb_out;
        begin
            if (expected_rgb_out === (expected_rgb_out ^ rgb_out ^ expected_rgb_out)) begin
                $display("PASS");
                $display("  Outputs: rgb_out=%h",
                         rgb_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rgb_out=%h",
                         expected_rgb_out);
                $display("  Got:      rgb_out=%h",
                         rgb_out);
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
        $dumpvars(0,clk, rgb_0, rgb_1, sel, rgb_out);
    end

endmodule
