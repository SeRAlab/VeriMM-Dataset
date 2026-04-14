`timescale 1ns/1ps

module garage_door_tb;

    // Testbench signals (sequential circuit)
    reg areset;
    reg clk;
    reg close_button;
    reg open_button;
    wire door_open;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    garage_door dut (
        .areset(areset),
        .clk(clk),
        .close_button(close_button),
        .open_button(open_button),
        .door_open(door_open)
    );

    // Clock generation (10ns period)
    initial begin
        areset = 0;
        forever #5 areset = ~areset;
    end

        task reset_dut;

        begin
            areset = 1;
            open_button = 0;
            close_button = 0;
            #15;
            areset = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Verify initial reset state", test_num);
            reset_dut();
            #1;

            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Transition Closed -> Open using open_button", test_num);
            reset_dut();
            @(posedge clk);
            open_button = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Transition Open -> Closed using close_button", test_num);
            reset_dut();

            @(posedge clk);
            open_button = 1;
            @(posedge clk);

            open_button = 0;
            close_button = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Stay in Closed state (open_button = 0)", test_num);
            reset_dut();
            @(posedge clk);
            open_button = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Stay in Open state (close_button = 0)", test_num);
            reset_dut();
            @(posedge clk);
            open_button = 1;
            @(posedge clk);
            open_button = 0;
            close_button = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Asynchronous reset while in Open state", test_num);
            reset_dut();
            @(posedge clk);
            open_button = 1;
            @(posedge clk);
            #1;

            areset = 1;
            #2;
            #1;

            check_outputs(0);
            areset = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("garage_door Testbench");
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
        input expected_door_open;
        begin
            if (expected_door_open === (expected_door_open ^ door_open ^ expected_door_open)) begin
                $display("PASS");
                $display("  Outputs: door_open=%b",
                         door_open);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: door_open=%b",
                         expected_door_open);
                $display("  Got:      door_open=%b",
                         door_open);
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
        $dumpvars(0,areset, clk, close_button, open_button, door_open);
    end

endmodule
