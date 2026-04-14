`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] d_in;
    reg [14:0] r_addr;
    reg [14:0] w_addr;
    reg we;
    wire [15:0] d_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d_in(d_in),
        .r_addr(r_addr),
        .w_addr(w_addr),
        .we(we),
        .d_out(d_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            we = 0;
            w_addr = 0;
            r_addr = 0;
            d_in = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Simple Write and Read", test_num);


            we = 1;
            w_addr = 15'h0001;
            d_in = 16'hAAAA;
            @(posedge clk);
            #1;


            we = 0;
            r_addr = 15'h0001;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'hAAAA);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Different Data and Address", test_num);


            we = 1;
            w_addr = 15'h0123;
            d_in = 16'h5555;
            @(posedge clk);
            #1;

            we = 0;
            r_addr = 15'h0123;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h5555);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Write Enable check", test_num);


            we = 1;
            w_addr = 15'h0005;
            d_in = 16'h1111;
            @(posedge clk);
            #1;


            we = 0;
            w_addr = 15'h0005;
            d_in = 16'h2222;
            @(posedge clk);
            #1;


            r_addr = 15'h0005;
            @(posedge clk);
            #1;


            #1;



            check_outputs(16'h1111);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Overwriting an address", test_num);


            we = 1;
            w_addr = 15'h0ABC;
            d_in = 16'h1234;
            @(posedge clk);
            #1;


            w_addr = 15'h0ABC;
            d_in = 16'h4321;
            @(posedge clk);
            #1;

            we = 0;
            r_addr = 15'h0ABC;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h4321);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary address (0x7FFF) check", test_num);

            we = 1;
            w_addr = 15'h7FFF;
            d_in = 16'hFFFF;
            @(posedge clk);
            #1;

            we = 0;
            r_addr = 15'h7FFF;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'hFFFF);
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
        input [15:0] expected_d_out;
        begin
            if (expected_d_out === (expected_d_out ^ d_out ^ expected_d_out)) begin
                $display("PASS");
                $display("  Outputs: d_out=%h",
                         d_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: d_out=%h",
                         expected_d_out);
                $display("  Got:      d_out=%h",
                         d_out);
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
        $dumpvars(0,clk, d_in, r_addr, w_addr, we, d_out);
    end

endmodule
