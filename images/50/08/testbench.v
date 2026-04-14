`timescale 1ns/1ps

module sync_up_counter_load_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load_en;
    reg [9:0] load_val;
    wire [9:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sync_up_counter_load dut (
        .clk(clk),
        .load_en(load_en),
        .load_val(load_val),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            load_en <= 1;
            load_val <= 10'd0;
            @(posedge clk);
            load_en <= 0;
            load_val <= 10'd0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Synchronous Load", test_num);
            reset_dut();

            load_en <= 1;
            load_val <= 10'h1AA;
            @(posedge clk);
            #1;
            load_en <= 0;

            #1;


            check_outputs(10'h1AA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Counting from Zero", test_num);
            reset_dut();

            repeat(10) @(posedge clk);
            #1;

            #1;


            check_outputs(10'd10);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load then Count", test_num);
            reset_dut();

            load_en <= 1;
            load_val <= 10'd500;
            @(posedge clk);
            load_en <= 0;

            repeat(5) @(posedge clk);
            #1;

            #1;


            check_outputs(10'd505);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Counter Roll-over", test_num);
            reset_dut();

            load_en <= 1;
            load_val <= 10'd1023;
            @(posedge clk);
            load_en <= 0;

            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(10'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load Enable Priority", test_num);
            reset_dut();

            load_en <= 1;
            load_val <= 10'd100;
            repeat(10) @(posedge clk);
            #1;

            #1;


            check_outputs(10'd100);
            load_en <= 0;
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: High Value Single Step", test_num);
            reset_dut();

            load_en <= 1;
            load_val <= 10'h3FE;
            @(posedge clk);
            load_en <= 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(10'h3FF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sync_up_counter_load Testbench");
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
        input [9:0] expected_q;
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
        $dumpvars(0,clk, load_en, load_val, q);
    end

endmodule
