`timescale 1ns/1ps

module reg16_sync_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clr;
    reg [15:0] d;
    reg load;
    wire [15:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    reg16_sync dut (
        .clk(clk),
        .clr(clr),
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
            @(negedge clk);
            clr = 1;
            load = 0;
            d = 16'h0000;
            @(negedge clk);
            clr = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Synchronous Clear Verification", test_num);
            reset_dut();

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic Load (0xAAAA)", test_num);
            reset_dut();
            @(negedge clk);
            load = 1;
            d = 16'hAAAA;
            @(negedge clk);
            load = 0;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Data Retention (Hold)", test_num);
            reset_dut();

            @(negedge clk);
            load = 1;
            d = 16'h5555;
            @(negedge clk);

            load = 0;
            d = 16'hFFFF;
            @(negedge clk);

            #1;


            check_outputs(16'h5555);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Clear Priority over Load", test_num);
            reset_dut();
            @(negedge clk);
            clr = 1;
            load = 1;
            d = 16'h1234;
            @(negedge clk);
            clr = 0;
            load = 0;

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Load Maximum Value (0xFFFF)", test_num);
            reset_dut();
            @(negedge clk);
            load = 1;
            d = 16'hFFFF;
            @(negedge clk);
            load = 0;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Consecutive Load Operations", test_num);
            reset_dut();
            @(negedge clk);
            load = 1;
            d = 16'h1111;
            @(negedge clk);
            d = 16'h2222;
            @(negedge clk);
            load = 0;
            #1;

            check_outputs(16'h2222);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("reg16_sync Testbench");
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
        $dumpvars(0,clk, clr, d, load, q);
    end

endmodule
