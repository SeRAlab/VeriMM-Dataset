`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] d;
    reg en;
    reg resetn;
    reg squashn;
    wire [31:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .en(en),
        .resetn(resetn),
        .squashn(squashn),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            resetn = 0;
            squashn = 1;
            en = 0;
            d = 32'h0;
            @(posedge clk);
            #1 resetn = 1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Reset", test_num);
            reset_dut();
            @(posedge clk);
            #1 #1;
 check_outputs(32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Normal Write (Masking Check)", test_num);
            reset_dut();
            d = 32'hFFFFFFFF;
            en = 1;
            squashn = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(32'h0000001F);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enable Disabled", test_num);
            reset_dut();

            d = 32'h0000000A;
            en = 1;
            @(posedge clk);

            #1;
            en = 0;
            d = 32'h0000001F;
            @(posedge clk);
            #1 #1;
 check_outputs(32'h0000000A);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Squash Signal Active", test_num);
            reset_dut();

            d = 32'h00000015;
            en = 1;
            squashn = 1;
            @(posedge clk);
            #1;

            squashn = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(32'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Specific Bit Patterns", test_num);
            reset_dut();
            d = 32'hAAAA_AA12;
            en = 1;
            squashn = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(32'h00000012);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Priority", test_num);
            reset_dut();
            resetn = 0;
            en = 1;
            d = 32'hFFFFFFFF;
            @(posedge clk);
            #1 #1;
 check_outputs(32'h0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Squash Priority", test_num);
            reset_dut();
            squashn = 0;
            en = 1;
            d = 32'hFFFFFFFF;
            @(posedge clk);
            #1 #1;
 check_outputs(32'h0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sequence of Writes", test_num);
            reset_dut();
            en = 1;
            squashn = 1;
            d = 32'h12345601;
            @(posedge clk);
            #1;
            d = 32'h87654302;
            @(posedge clk);
            #1;
            d = 32'hABCDEF03;
            @(posedge clk);
            #1 #1;
 check_outputs(32'h00000003);
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
        input [31:0] expected_q;
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
        $dumpvars(0,clk, d, en, resetn, squashn, q);
    end

endmodule
