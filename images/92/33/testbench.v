`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Lden;
    reg clk;
    reg [15:0] pi;
    reg rst;
    reg shiftEnable;
    reg sir;
    wire sol;
    wire [15:0] sout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Lden(Lden),
        .clk(clk),
        .pi(pi),
        .rst(rst),
        .shiftEnable(shiftEnable),
        .sir(sir),
        .sol(sol),
        .sout(sout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            Lden = 0;
            shiftEnable = 0;
            pi = 0;
            sir = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset Check", test_num);
            reset_dut();


            #1;



            check_outputs(1'b0, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Parallel Load 0xABCD", test_num);
            reset_dut();
            Lden = 1;
            pi = 16'hABCD;
            @(posedge clk);
            #1;
            Lden = 0;

            #1;


            check_outputs(1'b1, 16'hABCD);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Shift Left with sir=1", test_num);
            reset_dut();

            Lden = 1;
            pi = 16'h0001;
            @(posedge clk);
            #1;
            Lden = 0;

            shiftEnable = 1;
            sir = 1;
            @(posedge clk);
            #1;
            shiftEnable = 0;

            #1;


            check_outputs(1'b0, 16'h0003);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Verify MSB out (sol) during shift", test_num);
            reset_dut();

            Lden = 1;
            pi = 16'h8000;
            @(posedge clk);
            #1;
            Lden = 0;


            shiftEnable = 1;
            sir = 0;
            @(posedge clk);
            #1;
            shiftEnable = 0;

            #1;


            check_outputs(1'b0, 16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: 4-bit Shift Sequence", test_num);
            reset_dut();

            shiftEnable = 1;

            sir = 1; @(posedge clk); #1;
            sir = 0; @(posedge clk); #1;
            sir = 1; @(posedge clk); #1;
            sir = 1; @(posedge clk); #1;

            shiftEnable = 0;
            #1;

            check_outputs(1'b0, 16'h000B);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Lden vs shiftEnable Priority", test_num);
            reset_dut();

            Lden = 1;
            pi = 16'hAAAA;
            @(posedge clk);
            #1;


            Lden = 1;
            pi = 16'h5555;
            shiftEnable = 1;
            sir = 1;
            @(posedge clk);
            #1;

            Lden = 0;
            shiftEnable = 0;

            #1;


            check_outputs(1'b0, 16'h5555);
        end
        endtask

    task testcase007;

        integer i;
        begin
            test_num = 7;
            $display("Testcase %0d: Shift bit through entire register", test_num);
            reset_dut();

            Lden = 1;
            pi = 16'h0001;
            @(posedge clk);
            #1;
            Lden = 0;


            shiftEnable = 1;
            sir = 0;
            for(i = 0; i < 15; i = i + 1) begin
                @(posedge clk);
                #1;
            end
            shiftEnable = 0;


            #1;



            check_outputs(1'b1, 16'h8000);
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
        input expected_sol;
        input [15:0] expected_sout;
        begin
            if (expected_sol === (expected_sol ^ sol ^ expected_sol) &&
                expected_sout === (expected_sout ^ sout ^ expected_sout)) begin
                $display("PASS");
                $display("  Outputs: sol=%b, sout=%h",
                         sol, sout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sol=%b, sout=%h",
                         expected_sol, expected_sout);
                $display("  Got:      sol=%b, sout=%h",
                         sol, sout);
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
        $dumpvars(0,Lden, clk, pi, rst, shiftEnable, sir, sol, sout);
    end

endmodule
