`timescale 1ns/1ps

module shift_reg_8bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] din;
    reg load;
    reg rst_n;
    reg shift_en;
    wire [7:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_reg_8bit dut (
        .clk(clk),
        .din(din),
        .load(load),
        .rst_n(rst_n),
        .shift_en(shift_en),
        .dout(dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst_n = 0;
        din = 8'h00;
        load = 0;
        shift_en = 0;
        #12;
        rst_n = 1;
        #5;
    end
        endtask
    task testcase001;

    begin
        $display("Testcase001: Basic Reset Check");
        reset_dut();
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase002: Parallel Load Check");
        reset_dut();
        @(posedge clk);
        din = 8'hA5;
        load = 1;
        @(posedge clk);
        #1;
        load = 0;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase003: Single Shift Left Check");
        reset_dut();
        @(posedge clk);
        din = 8'h01;
        load = 1;
        @(posedge clk);
        #1;
        load = 0;
        shift_en = 1;
        @(posedge clk);
        #1;
        shift_en = 0;
        #1;

        check_outputs(8'h02);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase004: Multiple Shift Lefts Check");
        reset_dut();
        @(posedge clk);
        din = 8'h01;
        load = 1;
        @(posedge clk);
        #1;
        load = 0;
        shift_en = 1;
        repeat(4) @(posedge clk);
        #1;
        shift_en = 0;
        #1;

        check_outputs(8'h10);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase005: Load Priority (Load vs Shift) Check");
        reset_dut();
        @(posedge clk);
        din = 8'h55;
        load = 1;
        @(posedge clk);
        #1;

        din = 8'hFF;
        load = 1;
        shift_en = 1;
        @(posedge clk);
        #1;
        load = 0;
        shift_en = 0;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase006: Shifting out MSB Check");
        reset_dut();
        @(posedge clk);
        din = 8'h80;
        load = 1;
        @(posedge clk);
        #1;
        load = 0;
        shift_en = 1;
        @(posedge clk);
        #1;
        shift_en = 0;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase007;

    begin
        $display("Testcase007: Shift Enable Inactive Check");
        reset_dut();
        @(posedge clk);
        din = 8'h3C;
        load = 1;
        @(posedge clk);
        #1;
        load = 0;
        shift_en = 0;
        repeat(3) @(posedge clk);
        #1;
        #1;

        check_outputs(8'h3C);
    end
        endtask

    task testcase008;

    begin
        $display("Testcase008: Load Zero and Shift Check");
        reset_dut();
        @(posedge clk);
        din = 8'h00;
        load = 1;
        @(posedge clk);
        #1;
        load = 0;
        shift_en = 1;
        @(posedge clk);
        #1;
        shift_en = 0;
        #1;

        check_outputs(8'h00);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_reg_8bit Testbench");
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
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: dout=%h",
                         dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h",
                         expected_dout);
                $display("  Got:      dout=%h",
                         dout);
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
        $dumpvars(0,clk, din, load, rst_n, shift_en, dout);
    end

endmodule
