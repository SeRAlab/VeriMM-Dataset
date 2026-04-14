`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] raddr_i;
    reg [2:0] waddr_i;
    reg [7:0] wdin_i;
    reg wren_i;
    wire [7:0] rdout_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .raddr_i(raddr_i),
        .waddr_i(waddr_i),
        .wdin_i(wdin_i),
        .wren_i(wren_i),
        .rdout_o(rdout_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            wren_i = 0;
            waddr_i = 0;
            wdin_i = 0;
            raddr_i = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic Write and Read...");
            reset_dut();


            @(posedge clk);
            wren_i = 1;
            waddr_i = 3'h2;
            wdin_i = 8'hA5;

            @(posedge clk);
            wren_i = 0;
            raddr_i = 3'h2;


            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Write address 7, then read address 7...");
            reset_dut();


            @(posedge clk);
            wren_i = 1;
            waddr_i = 3'h7;
            wdin_i = 8'h5A;

            @(posedge clk);
            wren_i = 0;
            raddr_i = 3'h7;

            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Overwriting data at address 4...");
            reset_dut();


            @(posedge clk);
            wren_i = 1;
            waddr_i = 3'h4;
            wdin_i = 8'h11;


            @(posedge clk);
            wdin_i = 8'h22;

            @(posedge clk);
            wren_i = 0;
            raddr_i = 3'h4;

            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h22);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Verifying wren_i disable...");
            reset_dut();


            @(posedge clk);
            wren_i = 1;
            waddr_i = 3'h1;
            wdin_i = 8'hCC;


            @(posedge clk);
            wren_i = 0;
            waddr_i = 3'h1;
            wdin_i = 8'hDD;

            @(posedge clk);
            raddr_i = 3'h1;

            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hCC);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Simultaneous read and write...");
            reset_dut();


            @(posedge clk);
            wren_i = 1;
            waddr_i = 3'h0;
            wdin_i = 8'h66;


            @(posedge clk);
            wren_i = 1;
            waddr_i = 3'h5;
            wdin_i = 8'h77;
            raddr_i = 3'h0;

            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h66);


            wren_i = 0;
            raddr_i = 3'h5;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h77);
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
        input [7:0] expected_rdout_o;
        begin
            if (expected_rdout_o === (expected_rdout_o ^ rdout_o ^ expected_rdout_o)) begin
                $display("PASS");
                $display("  Outputs: rdout_o=%h",
                         rdout_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rdout_o=%h",
                         expected_rdout_o);
                $display("  Got:      rdout_o=%h",
                         rdout_o);
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
        $dumpvars(0,clk, raddr_i, waddr_i, wdin_i, wren_i, rdout_o);
    end

endmodule
