`timescale 1ns/1ps

module binary_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg load;
    reg rst;
    wire [3:0] q;
    wire [3:0] q_bar;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_counter dut (
        .clk(clk),
        .en(en),
        .load(load),
        .rst(rst),
        .q(q),
        .q_bar(q_bar)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            en = 0;
            load = 0;
            d = 4'h0;
            @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase001: Synchronous Reset Check");
            reset_dut();
            #1;

            check_outputs(4'b0000, 4'b1111);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase002: Single Increment");
            reset_dut();
            en = 1;
            @(posedge clk);
            #1 en = 0;
            #1;

            check_outputs(4'b0001, 4'b1110);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase003: Multiple Increments (Count to 5)");
            reset_dut();
            en = 1;
            repeat (5) @(posedge clk);
            #1 en = 0;
            #1;

            check_outputs(4'b0101, 4'b1010);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase004: Load Value 4'hA");
            reset_dut();
            d = 4'hA;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            #1;

            check_outputs(4'b1010, 4'b0101);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase005: Load 4'h5 then increment 2 times");
            reset_dut();
            d = 4'h5;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            en = 1;
            repeat (2) @(posedge clk);
            #1 en = 0;
            #1;

            check_outputs(4'b0111, 4'b1000);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase006: Wrap-around logic");
            reset_dut();
            d = 4'hF;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            en = 1;
            @(posedge clk);
            #1 en = 0;
            #1;

            check_outputs(4'b0000, 4'b1111);
        end
        endtask

    task testcase007;

        begin
            $display("Running Testcase007: Disable count (Enable=0)");
            reset_dut();
            en = 0;
            repeat (3) @(posedge clk);
            #1;

            check_outputs(4'b0000, 4'b1111);
        end
        endtask

    task testcase008;

        begin
            $display("Running Testcase008: Load priority over Enable");
            reset_dut();
            d = 4'hC;
            load = 1;
            en = 1;
            @(posedge clk);
            #1 load = 0; en = 0;
            #1;

            check_outputs(4'b1100, 4'b0011);
        end
        endtask

    task testcase009;

        begin
            $display("Running Testcase009: Reset priority over Load/Enable");
            reset_dut();

            en = 1;
            repeat (2) @(posedge clk);

            #1 rst = 1; load = 1; d = 4'hF;
            @(posedge clk);
            #1 rst = 0; load = 0; en = 0;
            #1;

            check_outputs(4'b0000, 4'b1111);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_counter Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        
        
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
        input [3:0] expected_q;
        input [3:0] expected_q_bar;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q) &&
                expected_q_bar === (expected_q_bar ^ q_bar ^ expected_q_bar)) begin
                $display("PASS");
                $display("  Outputs: q=%h, q_bar=%h",
                         q, q_bar);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h, q_bar=%h",
                         expected_q, expected_q_bar);
                $display("  Got:      q=%h, q_bar=%h",
                         q, q_bar);
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
        $dumpvars(0,clk, en, load, rst, q, q_bar);
    end

endmodule
