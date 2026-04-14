`timescale 1ns/1ps

module johnson_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    wire [3:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    johnson_counter dut (
        .clk(clk),
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
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Initial state after reset", test_num);
            reset_dut();
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: After 1 clock cycle", test_num);
            reset_dut();
            @(posedge clk); #1;
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: After 2 clock cycles", test_num);
            reset_dut();
            repeat(2) @(posedge clk); #1;
            #1;

            check_outputs(4'b1100);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: After 3 clock cycles", test_num);
            reset_dut();
            repeat(3) @(posedge clk); #1;
            #1;

            check_outputs(4'b1110);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: After 4 clock cycles (Full of 1s)", test_num);
            reset_dut();
            repeat(4) @(posedge clk); #1;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: After 5 clock cycles", test_num);
            reset_dut();
            repeat(5) @(posedge clk); #1;
            #1;

            check_outputs(4'b0111);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: After 6 clock cycles", test_num);
            reset_dut();
            repeat(6) @(posedge clk); #1;
            #1;

            check_outputs(4'b0011);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: After 7 clock cycles", test_num);
            reset_dut();
            repeat(7) @(posedge clk); #1;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Wrap-around after 8 clock cycles", test_num);
            reset_dut();
            repeat(8) @(posedge clk); #1;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: After 9 clock cycles (2nd cycle start)", test_num);
            reset_dut();
            repeat(9) @(posedge clk); #1;
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: After 12 clock cycles (2nd cycle 1111)", test_num);
            reset_dut();
            repeat(12) @(posedge clk); #1;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: After 15 clock cycles", test_num);
            reset_dut();
            repeat(15) @(posedge clk); #1;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase013;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: After 16 clock cycles (Double full cycle)", test_num);
            reset_dut();
            repeat(16) @(posedge clk); #1;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase014;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset persistence check", test_num);
            reset_dut();
            reset = 1;
            repeat(5) @(posedge clk); #1;
            #1;

            check_outputs(4'b0000);
            reset = 0;
        end
        endtask

    task testcase015;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset during operation", test_num);
            reset_dut();
            repeat(4) @(posedge clk);
            reset = 1;
            @(posedge clk); #1;
            #1;

            check_outputs(4'b0000);
            reset = 0;
        end
        endtask

    task testcase016;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Step after mid-operation reset", test_num);
            reset_dut();
            repeat(4) @(posedge clk);
            reset = 1;
            @(posedge clk);
            reset = 0;
            @(posedge clk); #1;
            #1;

            check_outputs(4'b1000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("johnson_counter Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        testcase011();
        testcase012();
        testcase013();
        testcase014();
        testcase015();
        testcase016();
        
        
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
        input [3:0] expected_q;
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
        $dumpvars(0,clk, reset, q);
    end

endmodule
