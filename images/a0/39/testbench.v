`timescale 1ns/1ps

module register_16bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clr;
    reg [15:0] d;
    wire [15:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    register_16bit dut (
        .clk(clk),
        .clr(clr),
        .d(d),
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
        clr = 1;
        d = 16'h0;
        @(posedge clk);
        #1;
        clr = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Reset check", test_num);
        reset_dut();
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Loading 16'hAAAA", test_num);
        reset_dut();
        @(negedge clk);
        d = 16'hAAAA;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'hAAAA);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Loading 16'h5555 then Synchronous Clear", test_num);
        reset_dut();

        @(negedge clk);
        d = 16'h5555;
        @(posedge clk);

        @(negedge clk);
        clr = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Loading 16'hFFFF (All ones)", test_num);
        reset_dut();
        @(negedge clk);
        d = 16'hFFFF;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Writing 0 explicitly without clear", test_num);
        reset_dut();

        @(negedge clk);
        d = 16'h1234;
        @(posedge clk);

        @(negedge clk);
        d = 16'h0000;
        clr = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Sequential writes verification", test_num);
        reset_dut();
        @(negedge clk);
        d = 16'h1111;
        @(posedge clk);
        @(negedge clk);
        d = 16'h2222;
        @(posedge clk);
        @(negedge clk);
        d = 16'h3333;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'h3333);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Clear priority over Data Input", test_num);
        reset_dut();
        @(negedge clk);
        d = 16'hDEAD;
        clr = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("register_16bit Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        $dumpvars(0,clk, clr, d, q);
    end

endmodule
