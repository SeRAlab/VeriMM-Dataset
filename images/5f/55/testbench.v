`timescale 1ns/1ps

module sync_binary_counter_with_load_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] data;
    reg load;
    wire [4:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sync_binary_counter_with_load dut (
        .clk(clk),
        .data(data),
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
            load = 1;
            data = 5'b00000;
            @(posedge clk);
            #1;
            load = 0;
            data = 5'b00000;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Load Operation", test_num);
            reset_dut();

            data = 5'h0A;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;

            #1;


            check_outputs(5'h0A);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Counting logic (5 cycles)", test_num);
            reset_dut();

            load = 0;
            repeat (5) @(posedge clk);
            #1;

            #1;


            check_outputs(5'd5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Rollover behavior (31 -> 0)", test_num);
            reset_dut();


            data = 5'b11111;
            load = 1;
            @(posedge clk);
            #1;


            load = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(5'b00000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Load then Count sequence", test_num);
            reset_dut();


            data = 5'd15;
            load = 1;
            @(posedge clk);
            #1;


            load = 0;
            repeat (3) @(posedge clk);
            #1;

            #1;


            check_outputs(5'd18);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Load Priority check", test_num);
            reset_dut();


            load = 0;
            repeat (2) @(posedge clk);
            #1;


            data = 5'h1E;
            load = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(5'h1E);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Max Range counting (0 to 31)", test_num);
            reset_dut();

            load = 0;
            repeat (31) @(posedge clk);
            #1;

            #1;


            check_outputs(5'd31);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sync_binary_counter_with_load Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [4:0] expected_q;
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
        $dumpvars(0,clk, data, load, q);
    end

endmodule
