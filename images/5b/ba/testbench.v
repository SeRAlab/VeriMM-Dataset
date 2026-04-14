`timescale 1ns/1ps

module up_down_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg rst;
    reg up_down;
    wire [2:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    up_down_counter dut (
        .clk(clk),
        .enable(enable),
        .rst(rst),
        .up_down(up_down),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            rst = 1;
            enable = 0;
            up_down = 0;
            @(negedge clk);
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Up counting full cycle", test_num);
            reset_dut();
            @(negedge clk);
            enable = 1;
            up_down = 1;
            repeat (8) @(negedge clk);
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Down counting underflow", test_num);
            reset_dut();
            @(negedge clk);
            enable = 1;
            up_down = 0;
            @(negedge clk);
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Enable signal low", test_num);
            reset_dut();
            @(negedge clk);
            enable = 0;
            up_down = 1;
            repeat (5) @(negedge clk);
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Synchronous Reset during operation", test_num);
            reset_dut();
            @(negedge clk);
            enable = 1;
            up_down = 1;
            repeat (3) @(negedge clk);
            rst = 1;
            @(negedge clk);
            rst = 0;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Count up to 5", test_num);
            reset_dut();
            @(negedge clk);
            enable = 1;
            up_down = 1;
            repeat (5) @(negedge clk);
            #1;

            check_outputs(3'b101);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Change direction mid-way", test_num);
            reset_dut();
            @(negedge clk);
            enable = 1;
            up_down = 1;
            repeat (4) @(negedge clk);
            up_down = 0;
            repeat (2) @(negedge clk);
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Disable counter mid-way", test_num);
            reset_dut();
            @(negedge clk);
            enable = 1;
            up_down = 1;
            repeat (2) @(negedge clk);
            enable = 0;
            repeat (3) @(negedge clk);
            #1;

            check_outputs(3'b010);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("up_down_counter Testbench");
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
        input [2:0] expected_q;
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
        $dumpvars(0,clk, enable, rst, up_down, q);
    end

endmodule
