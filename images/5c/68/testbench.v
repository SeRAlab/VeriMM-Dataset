`timescale 1ns/1ps

module down_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [4:0] load_value;
    wire [4:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    down_counter dut (
        .clk(clk),
        .load(load),
        .load_value(load_value),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            load <= 1'b1;
            load_value <= 5'h00;
            @(posedge clk);
            load <= 1'b0;
            load_value <= 5'h00;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Loading value 5'h1F", test_num);
            reset_dut();
            @(posedge clk);
            load <= 1'b1;
            load_value <= 5'h1F;
            @(posedge clk);
            load <= 1'b0;
            #1;
            #1;

            check_outputs(5'h1F);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Single decrement from 5'h10 to 5'h0F", test_num);
            reset_dut();
            @(posedge clk);
            load <= 1'b1;
            load_value <= 5'h10;
            @(posedge clk);
            load <= 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'h0F);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Multiple decrements (5 steps from 5'h05)", test_num);
            reset_dut();
            @(posedge clk);
            load <= 1'b1;
            load_value <= 5'h05;
            @(posedge clk);
            load <= 1'b0;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(5'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Underflow (0 to 31)", test_num);
            reset_dut();
            @(posedge clk);
            load <= 1'b1;
            load_value <= 5'h00;
            @(posedge clk);
            load <= 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'h1F);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Synchronous load priority", test_num);
            reset_dut();
            @(posedge clk);
            load <= 1'b1;
            load_value <= 5'h10;
            @(posedge clk);
            load <= 1'b0;
            @(posedge clk);
            load <= 1'b1;
            load_value <= 5'h05;
            @(posedge clk);
            load <= 1'b0;
            #1;
            #1;

            check_outputs(5'h05);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("down_counter Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input [4:0] expected_count;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count)) begin
                $display("PASS");
                $display("  Outputs: count=%h",
                         count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h",
                         expected_count);
                $display("  Got:      count=%h",
                         count);
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
        $dumpvars(0,clk, load, load_value, count);
    end

endmodule
