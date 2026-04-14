`timescale 1ns/1ps

module clock_gate_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg te;
    wire enclk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    clock_gate dut (
        .clk(clk),
        .en(en),
        .te(te),
        .enclk(enclk)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            en = 0;
            te = 0;

            repeat (2) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: en=0, te=0", test_num);
            reset_dut();
            en = 0;
            te = 0;
            repeat (2) @(posedge clk);
            #2;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: en=1, te=0", test_num);
            reset_dut();
            en = 1;
            te = 0;
            repeat (2) @(posedge clk);
            #2;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: en=0, te=1", test_num);
            reset_dut();
            en = 0;
            te = 1;
            repeat (2) @(posedge clk);
            #2;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: en=1, te=1 (Clock Enabled)", test_num);
            reset_dut();
            en = 1;
            te = 1;

            repeat (2) @(posedge clk);
            #2;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Transition en=1 to en=0 (te=1)", test_num);
            reset_dut();

            en = 1;
            te = 1;
            repeat (2) @(posedge clk);

            @(negedge clk);
            en = 0;
            repeat (2) @(posedge clk);
            #2;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Verify low phase (en=1, te=1)", test_num);
            reset_dut();
            en = 1;
            te = 1;
            repeat (2) @(posedge clk);
            @(negedge clk);
            #2;
            #1;

            check_outputs(0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("clock_gate Testbench");
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
        input expected_enclk;
        begin
            if (expected_enclk === (expected_enclk ^ enclk ^ expected_enclk)) begin
                $display("PASS");
                $display("  Outputs: enclk=%b",
                         enclk);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: enclk=%b",
                         expected_enclk);
                $display("  Got:      enclk=%b",
                         enclk);
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
        $dumpvars(0,clk, en, te, enclk);
    end

endmodule
