`timescale 1ns/1ps

module up_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg load;
    reg [31:0] load_val;
    reg reset;
    wire [31:0] q;

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
        .reset(reset),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            en = 0;
            load = 0;
            load_val = 0;
            @(posedge clk);
            #1 reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Reset", test_num);
            reset_dut();

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Normal Incrementing (Enable=1)", test_num);
            reset_dut();
            en = 1;
            repeat(15) @(posedge clk);
            #1 en = 0;
            #1;

            check_outputs(32'd15);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Loading Value", test_num);
            reset_dut();
            load_val = 32'hA5A5A5A5;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            #1;

            check_outputs(32'hA5A5A5A5);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load then Increment", test_num);
            reset_dut();
            load_val = 32'h0000FFFF;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            en = 1;
            repeat(5) @(posedge clk);
            #1 en = 0;
            #1;

            check_outputs(32'h00010004);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enable Low (Counter Paused)", test_num);
            reset_dut();
            en = 1;
            repeat(5) @(posedge clk);
            #1 en = 0;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(32'd5);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Priority over Load and Enable", test_num);
            reset_dut();
            load_val = 32'hFFFFFFFF;
            load = 1;
            en = 1;
            reset = 1;
            @(posedge clk);
            #1 reset = 0;
            load = 0;
            en = 0;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Max Value Roll-over", test_num);
            reset_dut();
            load_val = 32'hFFFFFFFF;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            en = 1;
            @(posedge clk);
            #1 en = 0;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load Priority over Enable", test_num);
            reset_dut();
            load_val = 32'h12345678;
            load = 1;
            en = 1;
            @(posedge clk);
            #1 load = 0;
            en = 0;
            #1;

            check_outputs(32'h12345678);
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
        input [31:0] expected_q;
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
        $dumpvars(0,clk, en, load, load_val, reset, q);
    end

endmodule
