`timescale 1ns/1ps

module counter12bit_up_sync_clr_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clr;
    reg en;
    wire [11:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    counter12bit_up_sync_clr dut (
        .clk(clk),
        .clr(clr),
        .en(en),
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
            en = 0;
            @(negedge clk);
            clr = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Synchronous Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(12'h000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Single Increment Check", test_num);
            reset_dut();
            @(negedge clk);
            en = 1;
            @(negedge clk);
            en = 0;
            #1;

            check_outputs(12'h001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Multiple Increments Check (10 cycles)", test_num);
            reset_dut();
            @(negedge clk);
            en = 1;
            repeat (10) @(negedge clk);
            en = 0;
            #1;

            check_outputs(12'd10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Enable/Disable Hold Check", test_num);
            reset_dut();
            @(negedge clk);
            en = 1;
            repeat (5) @(negedge clk);
            en = 0;
            repeat (5) @(negedge clk);
            #1;

            check_outputs(12'd5);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Synchronous Clear Priority Check", test_num);
            reset_dut();
            @(negedge clk);
            en = 1;
            repeat (5) @(negedge clk);
            clr = 1;
            @(negedge clk);
            clr = 0;
            en = 0;
            #1;

            check_outputs(12'h000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Rollover Check (4095 to 0)", test_num);
            reset_dut();
            @(negedge clk);
            en = 1;
            repeat (4096) @(negedge clk);
            en = 0;
            #1;

            check_outputs(12'h000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Large Value Check (0xABC)", test_num);
            reset_dut();
            @(negedge clk);
            en = 1;
            repeat (2748) @(negedge clk);
            en = 0;
            #1;

            check_outputs(12'hABC);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("counter12bit_up_sync_clr Testbench");
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
        input [11:0] expected_q;
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
        $dumpvars(0,clk, clr, en, q);
    end

endmodule
