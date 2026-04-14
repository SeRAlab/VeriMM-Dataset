`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [6:0] a;
    reg a_msb;
    reg clk;
    wire [14:0] b;
    wire b_msb;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .a_msb(a_msb),
        .clk(clk),
        .b(b),
        .b_msb(b_msb)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            a = 0;
            a_msb = 0;
            repeat(2) @(posedge clk);
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(15'h0000, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            a = 7'd10;
            a_msb = 0;
            @(posedge clk);
            #1;



            #1;




            check_outputs(15'h0014, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            a = 7'd10;
            a_msb = 1;
            @(posedge clk);
            #1;



            #1;




            check_outputs(15'h0213, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            a = 7'd0;
            a_msb = 1;
            repeat(2) @(posedge clk);
            #1;



            #1;




            check_outputs(15'h03FC, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            a = 7'd127;
            a_msb = 1;
            repeat(50) @(posedge clk);
            #1;






            #1;







            check_outputs(15'h1539, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            a = 7'd127;
            a_msb = 1;
            repeat(100) @(posedge clk);
            #1;




            #1;





            check_outputs(15'h2A70, 1'b0);
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
        input [14:0] expected_b;
        input expected_b_msb;
        begin
            if (expected_b === (expected_b ^ b ^ expected_b) &&
                expected_b_msb === (expected_b_msb ^ b_msb ^ expected_b_msb)) begin
                $display("PASS");
                $display("  Outputs: b=%h, b_msb=%b",
                         b, b_msb);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: b=%h, b_msb=%b",
                         expected_b, expected_b_msb);
                $display("  Got:      b=%h, b_msb=%b",
                         b, b_msb);
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
        $dumpvars(0,a, a_msb, clk, b, b_msb);
    end

endmodule
