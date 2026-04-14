`timescale 1ns/1ps

module register_with_enable_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] d;
    reg enable;
    wire [3:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    register_with_enable dut (
        .clk(clk),
        .d(d),
        .enable(enable),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            d = 4'b0000;
            enable = 1'b1;
            @(posedge clk);
            #1;
            enable = 1'b0;
            d = 4'b0000;
            $display("DUT Reset: q is now %h", q);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Basic Load (Writing 4'hA)", test_num);
            reset_dut();

            d = 4'hA;
            enable = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Enable Low (Holding 4'h5 while trying to write 4'hF)", test_num);
            reset_dut();


            d = 4'h5;
            enable = 1;
            @(posedge clk);
            #1;


            d = 4'hF;
            enable = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: All Bits High", test_num);
            reset_dut();

            d = 4'hF;
            enable = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'hF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Consecutive Writes (Sequence 1->2->4->8)", test_num);
            reset_dut();

            enable = 1;
            d = 4'h1; @(posedge clk); #1;
            d = 4'h2; @(posedge clk); #1;
            d = 4'h4; @(posedge clk); #1;
            d = 4'h8; @(posedge clk); #1;

            #1;


            check_outputs(4'h8);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Intermittent Enable (Skipping values in a sequence)", test_num);
            reset_dut();

            d = 4'hB; enable = 1; @(posedge clk); #1;
            d = 4'hC; enable = 0; @(posedge clk); #1;
            d = 4'hD; enable = 1; @(posedge clk); #1;
            d = 4'hE; enable = 0; @(posedge clk); #1;

            #1;


            check_outputs(4'hD);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("register_with_enable Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input [3:0] expected_q;
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
        $dumpvars(0,clk, d, enable, q);
    end

endmodule
