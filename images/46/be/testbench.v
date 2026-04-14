`timescale 1ns/1ps

module counter9bit_par_load_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [8:0] d;
    reg en;
    reg load;
    reg rst;
    wire [8:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    counter9bit_par_load dut (
        .clk(clk),
        .d(d),
        .en(en),
        .load(load),
        .rst(rst),
        .q(q)
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
            d = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Initial Reset", test_num);
            reset_dut();
            #1;

            check_outputs(9'h000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Parallel Load 9'h0A5", test_num);
            reset_dut();
            d = 9'h0A5;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            #1;

            check_outputs(9'h0A5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Increment 5 times", test_num);
            reset_dut();
            en = 1;
            repeat (5) @(posedge clk);
            #1 en = 0;
            #1;

            check_outputs(9'h005);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Enable then Disable", test_num);
            reset_dut();
            en = 1;
            repeat (3) @(posedge clk);
            #1 en = 0;
            repeat (2) @(posedge clk);
            #1;

            check_outputs(9'h003);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Priority Check (Load and En high)", test_num);
            reset_dut();
            d = 9'h1FF;
            load = 1;
            en = 1;
            @(posedge clk);
            #1 load = 0; en = 0;
            #1;

            check_outputs(9'h1FF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Rollover (511 to 0)", test_num);
            reset_dut();
            d = 9'h1FF;
            load = 1;
            @(posedge clk);
            #1 load = 0; en = 1;
            @(posedge clk);
            #1 en = 0;
            #1;

            check_outputs(9'h000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Load 9'h100 then increment 4 times", test_num);
            reset_dut();
            d = 9'h100;
            load = 1;
            @(posedge clk);
            #1 load = 0; en = 1;
            repeat (4) @(posedge clk);
            #1 en = 0;
            #1;

            check_outputs(9'h104);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset during active counting", test_num);
            reset_dut();
            en = 1;
            repeat (10) @(posedge clk);
            #1 rst = 1;
            @(posedge clk);
            #1 rst = 0;
            #1;

            check_outputs(9'h000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("counter9bit_par_load Testbench");
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
        input [8:0] expected_q;
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
        $dumpvars(0,clk, d, en, load, rst, q);
    end

endmodule
