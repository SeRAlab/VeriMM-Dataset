`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] multiplicand_address;
    reg [3:0] multiplier_address;
    reg start;
    wire done;
    wire [7:0] p;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .multiplicand_address(multiplicand_address),
        .multiplier_address(multiplier_address),
        .start(start),
        .done(done),
        .p(p)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            start = 0;
            multiplier_address = 0;
            multiplicand_address = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task run_multiplication;

        input [3:0] a;
        input [3:0] b;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiplying %d * %d", test_num, a, b);

            multiplicand_address = a;
            multiplier_address = b;
            start = 1;
            @(posedge clk);
            #1;
            start = 0;



            while (done !== 1'b1) begin
                @(posedge clk);
                #1;
            end


            #1;



            check_outputs(1'b1, a * b);
        end
        endtask

    task testcase001;

        begin
            reset_dut();
            run_multiplication(4'd3, 4'd2);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            run_multiplication(4'd12, 4'd1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            run_multiplication(4'd0, 4'd15);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            run_multiplication(4'd0, 4'd0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            run_multiplication(4'd15, 4'd15);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            run_multiplication(4'd8, 4'd4);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            run_multiplication(4'd10, 4'd12);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            run_multiplication(4'd7, 4'd11);
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
        input expected_done;
        input [7:0] expected_p;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_p === (expected_p ^ p ^ expected_p)) begin
                $display("PASS");
                $display("  Outputs: done=%b, p=%h",
                         done, p);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, p=%h",
                         expected_done, expected_p);
                $display("  Got:      done=%b, p=%h",
                         done, p);
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
        $dumpvars(0,clk, multiplicand_address, multiplier_address, start, done, p);
    end

endmodule
