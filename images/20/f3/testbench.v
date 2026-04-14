`timescale 1ns/1ps

module LDO_Control_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg vin;
    reg vref;
    wire enable;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LDO_Control dut (
        .clk(clk),
        .rst(rst),
        .vin(vin),
        .vref(vref),
        .enable(enable)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            vin = 0;
            vref = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Simple Enable (vin > vref)", test_num);
            reset_dut();
            vin = 1;
            vref = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Simple Disable (vin < vref)", test_num);
            reset_dut();
            vin = 0;
            vref = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Latch Enable High (vin == vref after vin > vref)", test_num);
            reset_dut();

            vin = 1;
            vref = 0;
            @(posedge clk);
            #1;

            vin = 1;
            vref = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Latch Disable Low (vin == vref after reset)", test_num);
            reset_dut();

            vin = 0;
            vref = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Full Sequence Transition", test_num);
            reset_dut();


            vin = 1; vref = 0;
            @(posedge clk);


            vin = 1; vref = 1;
            @(posedge clk);


            vin = 0; vref = 1;
            @(posedge clk);


            vin = 0; vref = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Reset Override (rst=1 while vin > vref)", test_num);
            reset_dut();
            rst = 1;
            vin = 1;
            vref = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("LDO_Control Testbench");
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
        input expected_enable;
        begin
            if (expected_enable === (expected_enable ^ enable ^ expected_enable)) begin
                $display("PASS");
                $display("  Outputs: enable=%b",
                         enable);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: enable=%b",
                         expected_enable);
                $display("  Got:      enable=%b",
                         enable);
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
        $dumpvars(0,clk, rst, vin, vref, enable);
    end

endmodule
