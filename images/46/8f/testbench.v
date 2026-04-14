`timescale 1ns/1ps

module register_8bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] d;
    reg load;
    reg reset;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    register_8bit dut (
        .clk(clk),
        .d(d),
        .load(load),
        .reset(reset),
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
        reset = 1;
        load = 0;
        d = 8'h00;
        @(negedge clk);
        reset = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Verifying synchronous reset resets q to 0", test_num);
        reset_dut();


        #1;



        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Loading 8'hAA into register", test_num);
        reset_dut();
        @(negedge clk);
        d = 8'hAA;
        load = 1;
        @(negedge clk);
        load = 0;
        #1;

        check_outputs(8'hAA);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Verifying data retention when load is low", test_num);
        reset_dut();

        @(negedge clk);
        d = 8'h55;
        load = 1;
        @(negedge clk);

        d = 8'hFF;
        load = 0;
        @(negedge clk);
        #1;

        check_outputs(8'h55);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Verifying Reset has priority over Load", test_num);
        reset_dut();
        @(negedge clk);
        d = 8'hA5;
        load = 1;
        reset = 1;
        @(negedge clk);
        reset = 0;
        load = 0;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Loading 8'hFF", test_num);
        reset_dut();
        @(negedge clk);
        d = 8'hFF;
        load = 1;
        @(negedge clk);
        load = 0;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Multiple consecutive loads", test_num);
        reset_dut();
        @(negedge clk);
        d = 8'h11;
        load = 1;
        @(negedge clk);
        d = 8'h22;
        load = 1;
        @(negedge clk);
        d = 8'h33;
        load = 1;
        @(negedge clk);
        load = 0;
        #1;

        check_outputs(8'h33);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Explicitly loading 8'h00", test_num);
        reset_dut();
        @(negedge clk);
        d = 8'hCC;
        load = 1;
        @(negedge clk);
        d = 8'h00;
        load = 1;
        @(negedge clk);
        load = 0;
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
        $display("register_8bit Testbench");
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
        input [7:0] expected_q;
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
        $dumpvars(0,clk, d, load, reset, q);
    end

endmodule
