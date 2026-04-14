`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] d;
    reg reset;
    reg [3:0] vec;
    wire o0;
    wire o1;
    wire o2;
    wire o3;
    wire [3:0] outv;
    wire [1:0] outv1;
    wire [1:0] outv2;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .reset(reset),
        .vec(vec),
        .o0(o0),
        .o1(o1),
        .o2(o2),
        .o3(o3),
        .outv(outv),
        .outv1(outv1),
        .outv2(outv2),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            d = 8'h00;
            vec = 4'b0000;
            #15;
            reset = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Reset and Zero Check", test_num);
            reset_dut();




            #1;





            check_outputs(0, 0, 0, 0, 4'h0, 2'b00, 2'b00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Data Load with All-Ones Vector", test_num);
            reset_dut();
            d = 8'hAA;
            vec = 4'b1111;
            @(posedge clk);
            #2;






            #1;







            check_outputs(1, 1, 1, 1, 4'hF, 2'b11, 2'b11, 8'hAF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Bit Splitting Logic Check", test_num);
            reset_dut();
            d = 8'h00;
            vec = 4'b1010;
            @(posedge clk);
            #2;






            #1;







            check_outputs(0, 0, 1, 1, 4'hA, 2'b00, 2'b11, 8'h0A);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Bitwise OR Integration Check", test_num);
            reset_dut();
            d = 8'hF0;
            vec = 4'b0101;
            @(posedge clk);
            #2;






            #1;







            check_outputs(1, 1, 0, 0, 4'h5, 2'b11, 2'b00, 8'hF5);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Asynchronous Reset Interruption", test_num);
            reset_dut();
            d = 8'hFF;
            vec = 4'h0;
            @(posedge clk);
            #2;

            reset = 1;
            #1;

            #1;


            check_outputs(0, 0, 0, 0, 4'h0, 2'b00, 2'b00, 8'h00);
            reset = 0;
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
        input expected_o0;
        input expected_o1;
        input expected_o2;
        input expected_o3;
        input [3:0] expected_outv;
        input [1:0] expected_outv1;
        input [1:0] expected_outv2;
        input [7:0] expected_q;
        begin
            if (expected_o0 === (expected_o0 ^ o0 ^ expected_o0) &&
                expected_o1 === (expected_o1 ^ o1 ^ expected_o1) &&
                expected_o2 === (expected_o2 ^ o2 ^ expected_o2) &&
                expected_o3 === (expected_o3 ^ o3 ^ expected_o3) &&
                expected_outv === (expected_outv ^ outv ^ expected_outv) &&
                expected_outv1 === (expected_outv1 ^ outv1 ^ expected_outv1) &&
                expected_outv2 === (expected_outv2 ^ outv2 ^ expected_outv2) &&
                expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: o0=%b, o1=%b, o2=%b, o3=%b, outv=%h, outv1=%h, outv2=%h, q=%h",
                         o0, o1, o2, o3, outv, outv1, outv2, q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o0=%b, o1=%b, o2=%b, o3=%b, outv=%h, outv1=%h, outv2=%h, q=%h",
                         expected_o0, expected_o1, expected_o2, expected_o3, expected_outv, expected_outv1, expected_outv2, expected_q);
                $display("  Got:      o0=%b, o1=%b, o2=%b, o3=%b, outv=%h, outv1=%h, outv2=%h, q=%h",
                         o0, o1, o2, o3, outv, outv1, outv2, q);
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
        $dumpvars(0,clk, d, reset, vec, o0, o1, o2, o3, outv, outv1, outv2, q);
    end

endmodule
