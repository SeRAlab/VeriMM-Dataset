`timescale 1ns/1ps

module ledctr_tb;

    // Testbench signals (sequential circuit)
    reg ce;
    reg clk;
    wire ledalive;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ledctr dut (
        .ce(ce),
        .clk(clk),
        .ledalive(ledalive)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            ce = 0;
            repeat(10) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verify ledalive stays low when ce=0", test_num);
            reset_dut();
            ce = 0;

            repeat(1100) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verify ledalive goes high when ce=1", test_num);
            reset_dut();
            ce = 1;
            i = 0;

            while (ledalive === 1 && i < 2048) begin
                @(posedge clk);
                #1;
                i = i + 1;
            end

            i = 0;
            while (ledalive === 0 && i < 2048) begin
                @(posedge clk);
                #1;
                if (ledalive === 1) break;
                i = i + 1;
            end
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verify pulse width is 1 clock cycle", test_num);
            reset_dut();
            ce = 1;
            i = 0;

            while (i < 2048) begin
                @(posedge clk);
                #1;
                if (ledalive === 1) break;
                i = i + 1;
            end

            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verify periodicity is 1024 cycles", test_num);
            reset_dut();
            ce = 1;
            i = 0;

            while (i < 2048) begin
                @(posedge clk);
                #1;
                if (ledalive === 1) break;
                i = i + 1;
            end

            repeat(1024) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verify ce gates ledalive output", test_num);
            reset_dut();
            ce = 1;

            i = 0;
            while (i < 2048) begin
                @(posedge clk);
                #1;
                if (ledalive === 1) break;
                i = i + 1;
            end

            ce = 0;
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ledctr Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input expected_ledalive;
        begin
            if (expected_ledalive === (expected_ledalive ^ ledalive ^ expected_ledalive)) begin
                $display("PASS");
                $display("  Outputs: ledalive=%b",
                         ledalive);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ledalive=%b",
                         expected_ledalive);
                $display("  Got:      ledalive=%b",
                         ledalive);
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
        $dumpvars(0,ce, clk, ledalive);
    end

endmodule
