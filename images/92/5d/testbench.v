`timescale 1ns/1ps

module vending_machine_tb;

    // Testbench signals (sequential circuit)
    reg areset;
    reg clk;
    reg coin;
    reg stock;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    vending_machine dut (
        .areset(areset),
        .clk(clk),
        .coin(coin),
        .stock(stock),
        .state(state)
    );

    // Clock generation (10ns period)
    initial begin
        areset = 0;
        forever #5 areset = ~areset;
    end

        task reset_dut;

    begin
        areset = 1;
        coin = 0;
        stock = 1;
        #12;
        areset = 0;
        #5;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %0d: Reset Behavior", test_num);
        reset_dut();
        #1;

        check_outputs(IDLE);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %0d: IDLE to DISPENSE (Normal Operation)", test_num);
        reset_dut();
        @(posedge clk);
        coin = 1;
        stock = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(DISPENSE);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase %0d: IDLE to OUT_OF_STOCK", test_num);
        reset_dut();
        @(posedge clk);
        stock = 0;
        coin = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(OUT_OF_STOCK);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase %0d: DISPENSE to OUT_OF_STOCK", test_num);
        reset_dut();

        @(posedge clk);
        coin = 1;
        stock = 1;
        @(posedge clk);
        #1;

        stock = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(OUT_OF_STOCK);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTestcase %0d: IDLE Stay IDLE (No Coin)", test_num);
        reset_dut();
        @(posedge clk);
        coin = 0;
        stock = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(IDLE);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTestcase %0d: Recovery from OUT_OF_STOCK", test_num);
        reset_dut();

        stock = 0;
        @(posedge clk);
        #1;

        stock = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(IDLE);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("\nTestcase %0d: Coin inserted while OUT_OF_STOCK", test_num);
        reset_dut();
        stock = 0;
        @(posedge clk);
        #1;
        coin = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(OUT_OF_STOCK);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("vending_machine Testbench");
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
        input [1:0] expected_state;
        begin
            if (expected_state === (expected_state ^ state ^ expected_state)) begin
                $display("PASS");
                $display("  Outputs: state=%h",
                         state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: state=%h",
                         expected_state);
                $display("  Got:      state=%h",
                         state);
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
        $dumpvars(0,areset, clk, coin, stock, state);
    end

endmodule
