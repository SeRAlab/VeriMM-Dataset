`timescale 1ns/1ps

module shift_register16bit_tc_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [15:0] load_val;
    reg rst;
    wire [15:0] q;
    wire tc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register16bit_tc dut (
        .clk(clk),
        .load(load),
        .load_val(load_val),
        .rst(rst),
        .q(q),
        .tc(tc)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            load = 0;
            load_val = 16'h0;
            @(posedge clk);
            #1;
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Check", test_num);
            reset_dut();
            #1;

            check_outputs(16'h0000, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Parallel Load (MSB=0)", test_num);
            reset_dut();
            @(negedge clk);
            load = 1;
            load_val = 16'h7FFF;
            @(posedge clk);
            #1;
            load = 0;
            #1;

            check_outputs(16'h7FFF, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Parallel Load (MSB=1)", test_num);
            reset_dut();
            @(negedge clk);
            load = 1;
            load_val = 16'h8000;
            @(posedge clk);
            #1;
            load = 0;
            #1;

            check_outputs(16'h8000, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift Left Operation (1 cycle)", test_num);
            reset_dut();
            @(negedge clk);
            load = 1;
            load_val = 16'h4000;
            @(posedge clk);
            #1;
            load = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h8000, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift until TC clears", test_num);
            reset_dut();
            @(negedge clk);
            load = 1;
            load_val = 16'h8001;
            @(posedge clk);
            #1;
            load = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0002, 1'b0);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Long Shift sequence", test_num);
            reset_dut();
            @(negedge clk);
            load = 1;
            load_val = 16'h0001;
            @(posedge clk);
            #1;
            load = 0;
            for(i = 0; i < 15; i = i + 1) begin
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(16'h8000, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load overrides shift", test_num);
            reset_dut();
            @(negedge clk);
            load = 1;
            load_val = 16'h1234;
            @(posedge clk);
            #1;
            load_val = 16'hABCD;
            load = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hABCD, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_register16bit_tc Testbench");
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
        input [15:0] expected_q;
        input expected_tc;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q) &&
                expected_tc === (expected_tc ^ tc ^ expected_tc)) begin
                $display("PASS");
                $display("  Outputs: q=%h, tc=%b",
                         q, tc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h, tc=%b",
                         expected_q, expected_tc);
                $display("  Got:      q=%h, tc=%b",
                         q, tc);
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
        $dumpvars(0,clk, load, load_val, rst, q, tc);
    end

endmodule
