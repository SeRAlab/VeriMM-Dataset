`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [18:0] b;
    reg c;
    reg clk;
    reg [18:0] cx;
    reg [18:0] e;
    reg reset;
    wire [18:0] q;
    wire [18:0] rb;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .b(b),
        .c(c),
        .clk(clk),
        .cx(cx),
        .e(e),
        .reset(reset),
        .q(q),
        .rb(rb)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            b = 19'd0;
            e = 19'd0;
            c = 1'b0;
            cx = 19'd0;
            #15;
            reset = 0;

            repeat (3) @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(19'h0, 19'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            e = 19'h7AAAA;
            c = 1'b1;
            b = 19'h12345;
            @(posedge clk);


            e = 19'h0; c = 1'b0;
            @(posedge clk);
            @(posedge clk);

            #2;

            #1;


            check_outputs(19'h7AAAA, 19'h1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            e = 19'h7FFFF;
            c = 1'b0;
            @(posedge clk);

            repeat (2) @(posedge clk);
            #2;

            #1;


            check_outputs(19'h0, 19'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();


            e = 19'h11111; c = 1'b1; @(posedge clk);

            e = 19'h22222; c = 1'b1; @(posedge clk);

            e = 19'h33333; c = 1'b1; @(posedge clk);


            #2;
            $display("Checking Pipeline Index 1...");
            #1;

            check_outputs(19'h11111, 19'h1);

            @(posedge clk);
            #2;
            $display("Checking Pipeline Index 2...");
            #1;

            check_outputs(19'h22222, 19'h1);

            @(posedge clk);
            #2;
            $display("Checking Pipeline Index 3...");
            #1;

            check_outputs(19'h33333, 19'h1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            e = 19'h7FFFF; c = 1'b1;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #2;
            if (q !== 19'h7FFFF) $display("Error: Pipeline failed to fill");


            reset = 1;
            #1;
            #1;

            check_outputs(19'h0, 19'h0);
            #10 reset = 0;
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            e = 19'h55555;
            c = 1'b1;
            @(posedge clk);
            repeat (2) @(posedge clk);
            #2;
            #1;

            check_outputs(19'h55555, 19'h1);
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
        input [18:0] expected_q;
        input [18:0] expected_rb;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q) &&
                expected_rb === (expected_rb ^ rb ^ expected_rb)) begin
                $display("PASS");
                $display("  Outputs: q=%h, rb=%h",
                         q, rb);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h, rb=%h",
                         expected_q, expected_rb);
                $display("  Got:      q=%h, rb=%h",
                         q, rb);
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
        $dumpvars(0,b, c, clk, cx, e, reset, q, rb);
    end

endmodule
