`timescale 1ns/1ps

module adc_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] din;
    reg reset;
    wire [7:0] dout;
    wire ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_controller dut (
        .clk(clk),
        .din(din),
        .reset(reset),
        .dout(dout),
        .ready(ready)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            din = 16'h0;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Input 16'h0000 (Min)", test_num);
            reset_dut();
            din = 16'h0000;

            while (!ready) @(posedge clk);
            #1;

            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Input 16'hFFFF (Max)", test_num);
            reset_dut();
            din = 16'hFFFF;
            while (!ready) @(posedge clk);
            #1;

            check_outputs(8'hFF, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Input 16'h0100 (Value 256)", test_num);
            reset_dut();
            din = 16'h0100;
            while (!ready) @(posedge clk);
            #1;

            check_outputs(8'h01, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Input 16'h00FF (Value 255)", test_num);
            reset_dut();
            din = 16'h00FF;
            while (!ready) @(posedge clk);
            #1;

            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Input 16'hA55A", test_num);
            reset_dut();
            din = 16'hA55A;
            while (!ready) @(posedge clk);
            #1;

            check_outputs(8'hA5, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Input 16'h1234", test_num);
            reset_dut();
            din = 16'h1234;
            while (!ready) @(posedge clk);
            #1;

            check_outputs(8'h12, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adc_controller Testbench");
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
        input [7:0] expected_dout;
        input expected_ready;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_ready === (expected_ready ^ ready ^ expected_ready)) begin
                $display("PASS");
                $display("  Outputs: dout=%h, ready=%b",
                         dout, ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h, ready=%b",
                         expected_dout, expected_ready);
                $display("  Got:      dout=%h, ready=%b",
                         dout, ready);
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
        $dumpvars(0,clk, din, reset, dout, ready);
    end

endmodule
