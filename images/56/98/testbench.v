`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg [3:0] c;
    reg clk;
    wire [3:0] c_out;
    wire [3:0] s;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .clk(clk),
        .c_out(c_out),
        .s(s)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            a = 4'b0;
            b = 4'b0;
            c = 4'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = 4'h0; b = 4'h0; c = 4'h0;
            @(posedge clk);
            #2;
            $display("Test %0d: All Zeros", test_num);
            #1;

            check_outputs(4'h0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = 4'hF; b = 4'h0; c = 4'h0;
            @(posedge clk);
            #2;
            $display("Test %0d: a=F, b=0, c=0", test_num);
            #1;

            check_outputs(4'h0, 4'hF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = 4'hA; b = 4'hA; c = 4'h0;
            @(posedge clk);
            #2;
            $display("Test %0d: a=A, b=A, c=0 (Generate carries)", test_num);

            #1;


            check_outputs(4'hA, 4'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = 4'hF; b = 4'hF; c = 4'hF;
            @(posedge clk);
            #2;
            $display("Test %0d: All ones (a=F, b=F, c=F)", test_num);

            #1;


            check_outputs(4'hF, 4'hF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = 4'b1010; b = 4'b0101; c = 4'b1111;
            @(posedge clk);
            #2;
            $display("Test %0d: Mixed patterns", test_num);


            #1;



            check_outputs(4'hF, 4'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = 4'h7; b = 4'h3; c = 4'h1;
            @(posedge clk);
            #2;
            $display("Test %0d: random a=7, b=3, c=1", test_num);



            #1;




            check_outputs(4'h3, 4'h5);
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
        input [3:0] expected_c_out;
        input [3:0] expected_s;
        begin
            if (expected_c_out === (expected_c_out ^ c_out ^ expected_c_out) &&
                expected_s === (expected_s ^ s ^ expected_s)) begin
                $display("PASS");
                $display("  Outputs: c_out=%h, s=%h",
                         c_out, s);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: c_out=%h, s=%h",
                         expected_c_out, expected_s);
                $display("  Got:      c_out=%h, s=%h",
                         c_out, s);
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
        $dumpvars(0,a, b, c, clk, c_out, s);
    end

endmodule
