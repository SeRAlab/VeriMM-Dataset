`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [4:0] parallel_in;
    reg reset_n;
    wire [4:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .load(load),
        .parallel_in(parallel_in),
        .reset_n(reset_n),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset_n = 0;
            load = 0;
            parallel_in = 5'b0;
            #15;
            reset_n = 1;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Asynchronous Reset", test_num);
            reset_dut();

            #1;


            check_outputs(5'b00000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Parallel Load", test_num);
            reset_dut();
            @(posedge clk);
            parallel_in = 5'b11011;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            #1;

            check_outputs(5'b11011);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Single Right Shift", test_num);
            reset_dut();

            @(posedge clk);
            parallel_in = 5'b10101;
            load = 1;
            @(posedge clk);

            load = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(5'b01010);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Multi-cycle Shift", test_num);
            reset_dut();

            @(posedge clk);
            parallel_in = 5'b10000;
            load = 1;
            @(posedge clk);
            load = 0;

            repeat(4) @(posedge clk);
            #1;

            #1;


            check_outputs(5'b00001);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Shift All Bits Out", test_num);
            reset_dut();
            @(posedge clk);
            parallel_in = 5'b11111;
            load = 1;
            @(posedge clk);
            load = 0;

            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Async Reset Priority", test_num);
            reset_dut();
            @(posedge clk);
            parallel_in = 5'b11111;
            load = 1;
            @(posedge clk);

            #3;
            reset_n = 0;
            #2;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: Continuous Loading", test_num);
            reset_dut();
            @(posedge clk);
            load = 1;
            parallel_in = 5'h0A;
            @(posedge clk);
            parallel_in = 5'h15;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'h15);
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
        input [4:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,clk, load, parallel_in, reset_n, out);
    end

endmodule
