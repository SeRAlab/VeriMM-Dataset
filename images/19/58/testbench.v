`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg load;
    reg shift_dir;
    wire [15:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .shift_dir(shift_dir),
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
        load = 1;
        data_in = 16'h0000;
        shift_dir = 0;
        @(negedge clk);
        load = 0;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Test %0d: Parallel Load Verification", test_num);
        @(negedge clk);
        load = 1;
        data_in = 16'hA5A5;
        @(negedge clk);
        load = 0;
        #1;

        check_outputs(16'hA5A5);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Test %0d: Shift Left (1 bit)", test_num);

        @(negedge clk);
        load = 1;
        data_in = 16'h0001;
        @(negedge clk);
        load = 0;
        shift_dir = 1;
        @(negedge clk);
        #1;

        check_outputs(16'h0002);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Test %0d: Shift Right (1 bit)", test_num);

        @(negedge clk);
        load = 1;
        data_in = 16'h8000;
        @(negedge clk);
        load = 0;
        shift_dir = 0;
        @(negedge clk);
        #1;

        check_outputs(14'h4000);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Test %0d: Multiple Shift Lefts (4 positions)", test_num);
        @(negedge clk);
        load = 1;
        data_in = 16'h000F;
        @(negedge clk);
        load = 0;
        shift_dir = 1;
        repeat(4) @(negedge clk);
        #1;

        check_outputs(16'h00F0);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Test %0d: Multiple Shift Rights (8 positions)", test_num);
        @(negedge clk);
        load = 1;
        data_in = 16'hFF00;
        @(negedge clk);
        load = 0;
        shift_dir = 0;
        repeat(8) @(negedge clk);
        #1;

        check_outputs(16'h00FF);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        $display("Test %0d: Load Priority Over Shift", test_num);
        @(negedge clk);
        load = 1;
        data_in = 16'h1234;
        shift_dir = 1;
        @(negedge clk);
        load = 0;
        #1;

        check_outputs(16'h1234);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        test_num = 7;
        $display("Test %0d: Shift Left Boundary Check", test_num);
        @(negedge clk);
        load = 1;
        data_in = 16'hFFFF;
        @(negedge clk);
        load = 0;
        shift_dir = 1;
        @(negedge clk);
        #1;

        check_outputs(16'hFFFE);
    end
        endtask

    task testcase008;

    begin
        reset_dut();
        test_num = 8;
        $display("Test %0d: Shift Right Boundary Check", test_num);
        @(negedge clk);
        load = 1;
        data_in = 16'hFFFF;
        @(negedge clk);
        load = 0;
        shift_dir = 0;
        @(negedge clk);
        #1;

        check_outputs(16'h7FFF);
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
        input [15:0] expected_q;
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
        $dumpvars(0,clk, data_in, load, shift_dir, q);
    end

endmodule
