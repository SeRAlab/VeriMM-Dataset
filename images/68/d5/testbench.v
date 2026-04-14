`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] din;
    reg load;
    reg shift;
    wire [15:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .din(din),
        .load(load),
        .shift(shift),
        .dout(dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            load = 0;
            shift = 0;
            din = 0;
            @(posedge clk);
            load = 1;
            din = 16'h0000;
            @(posedge clk);
            load = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Loading value 0xABCD", test_num);

            @(negedge clk);
            load = 1;
            din = 16'hABCD;
            @(posedge clk);
            #1;
            load = 0;

            #1;


            check_outputs(16'hABCD);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Load 0x0001 and Shift Left Once", test_num);

            @(negedge clk);
            load = 1;
            din = 16'h0001;
            @(posedge clk);

            @(negedge clk);
            load = 0;
            shift = 1;
            @(posedge clk);
            #1;
            shift = 0;

            #1;


            check_outputs(16'h0002);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Load 0x000F and Shift Left 4 times", test_num);

            @(negedge clk);
            load = 1;
            din = 16'h000F;
            @(posedge clk);

            @(negedge clk);
            load = 0;
            shift = 1;
            repeat(4) @(posedge clk);
            #1;
            shift = 0;

            #1;


            check_outputs(16'h00F0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Load 0xFFFF and Shift once", test_num);

            @(negedge clk);
            load = 1;
            din = 16'hFFFF;
            @(posedge clk);

            @(negedge clk);
            load = 0;
            shift = 1;
            @(posedge clk);
            #1;
            shift = 0;


            #1;



            check_outputs(16'hFFFE);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Hold value for 3 cycles", test_num);

            @(negedge clk);
            load = 1;
            din = 16'h55AA;
            @(posedge clk);

            @(negedge clk);
            load = 0;
            shift = 0;
            repeat(3) @(posedge clk);
            #1;

            #1;


            check_outputs(16'h55AA);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Load 0x1234 and Shift 16 times", test_num);

            @(negedge clk);
            load = 1;
            din = 16'h1234;
            @(posedge clk);

            @(negedge clk);
            load = 0;
            shift = 1;
            repeat(16) @(posedge clk);
            #1;
            shift = 0;

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Load priority (Load=1, Shift=1)", test_num);

            @(negedge clk);
            load = 1;
            din = 16'hAAAA;
            @(posedge clk);

            @(negedge clk);
            load = 1;
            shift = 1;
            din = 16'hBBBB;
            @(posedge clk);
            #1;


            #1;



            check_outputs(16'hBBBB);
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
        input [15:0] expected_dout;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: dout=%h",
                         dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h",
                         expected_dout);
                $display("  Got:      dout=%h",
                         dout);
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
        $dumpvars(0,clk, din, load, shift, dout);
    end

endmodule
