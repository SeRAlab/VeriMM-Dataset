`timescale 1ns/1ps

module binary_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg reset;
    wire [2:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_counter dut (
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
            @(posedge clk);
            reset <= 1;
            en <= 0;
            @(posedge clk);
            reset <= 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Initial Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Simple Increment", test_num);
            reset_dut();
            @(posedge clk);
            en <= 1;
            @(posedge clk);
            en <= 0;

            #1;


            check_outputs(3'b001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Enable Inactive Check", test_num);
            reset_dut();
            en <= 0;
            repeat(3) @(posedge clk);

            #1;


            check_outputs(3'b000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Multi-cycle Count to 5", test_num);
            reset_dut();
            en <= 1;
            repeat(5) @(posedge clk);
            en <= 0;

            #1;


            check_outputs(3'd5);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Rollover Check (0-7 then 0)", test_num);
            reset_dut();
            en <= 1;
            repeat(8) @(posedge clk);
            en <= 0;

            #1;


            check_outputs(3'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Intermittent Enable Check", test_num);
            reset_dut();
            en <= 1;
            repeat(2) @(posedge clk);
            en <= 0;
            repeat(2) @(posedge clk);
            en <= 1;
            @(posedge clk);
            en <= 0;
            #1;

            check_outputs(3'd3);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Mid-count Reset Check", test_num);
            reset_dut();
            en <= 1;
            repeat(4) @(posedge clk);
            reset <= 1;
            @(posedge clk);
            reset <= 0;
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %03d: Reset Priority Over Enable", test_num);
            reset_dut();
            en <= 1;
            repeat(2) @(posedge clk);
            reset <= 1;
            en <= 1;
            @(posedge clk);
            reset <= 0;
            #1;

            check_outputs(3'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_counter Testbench");
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
        input [2:0] expected_Q;
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
        $dumpvars(0,clk, en, reset, Q);
    end

endmodule
