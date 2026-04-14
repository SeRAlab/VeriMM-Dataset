`timescale 1ns/1ps

module robot_navigation_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] command;
    reg reset;
    wire [1:0] direction;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    robot_navigation dut (
        .clk(clk),
        .command(command),
        .reset(reset),
        .direction(direction)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            command = 2'b00;
            @(posedge clk);
            #1;
            reset = 0;

        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Initial Reset to North", test_num);
            reset_dut();

            #1;


            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Transition North to East", test_num);
            reset_dut();
            command = 2'b01;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Transition North to South", test_num);
            reset_dut();
            command = 2'b10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Transition North to West", test_num);
            reset_dut();
            command = 2'b11;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multi-step sequence N->E->S->W", test_num);
            reset_dut();

            command = 2'b01;
            @(posedge clk); #1;

            command = 2'b10;
            @(posedge clk); #1;

            command = 2'b11;
            @(posedge clk); #1;

            #1;


            check_outputs(2'b11);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: West to North", test_num);
            reset_dut();

            command = 2'b11;
            @(posedge clk); #1;

            command = 2'b00;
            @(posedge clk); #1;

            #1;


            check_outputs(2'b00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: East and West Toggle", test_num);
            reset_dut();

            command = 2'b01;
            @(posedge clk); #1;
            command = 2'b11;
            @(posedge clk); #1;
            command = 2'b01;
            @(posedge clk); #1;

            #1;


            check_outputs(2'b01);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Hold South direction", test_num);
            reset_dut();

            command = 2'b10;
            @(posedge clk); #1;
            @(posedge clk); #1;
            @(posedge clk); #1;

            #1;


            check_outputs(2'b10);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("robot_navigation Testbench");
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
        input [1:0] expected_direction;
        begin
            if (expected_direction === (expected_direction ^ direction ^ expected_direction)) begin
                $display("PASS");
                $display("  Outputs: direction=%h",
                         direction);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: direction=%h",
                         expected_direction);
                $display("  Got:      direction=%h",
                         direction);
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
        $dumpvars(0,clk, command, reset, direction);
    end

endmodule
