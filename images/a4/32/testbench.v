`timescale 1ns/1ps

module preset_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [11:0] in_data;
    reg load_enable;
    reg preset;
    wire [11:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    preset_register dut (
        .clk(clk),
        .in_data(in_data),
        .load_enable(load_enable),
        .preset(preset),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            preset = 1;
            load_enable = 0;
            in_data = 12'h000;
            @(posedge clk);
            #1;
            preset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Synchronous Preset", test_num);
            reset_dut();

            #1;


            check_outputs(12'hFFF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Load Enable with Specific Data", test_num);
            reset_dut();
            in_data = 12'hA5A;
            load_enable = 1;
            @(posedge clk);
            #1;
            load_enable = 0;
            #1;

            check_outputs(12'hA5A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Holding value when signals are low", test_num);
            reset_dut();

            in_data = 12'h123;
            load_enable = 1;
            @(posedge clk);
            #1;

            load_enable = 0;
            in_data = 12'hCBA;
            @(posedge clk);
            #1;
            #1;

            check_outputs(12'h123);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Preset Priority over Load Enable", test_num);
            reset_dut();
            in_data = 12'h555;
            load_enable = 1;
            preset = 1;
            @(posedge clk);
            #1;
            preset = 0;
            load_enable = 0;
            #1;

            check_outputs(12'hFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Loading 0x000", test_num);
            reset_dut();
            in_data = 12'h000;
            load_enable = 1;
            @(posedge clk);
            #1;
            load_enable = 0;
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
        $display("preset_register Testbench");
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
        input [11:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,clk, in_data, load_enable, preset, out);
    end

endmodule
