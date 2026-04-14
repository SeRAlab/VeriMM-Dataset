`timescale 1ns/1ps

module register_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] D;
    reg clk;
    reg en;
    reg reset;
    wire [7:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    register dut (
        .D(D),
        .clk(clk),
        .en(en),
        .reset(reset),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        en = 0;
        D = 8'h00;
        #15;
        reset = 0;
        #10;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Power-on Reset Check", test_num);
        reset_dut();

        #1;


        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Load Data 8'hA5 with en=1", test_num);
        reset_dut();
        @(negedge clk);
        en = 1;
        D = 8'hA5;
        @(posedge clk);
        #2;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Hold Data with en=0", test_num);
        reset_dut();

        @(negedge clk);
        en = 1;
        D = 8'h55;
        @(posedge clk);
        #2;

        @(negedge clk);
        en = 0;
        D = 8'hFF;
        @(posedge clk);
        #2;

        #1;


        check_outputs(8'h55);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Asynchronous Reset Priority over Enable", test_num);
        reset_dut();

        @(negedge clk);
        en = 1;
        D = 8'hAA;
        @(posedge clk);
        #2;

        #3;
        reset = 1;
        #2;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Sequential Data Loading", test_num);
        reset_dut();
        @(negedge clk);
        en = 1;
        D = 8'h01;
        @(posedge clk);
        @(negedge clk);
        D = 8'h02;
        @(posedge clk);
        @(negedge clk);
        D = 8'h04;
        @(posedge clk);
        @(negedge clk);
        D = 8'h08;
        @(posedge clk);
        #2;
        #1;

        check_outputs(8'h08);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Toggle All Bits (00 -> FF)", test_num);
        reset_dut();
        @(negedge clk);
        en = 1;
        D = 8'hFF;
        @(posedge clk);
        #2;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("register Testbench");
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
        input [7:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,D, clk, en, reset, Q);
    end

endmodule
