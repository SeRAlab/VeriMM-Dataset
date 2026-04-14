`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [14:0] enc_count;
    reg [7:0] hall_count;
    reg reset;
    wire fault;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .enc_count(enc_count),
        .hall_count(hall_count),
        .reset(reset),
        .fault(fault)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            enc_count = 0;
            hall_count = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Normal operation (Enc=0, Hall=0)", test_num);
            reset_dut();
            enc_count = 15'sd0;
            hall_count = 8'sd0;
            @(posedge clk);
            #2 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Fault (Enc=0, Hall=5)", test_num);
            reset_dut();
            enc_count = 15'sd0;
            hall_count = 8'sd5;
            @(posedge clk);
            #2 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Fault (Enc=0, Hall=-3)", test_num);
            reset_dut();
            enc_count = 15'sd0;
            hall_count = -8'sd3;
            @(posedge clk);
            #2 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: No Fault (Enc=10, Hall=10)", test_num);
            reset_dut();
            enc_count = 15'sd10;
            hall_count = 8'sd10;
            @(posedge clk);
            #2 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary (Enc=1, Hall=2)", test_num);
            reset_dut();
            enc_count = 15'sd1;
            hall_count = 8'sd2;
            @(posedge clk);
            #2 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary (Enc=-1, Hall=-2)", test_num);
            reset_dut();
            enc_count = -15'sd1;
            hall_count = -8'sd2;
            @(posedge clk);
            #2 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary Fault (Enc=1, Hall=3)", test_num);
            reset_dut();
            enc_count = 15'sd1;
            hall_count = 8'sd3;
            @(posedge clk);
            #2 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary Fault (Enc=-1, Hall=-3)", test_num);
            reset_dut();
            enc_count = -15'sd1;
            hall_count = -8'sd3;
            @(posedge clk);
            #2 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset clearing fault", test_num);
            reset_dut();
            enc_count = 15'sd0;
            hall_count = 8'sd5;
            @(posedge clk);
            #1;
            if (fault == 1'b1) begin
                reset = 1;
                @(posedge clk);
                #2 #1;
 check_outputs(1'b0);
                reset = 0;
            end else begin
                $display("FAIL: Fault did not trigger before reset check");
                fail_count = fail_count + 1;
            end
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
        testcase009();
        
        
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
        input expected_fault;
        begin
            if (expected_fault === (expected_fault ^ fault ^ expected_fault)) begin
                $display("PASS");
                $display("  Outputs: fault=%b",
                         fault);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: fault=%b",
                         expected_fault);
                $display("  Got:      fault=%b",
                         fault);
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
        $dumpvars(0,clk, enc_count, hall_count, reset, fault);
    end

endmodule
