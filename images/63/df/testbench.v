`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] adr;
    reg bit_in;
    reg clk;
    reg load_enable;
    reg rst;
    reg write_enable;
    wire [3:0] foo_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .adr(adr),
        .bit_in(bit_in),
        .clk(clk),
        .load_enable(load_enable),
        .rst(rst),
        .write_enable(write_enable),
        .foo_out(foo_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            load_enable = 0;
            write_enable = 0;
            adr = 2'b00;
            bit_in = 0;
            @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            @(posedge clk);
            write_enable = 1;
            adr = 2'b00;
            bit_in = 1;
            @(posedge clk);
            #1 write_enable = 0;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            @(posedge clk);
            write_enable = 1;
            adr = 2'b11;
            bit_in = 1;
            @(posedge clk);
            #1 write_enable = 0;
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            @(posedge clk);
            write_enable = 1; adr = 2'b01; bit_in = 1;

            @(posedge clk);
            write_enable = 1; adr = 2'b10; bit_in = 1;
            @(posedge clk);
            #1 write_enable = 0;
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            @(posedge clk);
            write_enable = 0;
            adr = 2'b00;
            bit_in = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();

            @(posedge clk);
            write_enable = 1; adr = 2'b00; bit_in = 1;

            @(posedge clk);
            write_enable = 1; adr = 2'b00; bit_in = 0;
            @(posedge clk);
            #1 write_enable = 0;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            @(posedge clk);

            rst = 1;
            write_enable = 1;
            adr = 2'b11;
            bit_in = 1;
            @(posedge clk);
            #1 rst = 0; write_enable = 0;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            @(posedge clk);
            write_enable = 1; bit_in = 1;
            adr = 2'b00; @(posedge clk);
            adr = 2'b01; @(posedge clk);
            adr = 2'b10; @(posedge clk);
            adr = 2'b11; @(posedge clk);
            #1 write_enable = 0;
            #1;

            check_outputs(4'b1111);
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
        testcase008();
        
        
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
        input [3:0] expected_foo_out;
        begin
            if (expected_foo_out === (expected_foo_out ^ foo_out ^ expected_foo_out)) begin
                $display("PASS");
                $display("  Outputs: foo_out=%h",
                         foo_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: foo_out=%h",
                         expected_foo_out);
                $display("  Got:      foo_out=%h",
                         foo_out);
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
        $dumpvars(0,adr, bit_in, clk, load_enable, rst, write_enable, foo_out);
    end

endmodule
