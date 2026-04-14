`timescale 1ns/1ps

module pipo_shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] d;
    reg load;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipo_shift_register dut (
        .clk(clk),
        .d(d),
        .load(load),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            load = 0;
            clk = 0;
            d = 8'h00;
            #15;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("\nTestcase %0d: Basic Parallel Load", test_num);
            d = 8'hA5;
            #10;
            load = 1;
            #10;
            load = 0;
            #10;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("\nTestcase %0d: Single Shift Left", test_num);
            d = 8'h55;
            #10;
            load = 1;
            #10;
            load = 0;
            #10;
            @(posedge clk);
            #5;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase003;

        integer i;
        begin
            reset_dut();
            test_num = 3;
            $display("\nTestcase %0d: Four Shifts Left", test_num);
            d = 8'h0F;
            #10;
            load = 1;
            #10;
            load = 0;
            #10;
            for (i = 0; i < 4; i = i + 1) begin
                @(posedge clk);
            end
            #5;
            #1;

            check_outputs(8'hF0);
        end
        endtask

    task testcase004;

        integer i;
        begin
            reset_dut();
            test_num = 4;
            $display("\nTestcase %0d: Full Clear via 8 Shifts", test_num);
            d = 8'hFF;
            #10;
            load = 1;
            #10;
            load = 0;
            #10;
            for (i = 0; i < 8; i = i + 1) begin
                @(posedge clk);
            end
            #5;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("\nTestcase %0d: Load Zero", test_num);
            d = 8'h00;
            #10;
            load = 1;
            #10;
            load = 0;
            #10;
            #1;

            check_outputs(8'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pipo_shift_register Testbench");
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
        input [7:0] expected_q;
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
        $dumpvars(0,clk, d, load, q);
    end

endmodule
