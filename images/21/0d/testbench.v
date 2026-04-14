`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] din;
    reg load;
    reg rst;
    reg shift;
    wire [15:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .din(din),
        .load(load),
        .rst(rst),
        .shift(shift),
        .dout(dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        load = 0;
        shift = 0;
        din = 16'h0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Synchronous Load", test_num);
        reset_dut();
        din = 16'hABCD;
        load = 1;
        @(posedge clk);
        #1 load = 0;
        #1;

        check_outputs(16'hABCD);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Left Shift (1 bit)", test_num);
        reset_dut();
        din = 16'h0001;
        load = 1;
        @(posedge clk);
        #1 load = 0;
        shift = 1;
        @(posedge clk);
        #1 shift = 0;
        #1;

        check_outputs(16'h0002);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Right Shift (1 bit)", test_num);
        reset_dut();
        din = 16'h8000;
        load = 1;
        @(posedge clk);
        #1 load = 0;
        shift = 0;
        @(posedge clk);
        #1 shift = 0;
        #1;

        check_outputs(16'h4000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Left Shift (4 bits)", test_num);
        reset_dut();
        din = 16'h000F;
        load = 1;
        @(posedge clk);
        #1 load = 0;
        shift = 1;
        repeat(4) @(posedge clk);
        #1 shift = 0;
        #1;

        check_outputs(16'h00F0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Right Shift (4 bits)", test_num);
        reset_dut();
        din = 16'hF000;
        load = 1;
        @(posedge clk);
        #1 load = 0;
        shift = 0;
        repeat(4) @(posedge clk);
        #1 shift = 0;
        #1;

        check_outputs(16'h0F00);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: Shift Left to Empty", test_num);
        reset_dut();
        din = 16'hFFFF;
        load = 1;
        @(posedge clk);
        #1 load = 0;
        shift = 1;
        repeat(16) @(posedge clk);
        #1 shift = 0;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %03d: Shift Right to Empty", test_num);
        reset_dut();
        din = 16'hFFFF;
        load = 1;
        @(posedge clk);
        #1 load = 0;
        shift = 0;
        repeat(16) @(posedge clk);
        #1 shift = 0;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %03d: Load Priority Over Shift", test_num);
        reset_dut();
        din = 16'hAAAA;
        load = 1;
        @(posedge clk);
        #1 load = 1; din = 16'h5555; shift = 1;
        @(posedge clk);
        #1 load = 0; shift = 0;
        #1;

        check_outputs(16'h5555);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_register Testbench");
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
        input [15:0] expected_dout;
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
        $dumpvars(0,clk, din, load, rst, shift, dout);
    end

endmodule
