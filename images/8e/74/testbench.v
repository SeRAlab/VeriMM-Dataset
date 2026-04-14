`timescale 1ns/1ps

module counter3bit_down_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    wire [2:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    counter3bit_down dut (
        .clk(clk),
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
            enable <= 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        reg [2:0] start_val;
        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %03d: Single decrement", test_num);
            start_val = q;
            enable <= 1;
            @(posedge clk);
            #1;
            enable <= 0;
            #1;

            check_outputs(start_val - 3'd1);
        end
        endtask

    task testcase002;

        reg [2:0] start_val;
        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %03d: Three consecutive decrements", test_num);
            start_val = q;
            enable <= 1;
            repeat(3) @(posedge clk);
            #1;
            enable <= 0;
            #1;

            check_outputs(start_val - 3'd3);
        end
        endtask

    task testcase003;

        reg [2:0] start_val;
        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %03d: Enable low (Hold value)", test_num);
            start_val = q;
            enable <= 0;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(start_val);
        end
        endtask

    task testcase004;

        reg [2:0] start_val;
        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %03d: Full cycle wrap-around (8 steps)", test_num);
            start_val = q;
            enable <= 1;
            repeat(8) @(posedge clk);
            #1;
            enable <= 0;
            #1;

            check_outputs(start_val);
        end
        endtask

    task testcase005;

        reg [2:0] start_val;
        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %03d: Intermittent enable toggle", test_num);
            start_val = q;

            enable <= 1; @(posedge clk); #1;
            enable <= 0; @(posedge clk); #1;
            enable <= 1; @(posedge clk); #1;
            enable <= 0;

            #1;


            check_outputs(start_val - 3'd2);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("counter3bit_down Testbench");
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
        input [2:0] expected_q;
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
        $dumpvars(0,clk, enable, q);
    end

endmodule
