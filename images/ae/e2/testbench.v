`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg ena_;
    reg high;
    reg [3:0] immed;
    reg [7:0] r0_dout;
    reg rst_;
    wire [7:0] r0_din;
    wire r0_we_;
    wire rdy_;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .ena_(ena_),
        .high(high),
        .immed(immed),
        .r0_dout(r0_dout),
        .rst_(rst_),
        .r0_din(r0_din),
        .r0_we_(r0_we_),
        .rdy_(rdy_)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_ = 0;
            ena_ = 1;
            high = 0;
            immed = 4'h0;
            r0_dout = 8'h00;
            #20;
            rst_ = 1;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Load High Nibble", test_num);
            reset_dut();

            @(posedge clk);
            ena_ = 0;
            high = 1;
            immed = 4'hA;
            r0_dout = 8'h55;
            #2;



            #1;




            check_outputs(8'hA5, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Load Low Nibble", test_num);
            reset_dut();

            @(posedge clk);
            ena_ = 0;
            high = 0;
            immed = 4'hB;
            r0_dout = 8'h34;
            #2;


            #1;



            check_outputs(8'h3B, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Module Disabled Status", test_num);
            reset_dut();

            @(posedge clk);
            ena_ = 1;
            high = 1;
            immed = 4'hF;
            r0_dout = 8'hAA;
            #2;





            if (r0_we_ === 1'b1 && rdy_ === 1'b1) begin
                $display("PASS");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Control signals not high when disabled");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Load High Nibble (Alternative Data)", test_num);
            reset_dut();

            @(posedge clk);
            ena_ = 0;
            high = 1;
            immed = 4'h1;
            r0_dout = 8'hEF;
            #2;


            #1;



            check_outputs(8'h1F, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Load Low Nibble (Alternative Data)", test_num);
            reset_dut();

            @(posedge clk);
            ena_ = 0;
            high = 0;
            immed = 4'hD;
            r0_dout = 8'h21;
            #2;


            #1;



            check_outputs(8'h2D, 1'b0, 1'b0);
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
        input [7:0] expected_r0_din;
        input expected_r0_we_;
        input expected_rdy_;
        begin
            if (expected_r0_din === (expected_r0_din ^ r0_din ^ expected_r0_din) &&
                expected_r0_we_ === (expected_r0_we_ ^ r0_we_ ^ expected_r0_we_) &&
                expected_rdy_ === (expected_rdy_ ^ rdy_ ^ expected_rdy_)) begin
                $display("PASS");
                $display("  Outputs: r0_din=%h, r0_we_=%b, rdy_=%b",
                         r0_din, r0_we_, rdy_);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: r0_din=%h, r0_we_=%b, rdy_=%b",
                         expected_r0_din, expected_r0_we_, expected_rdy_);
                $display("  Got:      r0_din=%h, r0_we_=%b, rdy_=%b",
                         r0_din, r0_we_, rdy_);
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
        $dumpvars(0,clk, ena_, high, immed, r0_dout, rst_, r0_din, r0_we_, rdy_);
    end

endmodule
