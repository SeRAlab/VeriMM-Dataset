`timescale 1ns/1ps

module shift_register4_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] d;
    reg sh;
    wire [3:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register4 dut (
        .clk(clk),
        .d(d),
        .sh(sh),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            sh = 0;
            d = 4'b0000;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test Case 1: Parallel Load 4'b1010");
            sh = 0;
            d = 4'b1010;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test Case 2: Load 0001 then Shift Left once");

            sh = 0;
            d = 4'b0001;
            @(posedge clk);

            sh = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test Case 3: Load 0001 then Shift Left 3 times");

            sh = 0;
            d = 4'b0001;
            @(posedge clk);

            sh = 1;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test Case 4: Shift then Parallel Load override");

            sh = 0;
            d = 4'b1111;
            @(posedge clk);

            sh = 1;
            @(posedge clk);

            sh = 0;
            d = 4'b0101;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0101);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test Case 5: Shift 4 times to empty register");

            sh = 0;
            d = 4'b1000;
            @(posedge clk);

            sh = 1;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_register4 Testbench");
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
        $dumpvars(0,clk, d, sh, q);
    end

endmodule
