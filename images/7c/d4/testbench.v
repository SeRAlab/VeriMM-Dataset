`timescale 1ns/1ps

module counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg sreset;
    wire [5:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    counter dut (
        .clk(clk),
        .enable(enable),
        .sreset(sreset),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            sreset = 1;
            enable = 0;
            @(posedge clk);
            #1 sreset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Reset", test_num);
            reset_dut();
            @(negedge clk);
            #1;

            check_outputs(6'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simple Increment", test_num);
            reset_dut();
            enable = 1;
            repeat(5) @(posedge clk);
            #1 enable = 0;
            @(negedge clk);
            #1;

            check_outputs(6'd5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enable Toggle", test_num);
            reset_dut();
            enable = 1;
            repeat(3) @(posedge clk);
            #1 enable = 0;
            repeat(2) @(posedge clk);
            @(negedge clk);
            #1;

            check_outputs(6'd3);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Max Value Check", test_num);
            reset_dut();
            enable = 1;
            repeat(63) @(posedge clk);
            #1 enable = 0;
            @(negedge clk);
            #1;

            check_outputs(6'd63);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overflow Wrap-around", test_num);
            reset_dut();
            enable = 1;
            repeat(64) @(posedge clk);
            #1 enable = 0;
            @(negedge clk);
            #1;

            check_outputs(6'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Synchronous Reset Priority", test_num);
            reset_dut();
            enable = 1;
            repeat(10) @(posedge clk);
            #1 sreset = 1;
            @(posedge clk);
            #1 sreset = 0;
            enable = 0;
            @(negedge clk);
            #1;

            check_outputs(6'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Increment to Middle Value", test_num);
            reset_dut();
            enable = 1;
            repeat(32) @(posedge clk);
            #1 enable = 0;
            @(negedge clk);
            #1;

            check_outputs(6'd32);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("counter Testbench");
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
        input [5:0] expected_q;
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
        $dumpvars(0,clk, enable, sreset, q);
    end

endmodule
