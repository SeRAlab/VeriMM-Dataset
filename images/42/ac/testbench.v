`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg coin;
    reg reset;
    reg [1:0] selection;
    wire dispense;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .coin(coin),
        .reset(reset),
        .selection(selection),
        .dispense(dispense)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        coin = 0;
        selection = 2'b00;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Selection 1, insert 1 coin", test_num);
        reset_dut();

        selection = 2'b01;
        @(posedge clk);

        coin = 1;
        @(posedge clk);
        coin = 0;
        @(posedge clk);

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Selection 2, insert 2 coins", test_num);
        reset_dut();

        selection = 2'b10;
        @(posedge clk);


        coin = 1;
        @(posedge clk);
        coin = 0;
        @(posedge clk);


        coin = 1;
        @(posedge clk);
        coin = 0;
        @(posedge clk);

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Selection 3, insert 3 coins", test_num);
        reset_dut();

        selection = 2'b11;
        @(posedge clk);


        repeat(3) begin
            coin = 1;
            @(posedge clk);
            coin = 0;
            @(posedge clk);
        end

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Selection 2, insert 1 coin (Insufficient)", test_num);
        reset_dut();

        selection = 2'b10;
        @(posedge clk);

        coin = 1;
        @(posedge clk);
        coin = 0;
        @(posedge clk);

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Reset after inserting partial payment", test_num);
        reset_dut();

        selection = 2'b11;
        @(posedge clk);

        coin = 1;
        @(posedge clk);
        coin = 0;
        @(posedge clk);


        reset = 1;
        @(posedge clk);
        reset = 0;
        @(posedge clk);


        coin = 1;
        @(posedge clk);
        coin = 0;
        @(posedge clk);

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Insert coins without selecting product", test_num);
        reset_dut();

        selection = 2'b00;
        @(posedge clk);

        coin = 1;
        @(posedge clk);
        coin = 0;
        @(posedge clk);

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Selection 3, insert 4 coins", test_num);
        reset_dut();

        selection = 2'b11;
        @(posedge clk);

        repeat(4) begin
            coin = 1;
            @(posedge clk);
            coin = 0;
            @(posedge clk);
        end



        #1;




        check_outputs(1'b1);
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
        input expected_dispense;
        begin
            if (expected_dispense === (expected_dispense ^ dispense ^ expected_dispense)) begin
                $display("PASS");
                $display("  Outputs: dispense=%b",
                         dispense);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dispense=%b",
                         expected_dispense);
                $display("  Got:      dispense=%b",
                         dispense);
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
        $dumpvars(0,clk, coin, reset, selection, dispense);
    end

endmodule
