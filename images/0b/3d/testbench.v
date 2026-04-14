`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [3:0] parallel_in;
    reg shift_left;
    wire [3:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .load(load),
        .parallel_in(parallel_in),
        .shift_left(shift_left),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            load = 1;
            parallel_in = 4'b0000;
            shift_left = 0;
            @(negedge clk);
            load = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Parallel Load 4'b1010", test_num);
            reset_dut();

            @(negedge clk);
            load = 1;
            parallel_in = 4'b1010;
            @(negedge clk);
            load = 0;

            #1;


            check_outputs(4'b1010);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Shift Left (0001 -> 0010)", test_num);
            reset_dut();


            @(negedge clk);
            load = 1;
            parallel_in = 4'b0001;
            @(negedge clk);
            load = 0;


            shift_left = 1;
            @(negedge clk);
            shift_left = 0;

            #1;


            check_outputs(4'b0010);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Shift Right (1000 -> 0100)", test_num);
            reset_dut();


            @(negedge clk);
            load = 1;
            parallel_in = 4'b1000;
            @(negedge clk);
            load = 0;


            shift_left = 0;
            @(negedge clk);

            #1;


            check_outputs(4'b0100);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Multi-bit Shift Left (0011 -> 1100)", test_num);
            reset_dut();


            @(negedge clk);
            load = 1;
            parallel_in = 4'b0011;
            @(negedge clk);
            load = 0;


            shift_left = 1;
            repeat(2) @(negedge clk);
            shift_left = 0;

            #1;


            check_outputs(4'b1100);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Multi-bit Shift Right (1100 -> 0011)", test_num);
            reset_dut();


            @(negedge clk);
            load = 1;
            parallel_in = 4'b1100;
            @(negedge clk);
            load = 0;


            shift_left = 0;
            repeat(2) @(negedge clk);

            #1;


            check_outputs(4'b0011);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Priority Check (Load should override Shift)", test_num);
            reset_dut();


            @(negedge clk);
            load = 1;
            parallel_in = 4'b1111;
            shift_left = 1;
            @(negedge clk);
            load = 0;
            shift_left = 0;


            #1;



            check_outputs(4'b1111);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Shift Left until empty", test_num);
            reset_dut();

            @(negedge clk);
            load = 1;
            parallel_in = 4'b1000;
            @(negedge clk);
            load = 0;

            shift_left = 1;
            repeat(4) @(negedge clk);
            shift_left = 0;

            #1;


            check_outputs(4'b0000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Shift Right until empty", test_num);
            reset_dut();

            @(negedge clk);
            load = 1;
            parallel_in = 4'b0001;
            @(negedge clk);
            load = 0;

            shift_left = 0;
            repeat(4) @(negedge clk);

            #1;


            check_outputs(4'b0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_register Testbench");
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
        input [3:0] expected_Q;
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
        $dumpvars(0,clk, load, parallel_in, shift_left, Q);
    end

endmodule
