`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] din;
    reg poweron_rst_n;
    reg [7:0] zxuno_addr;
    reg zxuno_regrd;
    reg zxuno_regwr;
    wire [7:0] dout;
    wire oe_n;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .din(din),
        .poweron_rst_n(poweron_rst_n),
        .zxuno_addr(zxuno_addr),
        .zxuno_regrd(zxuno_regrd),
        .zxuno_regwr(zxuno_regwr),
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
            poweron_rst_n = 0;
            zxuno_addr = 8'h00;
            zxuno_regrd = 0;
            zxuno_regwr = 0;
            din = 8'h00;
            #20;
            @(posedge clk);
            poweron_rst_n = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Power-on Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Valid Write and Read Operation", test_num);
            reset_dut();


            @(posedge clk);
            zxuno_addr = SCRATCH;
            din = 8'hA5;
            zxuno_regwr = 1;
            @(posedge clk);
            zxuno_regwr = 0;


            zxuno_regrd = 1;
            #2;


            #1;



            check_outputs(8'hA5, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Write to Incorrect Address", test_num);
            reset_dut();


            @(posedge clk);
            zxuno_addr = SCRATCH + 8'h01;
            din = 8'h55;
            zxuno_regwr = 1;
            @(posedge clk);
            zxuno_regwr = 0;


            #1;



            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Read from Incorrect Address", test_num);
            reset_dut();


            @(posedge clk);
            zxuno_addr = SCRATCH;
            din = 8'hEE;
            zxuno_regwr = 1;
            @(posedge clk);
            zxuno_regwr = 0;


            zxuno_addr = SCRATCH + 8'h01;
            zxuno_regrd = 1;
            #2;


            #1;



            check_outputs(8'hEE, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Register Persistence and Read Disable", test_num);
            reset_dut();


            @(posedge clk);
            zxuno_addr = SCRATCH;
            din = 8'h33;
            zxuno_regwr = 1;
            @(posedge clk);
            zxuno_regwr = 0;


            zxuno_regrd = 0;
            #2;


            #1;



            check_outputs(8'h33, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset during operation", test_num);
            reset_dut();


            @(posedge clk);
            zxuno_addr = SCRATCH;
            din = 8'hFF;
            zxuno_regwr = 1;
            @(posedge clk);
            zxuno_regwr = 0;


            poweron_rst_n = 0;
            #10;


            #1;



            check_outputs(8'h00, 1'b1);
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
        $dumpvars(0,clk, din, poweron_rst_n, zxuno_addr, zxuno_regrd, zxuno_regwr, dout, oe_n);
    end

endmodule
