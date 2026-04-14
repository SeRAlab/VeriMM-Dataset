`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK_IN;
    reg [7:0] count_debounce;
    reg enb;
    reg reset;
    reg u;
    wire y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK_IN(CLK_IN),
        .count_debounce(count_debounce),
        .enb(enb),
        .reset(reset),
        .u(u),
        .y(y)
    );

    // Clock generation (10ns period)
    initial begin
        CLK_IN = 0;
        forever #5 CLK_IN = ~CLK_IN;
    end

        task reset_dut;

        begin
            reset = 1;
            enb = 0;
            u = 0;
            count_debounce = 8'd0;
            @(posedge CLK_IN);
            #1;
            reset = 0;
            @(posedge CLK_IN);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            enb = 1;
            count_debounce = 8'd10;
            u = 1;

            repeat(11) @(posedge CLK_IN);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            enb = 1;
            count_debounce = 8'd5;


            u = 1;
            repeat(6) @(posedge CLK_IN);


            u = 0;
            repeat(6) @(posedge CLK_IN);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            enb = 1;
            count_debounce = 8'd20;


            u = 1;
            repeat(10) @(posedge CLK_IN);


            u = 0;
            repeat(5) @(posedge CLK_IN);


            u = 1;
            repeat(15) @(posedge CLK_IN);

            #1;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            enb = 0;
            count_debounce = 8'd5;
            u = 1;


            repeat(10) @(posedge CLK_IN);
            #1;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            enb = 1;
            count_debounce = 8'd30;
            u = 1;


            repeat(25) @(posedge CLK_IN);
            #1;
            if (y !== 1'b0) begin
                 $display("Intermediate check failed: y changed too early");
            end


            repeat(10) @(posedge CLK_IN);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            enb = 1;
            count_debounce = 8'd10;

            u = 1;
            repeat(8) @(posedge CLK_IN);
            u = 0;
            repeat(2) @(posedge CLK_IN);
            u = 1;
            repeat(11) @(posedge CLK_IN);

            #1;
            #1;

            check_outputs(1'b1);
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
        input expected_y;
        begin
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%b",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%b",
                         expected_y);
                $display("  Got:      y=%b",
                         y);
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
        $dumpvars(0,CLK_IN, count_debounce, enb, reset, u, y);
    end

endmodule
