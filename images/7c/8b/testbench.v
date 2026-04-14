`timescale 1ns/1ps

module up_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg load;
    reg [7:0] load_val;
    reg reset_n;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    up_counter dut (
        .clk(clk),
        .en(en),
        .load(load),
        .load_val(load_val),
        .reset_n(reset_n),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            en = 0;
            load = 0;
            load_val = 0;
            reset_n = 0;
            #15;
            reset_n = 1;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Asynchronous Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Synchronous Load Check", test_num);
            reset_dut();
            @(negedge clk);
            load = 1;
            load_val = 8'hA5;
            @(posedge clk);
            #1;
            load = 0;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Simple Increment Check", test_num);
            reset_dut();
            @(negedge clk);
            en = 1;
            repeat (5) @(posedge clk);
            #1;
            en = 0;
            #1;

            check_outputs(8'h05);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Counter Idle when Enable is Low", test_num);
            reset_dut();
            @(negedge clk);
            en = 0;
            repeat (3) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Load Priority Check", test_num);
            reset_dut();
            @(negedge clk);
            load = 1;
            en = 1;
            load_val = 8'h55;
            @(posedge clk);
            #1;
            load = 0;
            en = 0;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Rollover Check", test_num);
            reset_dut();
            @(negedge clk);
            load = 1;
            load_val = 8'hFF;
            @(posedge clk);
            #1;
            load = 0;
            en = 1;
            @(posedge clk);
            #1;
            en = 0;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Intermittent Enable Check", test_num);
            reset_dut();
            @(negedge clk);
            en = 1;
            @(posedge clk);
            @(negedge clk);
            en = 0;
            @(posedge clk);
            @(negedge clk);
            en = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h02);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Load and then Increment Check", test_num);
            reset_dut();
            @(negedge clk);
            load = 1;
            load_val = 8'h10;
            @(posedge clk);
            @(negedge clk);
            load = 0;
            en = 1;
            repeat (3) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h13);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("up_counter Testbench");
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
        $dumpvars(0,clk, en, load, load_val, reset_n, q);
    end

endmodule
