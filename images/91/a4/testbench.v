`timescale 1ns/1ps

module register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data;
    reg load_enable;
    reg sreset;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    register dut (
        .clk(clk),
        .data(data),
        .load_enable(load_enable),
        .sreset(sreset),
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
            sreset = 1;
            load_enable = 0;
            data = 8'h00;
            @(posedge clk);
            #1;
            sreset = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test 001: Synchronous reset verification (Target: 85)");
            reset_dut();

            #1;


            check_outputs(8'd85);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test 002: Load enable high with data 0xAA");
            reset_dut();
            @(negedge clk);
            data = 8'hAA;
            load_enable = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test 003: Verify data retention when load_enable is low");
            reset_dut();

            @(negedge clk);
            data = 8'h55;
            load_enable = 1;
            @(posedge clk);
            #1;

            @(negedge clk);
            load_enable = 0;
            data = 8'hFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test 004: Synchronous reset priority over load_enable");
            reset_dut();
            @(negedge clk);
            data = 8'hCC;
            load_enable = 1;
            sreset = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd85);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test 005: Multiple consecutive loads");
            reset_dut();

            @(negedge clk);
            data = 8'h11;
            load_enable = 1;
            @(posedge clk);

            @(negedge clk);
            data = 8'h22;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h22);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test 006: Load 0x00 and verify");
            reset_dut();
            @(negedge clk);
            data = 8'h00;
            load_enable = 1;
            @(posedge clk);
            #1;
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
        $display("register Testbench");
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
        $dumpvars(0,clk, data, load_enable, sreset, q);
    end

endmodule
