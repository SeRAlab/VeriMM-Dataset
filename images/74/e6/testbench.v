`timescale 1ns/1ps

module up_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    wire [3:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    up_counter dut (
        .clk(clk),
        .enable(enable),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            enable = 1;

            repeat (17) begin
                if (count === 4'b0000) break;
                @(posedge clk);
            end
            enable = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Basic Increment", test_num);
            enable = 1;
            repeat (5) @(posedge clk);
            enable = 0;
            @(negedge clk);
            #1;

            check_outputs(4'd5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Enable/Disable Toggle", test_num);
            enable = 1;
            repeat (3) @(posedge clk);
            enable = 0;
            repeat (3) @(posedge clk);
            enable = 1;
            repeat (2) @(posedge clk);
            enable = 0;
            @(negedge clk);
            #1;

            check_outputs(4'd5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Wrap Around Verification", test_num);
            enable = 1;
            repeat (16) @(posedge clk);
            enable = 0;
            @(negedge clk);
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Disable at Start", test_num);
            enable = 0;
            repeat (5) @(posedge clk);
            @(negedge clk);
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Maximum Value (15)", test_num);
            enable = 1;
            repeat (15) @(posedge clk);
            enable = 0;
            @(negedge clk);
            #1;

            check_outputs(4'd15);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("up_counter Testbench");
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
        input [3:0] expected_count;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count)) begin
                $display("PASS");
                $display("  Outputs: count=%h",
                         count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h",
                         expected_count);
                $display("  Got:      count=%h",
                         count);
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
        $dumpvars(0,clk, enable, count);
    end

endmodule
