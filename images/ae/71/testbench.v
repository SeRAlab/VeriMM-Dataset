`timescale 1ns/1ps

module register_16bit_with_enable_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] d;
    reg en;
    reg rst;
    wire [15:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    register_16bit_with_enable dut (
        .clk(clk),
        .d(d),
        .en(en),
        .rst(rst),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        @(negedge clk);
        rst = 1;
        en = 0;
        d = 16'h0;
        @(negedge clk);
        rst = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Verify synchronous reset", test_num);
        reset_dut();

        #1;


        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Capture data with en=1", test_num);
        reset_dut();
        @(negedge clk);
        d = 16'hABCD;
        en = 1;
        @(negedge clk);

        #1;


        check_outputs(16'hABCD);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Verify enable gating (en=0)", test_num);
        reset_dut();


        @(negedge clk);
        d = 16'h5555;
        en = 1;
        @(negedge clk);


        d = 16'hAAAA;
        en = 0;
        @(negedge clk);


        #1;



        check_outputs(16'h5555);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Reset priority over enable", test_num);
        reset_dut();


        @(negedge clk);
        d = 16'hFFFF;
        en = 1;
        @(negedge clk);


        rst = 1;
        en = 1;
        d = 16'h1234;
        @(negedge clk);
        rst = 0;


        #1;



        check_outputs(16'h0000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Full scale value 0xFFFF", test_num);
        reset_dut();

        @(negedge clk);
        d = 16'hFFFF;
        en = 1;
        @(negedge clk);

        #1;


        check_outputs(16'hFFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: Multiple sequential writes", test_num);
        reset_dut();

        @(negedge clk);
        en = 1;
        d = 16'h1111;
        @(negedge clk);
        d = 16'h2222;
        @(negedge clk);
        d = 16'h3333;
        @(negedge clk);

        #1;


        check_outputs(16'h3333);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("register_16bit_with_enable Testbench");
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
        input [15:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, d, en, rst, q);
    end

endmodule
