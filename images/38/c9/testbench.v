`timescale 1ns/1ps

module cache_replacement_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] address;
    reg clk;
    reg policy_select;
    reg reset;
    wire [3:0] replaced_block;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    cache_replacement dut (
        .address(address),
        .clk(clk),
        .policy_select(policy_select),
        .reset(reset),
        .replaced_block(replaced_block)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            address = 0;
            policy_select = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            policy_select = 0;
            @(posedge clk) address = 4'h1;
            @(posedge clk) address = 4'h2;
            @(posedge clk) address = 4'h3;
            @(posedge clk) address = 4'h4;
            @(posedge clk) address = 4'h5;
            #1;

            check_outputs(4'h1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            policy_select = 1;
            @(posedge clk) address = 4'h1;
            @(posedge clk) address = 4'h2;
            @(posedge clk) address = 4'h3;
            @(posedge clk) address = 4'h4;
            @(posedge clk) address = 4'h5;
            #1;

            check_outputs(4'h1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            policy_select = 1;
            @(posedge clk) address = 4'h1;
            @(posedge clk) address = 4'h2;
            @(posedge clk) address = 4'h3;
            @(posedge clk) address = 4'h4;
            @(posedge clk) address = 4'h1;
            @(posedge clk) address = 4'h5;
            #1;

            check_outputs(4'h2);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            policy_select = 0;
            @(posedge clk) address = 4'h1;
            @(posedge clk) address = 4'h2;
            @(posedge clk) address = 4'h3;
            @(posedge clk) address = 4'h4;
            @(posedge clk) address = 4'h1;
            @(posedge clk) address = 4'h5;
            #1;

            check_outputs(4'h1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            policy_select = 1;
            @(posedge clk) address = 4'h1;
            @(posedge clk) address = 4'h2;
            @(posedge clk) address = 4'h3;
            @(posedge clk) address = 4'h4;
            @(posedge clk) address = 4'h2;
            @(posedge clk) address = 4'h1;
            @(posedge clk) address = 4'h3;
            @(posedge clk) address = 4'h6;
            #1;

            check_outputs(4'h4);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            policy_select = 0;
            @(posedge clk) address = 4'h1;
            @(posedge clk) address = 4'h2;
            @(posedge clk) address = 4'h3;
            @(posedge clk) address = 4'h4;
            @(posedge clk) address = 4'h5;
            @(posedge clk) address = 4'h6;
            #1;

            check_outputs(4'h2);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("cache_replacement Testbench");
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
        input [3:0] expected_replaced_block;
        begin
            if (expected_replaced_block === (expected_replaced_block ^ replaced_block ^ expected_replaced_block)) begin
                $display("PASS");
                $display("  Outputs: replaced_block=%h",
                         replaced_block);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: replaced_block=%h",
                         expected_replaced_block);
                $display("  Got:      replaced_block=%h",
                         replaced_block);
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
        $dumpvars(0,address, clk, policy_select, reset, replaced_block);
    end

endmodule
