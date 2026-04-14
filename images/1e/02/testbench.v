`timescale 1ns/1ps

module dram_cell_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] din;
    reg we;
    wire [7:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dram_cell dut (
        .clk(clk),
        .din(din),
        .we(we),
        .dout(dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        @(negedge clk);
        we = 1;
        din = 8'h00;
        @(negedge clk);
        we = 0;
        din = 8'h00;
        @(negedge clk);
    end
    endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Test Case %0d: Write and Read Basic Pattern 0xAA", test_num);
        @(negedge clk);
        we = 1;
        din = 8'hAA;
        @(negedge clk);
        we = 0;
        din = 8'h00;
        repeat(2) @(negedge clk);
        #1;

        check_outputs(8'hAA);
    end
    endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Test Case %0d: Write and Read Pattern 0x55", test_num);
        @(negedge clk);
        we = 1;
        din = 8'h55;
        @(negedge clk);
        we = 0;
        din = 8'hFF;
        repeat(2) @(negedge clk);
        #1;

        check_outputs(8'h55);
    end
    endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Test Case %0d: Verify Write Enable (WE) Behavior", test_num);
        @(negedge clk);
        we = 0;
        din = 8'hFF;
        @(negedge clk);
        repeat(2) @(negedge clk);

        #1;


        check_outputs(8'h00);
    end
    endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Test Case %0d: Successive Overwrite", test_num);
        @(negedge clk);
        we = 1;
        din = 8'h12;
        @(negedge clk);
        din = 8'h34;
        @(negedge clk);
        we = 0;
        din = 8'h00;
        repeat(2) @(negedge clk);
        #1;

        check_outputs(8'h34);
    end
    endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Test Case %0d: Boundary Value 0xFF", test_num);
        @(negedge clk);
        we = 1;
        din = 8'hFF;
        @(negedge clk);
        we = 0;
        repeat(2) @(negedge clk);
        #1;

        check_outputs(8'hFF);
    end
    endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        $display("Test Case %0d: Data Retention after multiple cycles", test_num);
        @(negedge clk);
        we = 1;
        din = 8'hBE;
        @(negedge clk);
        we = 0;
        din = 8'hEF;
        repeat(10) @(negedge clk);
        #1;

        check_outputs(8'hBE);
    end
    endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dram_cell Testbench");
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
        $dumpvars(0,clk, din, we, dout);
    end

endmodule
