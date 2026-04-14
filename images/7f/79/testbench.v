`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg regaddr_changed;
    reg rst_n;
    reg [7:0] zxuno_addr;
    reg zxuno_regrd;
    wire [7:0] dout;
    wire oe_n;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .regaddr_changed(regaddr_changed),
        .rst_n(rst_n),
        .zxuno_addr(zxuno_addr),
        .zxuno_regrd(zxuno_regrd),
        .dout(dout),
        .oe_n(oe_n)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            zxuno_addr = 8'h00;
            zxuno_regrd = 0;
            regaddr_changed = 0;
            @(posedge clk);
            #2 rst_n = 1;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Testcase %03d: Basic Read Request Asserting oe_n", test_num);

            zxuno_addr = TARGET_ADDR;
            zxuno_regrd = 1;

            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h5a, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Testcase %03d: Invalid Address Access", test_num);

            zxuno_addr = 8'h00;
            zxuno_regrd = 1;

            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hzz, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Testcase %03d: Read Command Deasserted", test_num);

            zxuno_addr = TARGET_ADDR;
            zxuno_regrd = 0;

            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hzz, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Testcase %03d: Sequential Character Access", test_num);

            zxuno_addr = TARGET_ADDR;
            zxuno_regrd = 1;


            @(posedge clk);

            @(posedge clk);
            #2;


            #1;



            check_outputs(8'h58, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Testcase %03d: Reset Pointer via regaddr_changed", test_num);

            zxuno_addr = TARGET_ADDR;
            zxuno_regrd = 1;


            repeat(3) @(posedge clk);


            #1 regaddr_changed = 1;
            @(posedge clk);
            #1 regaddr_changed = 0;


            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h5a, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            $display("Testcase %03d: Memory Wrap Around", test_num);

            zxuno_addr = TARGET_ADDR;
            zxuno_regrd = 1;


            repeat(8) @(posedge clk);


            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h5a, 1'b0);
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
        input [7:0] expected_dout;
        input expected_oe_n;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_oe_n === (expected_oe_n ^ oe_n ^ expected_oe_n)) begin
                $display("PASS");
                $display("  Outputs: dout=%h, oe_n=%b",
                         dout, oe_n);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h, oe_n=%b",
                         expected_dout, expected_oe_n);
                $display("  Got:      dout=%h, oe_n=%b",
                         dout, oe_n);
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
        $dumpvars(0,clk, regaddr_changed, rst_n, zxuno_addr, zxuno_regrd, dout, oe_n);
    end

endmodule
