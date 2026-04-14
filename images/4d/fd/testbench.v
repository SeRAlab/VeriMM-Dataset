`timescale 1ns/1ps

module counter13bit_async_load_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [12:0] d;
    reg en;
    reg load;
    wire [12:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    counter13bit_async_load dut (
        .clk(clk),
        .d(d),
        .en(en),
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
            d = 13'h0000;
            en = 0;
            #10;
            load = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Asynchronous Load Check", test_num);
            reset_dut();

            d = 13'h1A5C;
            #2;
            load = 1;
            #1;
            #1;

            check_outputs(13'h1A5C);
            #2;
            load = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Synchronous Counting Check", test_num);
            reset_dut();

            en = 1;
            repeat(15) @(posedge clk);
            #2;
            #1;

            check_outputs(13'd15);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enable Control Check", test_num);
            reset_dut();


            d = 13'h0100;
            load = 1; #5; load = 0;

            en = 0;
            repeat(10) @(posedge clk);
            #2;
            #1;

            check_outputs(13'h0100);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 13-bit Counter Rollover Check", test_num);
            reset_dut();


            d = 13'h1FFF;
            load = 1; #5; load = 0;

            en = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(13'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Async Load Priority Check", test_num);
            reset_dut();

            en = 1;
            repeat(5) @(posedge clk);


            #3;
            d = 13'h0ABC;
            load = 1;
            #1;
            #1;

            check_outputs(13'h0ABC);

            load = 0;
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Large Count Check", test_num);
            reset_dut();

            en = 1;
            repeat(1000) @(posedge clk);
            #2;
            #1;

            check_outputs(13'd1000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("counter13bit_async_load Testbench");
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
        input [12:0] expected_q;
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
        $dumpvars(0,clk, d, en, load, q);
    end

endmodule
