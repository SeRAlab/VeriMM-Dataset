`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Ld;
    reg clk;
    reg clr;
    reg [31:0] in_D;
    wire [31:0] out_Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Ld(Ld),
        .clk(clk),
        .clr(clr),
        .in_D(in_D),
        .out_Q(out_Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            clr = 1;
            Ld = 0;
            in_D = 32'h0;
            #10;
            clr = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Synchronous Load 0xDEADBEEF", test_num);
            reset_dut();

            @(posedge clk);
            in_D = 32'hDEADBEEF;
            Ld = 1;

            @(posedge clk);
            #1;
            Ld = 0;

            #1;


            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Synchronous Load Disabled (Ld=0)", test_num);
            reset_dut();

            @(posedge clk);
            in_D = 32'hCAFEF00D;
            Ld = 0;

            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Asynchronous Clear override", test_num);
            reset_dut();


            @(posedge clk);
            in_D = 32'h12345678;
            Ld = 1;
            @(posedge clk);
            #1;


            #3;
            clr = 1;
            #2;

            #1;


            check_outputs(32'h00000000);
            clr = 0;
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Load 0xFFFFFFFF", test_num);
            reset_dut();

            @(posedge clk);
            in_D = 32'hFFFFFFFF;
            Ld = 1;

            @(posedge clk);
            #1;

            #1;


            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Hold value after Ld is de-asserted", test_num);
            reset_dut();


            @(posedge clk);
            in_D = 32'hAAAA5555;
            Ld = 1;
            @(posedge clk);
            #1;


            Ld = 0;
            in_D = 32'h00000000;

            @(posedge clk);
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'hAAAA5555);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Consecutive loads", test_num);
            reset_dut();

            @(posedge clk);
            Ld = 1;
            in_D = 32'h1;
            @(posedge clk);
            #1;
            in_D = 32'h2;
            @(posedge clk);
            #1;
            in_D = 32'h3;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h3);
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
        input [31:0] expected_out_Q;
        begin
            if (expected_out_Q === (expected_out_Q ^ out_Q ^ expected_out_Q)) begin
                $display("PASS");
                $display("  Outputs: out_Q=%h",
                         out_Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_Q=%h",
                         expected_out_Q);
                $display("  Got:      out_Q=%h",
                         out_Q);
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
        $dumpvars(0,Ld, clk, clr, in_D, out_Q);
    end

endmodule
