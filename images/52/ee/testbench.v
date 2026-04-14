`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] amount;
    reg clk;
    reg [63:0] data;
    reg ena;
    reg load;
    wire [63:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .amount(amount),
        .clk(clk),
        .data(data),
        .ena(ena),
        .load(load),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            load <= 1;
            data <= 64'b0;
            ena <= 0;
            amount <= 2'b00;
            @(posedge clk);
            load <= 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Synchronous Load", test_num);
            reset_dut();
            @(posedge clk);
            load <= 1;
            data <= 64'hFEDCBA9876543210;
            @(posedge clk);
            load <= 0;
            #1;

            check_outputs(64'hFEDCBA9876543210);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift Left 1 (Circular)", test_num);
            reset_dut();
            load <= 1;
            data <= 64'h8000000000000001;
            @(posedge clk);
            load <= 0;
            ena <= 1;
            amount <= 2'b00;
            @(posedge clk);
            ena <= 0;



            #1;




            check_outputs(64'h0000000000000003);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift Left 4 (Circular)", test_num);
            reset_dut();
            load <= 1;
            data <= 64'hF000000000000000;
            @(posedge clk);
            load <= 0;
            ena <= 1;
            amount <= 2'b01;
            @(posedge clk);
            ena <= 0;

            #1;


            check_outputs(64'h000000000000000F);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift Right 1 (Circular)", test_num);
            reset_dut();
            load <= 1;
            data <= 64'h0000000000000001;
            @(posedge clk);
            load <= 0;
            ena <= 1;
            amount <= 2'b10;
            @(posedge clk);
            ena <= 0;

            #1;


            check_outputs(64'h8000000000000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift Right 4 (Circular)", test_num);
            reset_dut();
            load <= 1;
            data <= 64'h000000000000000F;
            @(posedge clk);
            load <= 0;
            ena <= 1;
            amount <= 2'b11;
            @(posedge clk);
            ena <= 0;

            #1;


            check_outputs(64'hF000000000000000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enable Low Hold", test_num);
            reset_dut();
            load <= 1;
            data <= 64'h5555AAAA5555AAAA;
            @(posedge clk);
            load <= 0;
            ena <= 0;
            amount <= 2'b00;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(64'h5555AAAA5555AAAA);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load Priority Over Enable", test_num);
            reset_dut();
            load <= 1;
            data <= 64'h1111222233334444;
            ena <= 1;
            amount <= 2'b01;
            @(posedge clk);
            load <= 0;
            ena <= 0;

            #1;


            check_outputs(64'h1111222233334444);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Consecutive Shifts", test_num);
            reset_dut();
            load <= 1;
            data <= 64'h1;
            @(posedge clk);
            load <= 0;
            ena <= 1;
            amount <= 2'b00;
            @(posedge clk);
            amount <= 2'b01;
            @(posedge clk);
            ena <= 0;
            #1;

            check_outputs(64'h0000000000000020);
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
        input [63:0] expected_q;
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
        $dumpvars(0,amount, clk, data, ena, load, q);
    end

endmodule
