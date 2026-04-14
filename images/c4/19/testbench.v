`timescale 1ns/1ps

module mux_1to2_async_rst_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg din0;
    reg din1;
    reg rst;
    reg sel;
    wire dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux_1to2_async_rst dut (
        .clk(clk),
        .din0(din0),
        .din1(din1),
        .rst(rst),
        .sel(sel),
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
        din0 = 0;
        din1 = 0;
        sel = 0;
        #15;
        rst = 0;
        #10;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Test Case %0d: Select din0 (0)", test_num);
        sel = 0;
        din0 = 0;
        din1 = 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Test Case %0d: Select din0 (1)", test_num);
        sel = 0;
        din0 = 1;
        din1 = 0;
        @(posedge clk);
        #2;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Test Case %0d: Select din1 (0)", test_num);
        sel = 1;
        din0 = 1;
        din1 = 0;
        @(posedge clk);
        #2;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Test Case %0d: Select din1 (1)", test_num);
        sel = 1;
        din0 = 0;
        din1 = 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Test Case %0d: Asynchronous Reset Check", test_num);


        sel = 1;
        din1 = 1;
        @(posedge clk);
        #2;


        rst = 1;
        #1;
        #1;

        check_outputs(0);
        rst = 0;
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        $display("Test Case %0d: Toggle Select", test_num);
        din0 = 1;
        din1 = 0;
        sel = 0;
        @(posedge clk);
        #2;
        sel = 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux_1to2_async_rst Testbench");
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
        input expected_dout;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: dout=%b",
                         dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%b",
                         expected_dout);
                $display("  Got:      dout=%b",
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
        $dumpvars(0,clk, din0, din1, rst, sel, dout);
    end

endmodule
