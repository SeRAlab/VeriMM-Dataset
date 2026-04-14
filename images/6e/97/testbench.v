`timescale 1ns/1ps

module up_down_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg rst_n;
    reg up_down;
    wire [1:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    up_down_counter dut (
        .clk(clk),
        .enable(enable),
        .rst_n(rst_n),
        .up_down(up_down),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst_n = 0;
        enable = 0;
        up_down = 0;
        #10;
        rst_n = 1;
        #10;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Initial Reset Check", test_num);
        reset_dut();
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Counting Up twice", test_num);
        reset_dut();
        @(posedge clk);
        enable = 1;
        up_down = 1;
        @(posedge clk);
        @(posedge clk);
        #1;
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Counting Down twice", test_num);
        reset_dut();
        @(posedge clk);
        enable = 1;
        up_down = 0;
        @(posedge clk);
        @(posedge clk);
        #1;
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Enable signal check (Counter should not move)", test_num);
        reset_dut();
        @(posedge clk);
        enable = 0;
        up_down = 1;
        @(posedge clk);
        @(posedge clk);
        #1;
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Upward wrap-around (3 to 0)", test_num);
        reset_dut();
        @(posedge clk);
        enable = 1;
        up_down = 1;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        #1;
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Downward wrap-around (0 to 3)", test_num);
        reset_dut();
        @(posedge clk);
        enable = 1;
        up_down = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(2'b11);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Change direction mid-counting (Up 2, Down 1)", test_num);
        reset_dut();
        @(posedge clk);
        enable = 1;
        up_down = 1;
        @(posedge clk);
        @(posedge clk);
        up_down = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Async Reset Priority check", test_num);
        reset_dut();
        @(posedge clk);
        enable = 1;
        up_down = 1;
        @(posedge clk);
        @(posedge clk);
        #2;
        rst_n = 0;
        #2;
        #1;

        check_outputs(2'b00);
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
        input [1:0] expected_count;
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
        $dumpvars(0,clk, enable, rst_n, up_down, count);
    end

endmodule
