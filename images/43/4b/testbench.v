`timescale 1ns/1ps

module vending_machine_tb;

    // Testbench signals (sequential circuit)
    reg areset;
    reg clk;
    reg coin_inserted;
    reg item_taken;
    wire dispense;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    vending_machine dut (
        .areset(areset),
        .clk(clk),
        .coin_inserted(coin_inserted),
        .item_taken(item_taken),
        .dispense(dispense)
    );

    // Clock generation (10ns period)
    initial begin
        areset = 0;
        forever #5 areset = ~areset;
    end

        task reset_dut;

        begin
            areset = 1;
            coin_inserted = 0;
            item_taken = 0;
            #12;
            areset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Idle state after reset", test_num);
            reset_dut();

            coin_inserted = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Idle to Dispense transition", test_num);
            reset_dut();

            coin_inserted = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Stay in Dispense state", test_num);
            reset_dut();

            coin_inserted = 1;
            @(posedge clk);

            #1 coin_inserted = 0;
            item_taken = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Dispense to Idle transition", test_num);
            reset_dut();

            coin_inserted = 1;
            @(posedge clk);

            #1 coin_inserted = 0;
            item_taken = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Coin insertion in Dispense state", test_num);
            reset_dut();

            coin_inserted = 1;
            @(posedge clk);

            #1 item_taken = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Async Reset during Dispense state", test_num);
            reset_dut();

            coin_inserted = 1;
            @(posedge clk);
            #1;

            areset = 1;
            #5;
            #1;

            check_outputs(1'b0);
            areset = 0;
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Multiple transaction sequence", test_num);
            reset_dut();


            coin_inserted = 1;
            @(posedge clk);
            #1 coin_inserted = 0;
            item_taken = 1;
            @(posedge clk);


            #1 item_taken = 0;
            coin_inserted = 1;
            @(posedge clk);

            #1 #1;
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
        $dumpvars(0,areset, clk, coin_inserted, item_taken, dispense);
    end

endmodule
