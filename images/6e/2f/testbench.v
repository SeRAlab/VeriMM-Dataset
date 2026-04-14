`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clr;
    reg [7:0] din;
    reg re;
    reg rst_n;
    reg we;
    wire [7:0] dout;
    wire empty;
    wire full;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .clr(clr),
        .din(din),
        .re(re),
        .rst_n(rst_n),
        .we(we),
        .dout(dout),
        .empty(empty),
        .full(full)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            clr = 0;
            we = 0;
            re = 0;
            din = 0;
            #10;
            rst_n = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Initial Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(dout, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Single Write and Read", test_num);
            reset_dut();


            @(posedge clk);
            din = 8'h55;
            we = 1;
            @(posedge clk);
            we = 0;


            @(posedge clk);
            re = 1;
            @(posedge clk);
            re = 0;


            #1;



            check_outputs(8'h55, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Fill FIFO to Full", test_num);
            reset_dut();

            we = 1;
            for (i = 0; i < 8; i = i + 1) begin
                din = i + 1;
                @(posedge clk);
            end
            we = 0;


            #1;



            check_outputs(dout, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Synchronous Clear Check", test_num);
            reset_dut();


            we = 1;
            din = 8'hAA; @(posedge clk);
            din = 8'hBB; @(posedge clk);
            din = 8'hCC; @(posedge clk);
            din = 8'hDD; @(posedge clk);
            we = 0;


            @(posedge clk);
            clr = 1;
            @(posedge clk);
            clr = 0;
            @(posedge clk);


            #1;



            check_outputs(dout, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: FIFO Data Integrity", test_num);
            reset_dut();


            we = 1;
            din = 8'h11; @(posedge clk);
            din = 8'h22; @(posedge clk);
            we = 0;


            re = 1; @(posedge clk);

            @(posedge clk);
            re = 0;


            #1;



            check_outputs(8'h22, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Underflow Condition", test_num);
            reset_dut();


            @(posedge clk);
            re = 1;
            @(posedge clk);
            re = 0;


            #1;



            check_outputs(dout, 1'b1, 1'b0);
        end
        endtask

    task testcase007;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Read from Full FIFO", test_num);
            reset_dut();


            we = 1;
            for (i = 0; i < 8; i = i + 1) begin
                din = i + 10;
                @(posedge clk);
            end
            we = 0;


            @(posedge clk);
            re = 1;
            @(posedge clk);
            re = 0;


            #1;



            check_outputs(8'h0A, 1'b0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Simultaneous Write and Read", test_num);
            reset_dut();


            we = 1; din = 8'h99; @(posedge clk);
            we = 0;


            @(posedge clk);
            we = 1; din = 8'h88;
            re = 1;
            @(posedge clk);
            we = 0; re = 0;


            #1;



            check_outputs(8'h99, 1'b0, 1'b0);
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
        input [7:0] expected_dout;
        input expected_empty;
        input expected_full;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full)) begin
                $display("PASS");
                $display("  Outputs: dout=%h, empty=%b, full=%b",
                         dout, empty, full);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h, empty=%b, full=%b",
                         expected_dout, expected_empty, expected_full);
                $display("  Got:      dout=%h, empty=%b, full=%b",
                         dout, empty, full);
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
        $dumpvars(0,clk, clr, din, re, rst_n, we, dout, empty, full);
    end

endmodule
