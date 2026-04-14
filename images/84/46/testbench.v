`timescale 1ns/1ps

module loadable_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [6:0] load_value;
    wire [6:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    loadable_counter dut (
        .clk(clk),
        .load(load),
        .load_value(load_value),
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
            load_value = 7'd0;
            @(posedge clk);
            #1;
            load = 0;
            load_value = 7'd0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Loading", test_num);
            reset_dut();
            @(negedge clk);
            load = 1;
            load_value = 7'h5A;
            @(posedge clk);
            #1;
            load = 0;
            #1;

            check_outputs(7'h5A);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Counting", test_num);
            reset_dut();
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(7'd5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load and Count", test_num);
            reset_dut();
            @(negedge clk);
            load = 1;
            load_value = 7'd20;
            @(posedge clk);
            #1;
            load = 0;
            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(7'd30);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Wrap Around", test_num);
            reset_dut();
            @(negedge clk);
            load = 1;
            load_value = 7'd126;
            @(posedge clk);
            #1;
            load = 0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(7'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load Priority", test_num);
            reset_dut();
            @(negedge clk);
            load = 1;
            load_value = 7'd10;
            @(posedge clk);
            #1;

            load_value = 7'd100;
            @(posedge clk);
            #1;
            load = 0;
            #1;

            check_outputs(7'd100);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Max Value Load", test_num);
            reset_dut();
            @(negedge clk);
            load = 1;
            load_value = 7'h7F;
            @(posedge clk);
            #1;
            load = 0;
            #1;

            check_outputs(7'h7F);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("loadable_counter Testbench");
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
        input [6:0] expected_q;
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
        $dumpvars(0,clk, load, load_value, q);
    end

endmodule
