`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] din;
    reg rst;
    wire [1:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .din(din),
        .rst(rst),
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
        din = 2'b00;
        #15;
        rst = 0;
        #5;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Verify asynchronous reset to 00", test_num);
        reset_dut();
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Shift left once with din[0]=1", test_num);
        reset_dut();
        @(posedge clk);
        din = 2'b01;
        @(posedge clk);
        #1;
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Shift left twice with din[0]=1", test_num);
        reset_dut();
        @(posedge clk);
        din = 2'b01;
        @(posedge clk);
        din = 2'b01;
        @(posedge clk);
        #1;
        #1;

        check_outputs(2'b11);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Shift left '1' then '0'", test_num);
        reset_dut();
        @(posedge clk);
        din = 2'b01;
        @(posedge clk);
        din = 2'b00;
        @(posedge clk);
        #1;
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Verify reset is asynchronous (occurs mid-cycle)", test_num);
        reset_dut();
        @(posedge clk);
        din = 2'b01;
        @(posedge clk);
        din = 2'b01;
        @(posedge clk);
        #2;
        rst = 1;
        #1;
        #1;

        check_outputs(2'b00);
        rst = 0;
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Shift 3 bits (1-1-0) into 2-bit register", test_num);
        reset_dut();
        @(posedge clk);
        din = 2'b01;
        @(posedge clk);
        din = 2'b01;
        @(posedge clk);
        din = 2'b00;
        @(posedge clk);
        #1;
        #1;

        check_outputs(2'b10);
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
        input [1:0] expected_dout;
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
        $dumpvars(0,clk, din, rst, dout);
    end

endmodule
